Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0D4442C;
	Wed, 30 Jul 2025 09:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869164; cv=none; b=rop5H3wekrLzysA5tb5f1vpF4EMG6o1hv0PGv2HUy2OaEY73jsmibXhfSAWiNzZf9M4n+iOefhxy23EG1U5+JqbDmlLGEzlquA1DTY9+Ch9IbKU7oVAF6wNySQnBHu/ctXMzM/+f9i3cH+QYSSukXyAGlNTTslGEGjGYzgy7QqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869164; c=relaxed/simple;
	bh=5TyhXNqeaT+DIy5JRlmLKHKJMQnUFOSwrdzwubI6sIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw9u889HK7blU8TMoP7bxBwjVV4jI+jnAhZcnfw1/5qAYZYT+nGGAYU3Jhiit2+eg7WnAExEnmVzIpQvj5H8bxeSGNlNldZYuXxgVgY9N1vl+fkbv8WsZJLViXaMaEPaFAEFzlOVB9/bmqwUN547XnqQHzpYm7u0p/ETrfwiLkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXW5UpZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXW5UpZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BC5C4CEF5;
	Wed, 30 Jul 2025 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869164;
	bh=5TyhXNqeaT+DIy5JRlmLKHKJMQnUFOSwrdzwubI6sIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXW5UpZrMcrpmSS9z3O+u+YkeFYZSjLvtENo2dAPM6ytg4l9ayKbPJNWnpDeaF0CD
	 Crbv0LtXN3JfDcOx9SEqVJmJ5yt+wIeZmqngQsziJRCxcjpR81h/MVvMuFu7VfHcIX
	 hPFsAwFZKMJCQ2d+gTlJqEXYJQPiBrTyo+9rcOYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Stefan Roesch <shr@devkernel.io>,
	xu xin <xu.xin16@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 52/92] mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()
Date: Wed, 30 Jul 2025 11:36:00 +0200
Message-ID: <20250730093232.766049405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 153ad566724fe6f57b14f66e9726d295d22e576d upstream.

After a recent change in clang to expose uninitialized warnings from const
variables [1], there is a false positive warning from the if statement in
advisor_mode_show().

  mm/ksm.c:3687:11: error: variable 'output' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   3687 |         else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
        |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/ksm.c:3690:33: note: uninitialized use occurs here
   3690 |         return sysfs_emit(buf, "%s\n", output);
        |                                        ^~~~~~

Rewrite the if statement to implicitly make KSM_ADVISOR_NONE the else
branch so that it is obvious to the compiler that ksm_advisor can only be
KSM_ADVISOR_NONE or KSM_ADVISOR_SCAN_TIME due to the assignments in
advisor_mode_store().

Link: https://lkml.kernel.org/r/20250715-ksm-fix-clang-21-uninit-warning-v1-1-f443feb4bfc4@kernel.org
Fixes: 66790e9a735b ("mm/ksm: add sysfs knobs for advisor")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2100
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3669,10 +3669,10 @@ static ssize_t advisor_mode_show(struct
 {
 	const char *output;
 
-	if (ksm_advisor == KSM_ADVISOR_NONE)
-		output = "[none] scan-time";
-	else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
+	if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
 		output = "none [scan-time]";
+	else
+		output = "[none] scan-time";
 
 	return sysfs_emit(buf, "%s\n", output);
 }


