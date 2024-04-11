Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE02EAE5;
	Thu, 11 Apr 2024 10:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830713; cv=none; b=Iehffn5OZ7qVBDgb8C6POr7UTokXaJGBXuLQJLCoSJmFmljQD4YL/6aGQlzaWszPoK748wfMxCz4chFLA5Ayy5zwTVqxi2dbpg4cN+P1dC2+N5bhBMSKj7+L5cvLEiakNNrdedaYSmygvvsX6ecgtM/9kCHOpJ2LXK+FF8a+rWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830713; c=relaxed/simple;
	bh=kGq6VtZFacPF0VPunw5ye0B1ihlQOOkDJhWwwxLwa80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZsbV2YeE3x02qOTm/wNbPodGHPepIgMmdBZvw/hXMQ7Ril2zhff/GihBnJDBeI3SdMG/5RyW5Yr6fUA7F4IR1o1KbDcD9WdArO/ovy6Eu1KltnuLkXXRidVfLXcUVGpV4W4xMnwI0gLxZ1z8pav/C3MosI7AUukwxrf1EXRs2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8mE+aMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8mE+aMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700E6C433C7;
	Thu, 11 Apr 2024 10:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830712;
	bh=kGq6VtZFacPF0VPunw5ye0B1ihlQOOkDJhWwwxLwa80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8mE+aMSVGPl7ASnIXXHR3Dt5o5gUGYsJOiSQ3NgNqRFk0RcfyxwovZQduGKllc4J
	 5xrgJbyfUC0k3883YoaQ+gMgV8BDSRIakjDh8hP//btHkGDjf9YHRqU3OL/dn1d6HX
	 AxriacbJobV21dZ86vD9GDGwAbcvirj/UwdnQIig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Rui Qi <qirui.001@bytedance.com>
Subject: [PATCH 5.4 092/215] objtool: is_fentry_call() crashes if call has no destination
Date: Thu, 11 Apr 2024 11:55:01 +0200
Message-ID: <20240411095427.667644876@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Chartre <alexandre.chartre@oracle.com>

commit 87cf61fe848ca8ddf091548671e168f52e8a718e upstream.

Fix is_fentry_call() so that it works if a call has no destination
set (call_dest). This needs to be done in order to support intra-
function calls.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20200414103618.12657-2-alexandre.chartre@oracle.com
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1367,7 +1367,7 @@ static int decode_sections(struct objtoo
 
 static bool is_fentry_call(struct instruction *insn)
 {
-	if (insn->type == INSN_CALL &&
+	if (insn->type == INSN_CALL && insn->call_dest &&
 	    insn->call_dest->type == STT_NOTYPE &&
 	    !strcmp(insn->call_dest->name, "__fentry__"))
 		return true;


