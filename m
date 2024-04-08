Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCF87EF00;
	Mon,  8 Apr 2024 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583891; cv=none; b=DkJQsb9QAKy7yKY7uzen/YlU1rpZID8phpaFLZ//VhfFrOx/151zV2kKwcIuZObyoAXbyBdC6ashj0A8Rs2BbC8x7tdMho6G+zgtgUmTaD4xV12GoXzJLGWxy5tmQSmMFWQGxusWkCR7p4kEGCgdiqr2eLOXdMtFE6wafb0THJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583891; c=relaxed/simple;
	bh=E1YqlCmK4jSMEkV989iv98aqXVvikZT379EQ3ctjvKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWbJCo6Ch94VmGVDmMRHmSpJ24W0p8m3eAtD/vMV2o6299vC6zOZ64XsZ+Nr7NsxoylWJ01ReyApX1UMcfAqiA00nligdD5u4utnjPSyUp9k0i5whHP17AeU7buCZfpkhcDNo/G3eal+XCtaq1zpDob/4CCwPoQp2OH1h7kPNF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nyw3x5yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nyw3x5yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871D4C433C7;
	Mon,  8 Apr 2024 13:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583890;
	bh=E1YqlCmK4jSMEkV989iv98aqXVvikZT379EQ3ctjvKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nyw3x5ybd0/nplNzkva6y9PyoBgerjbxcJvNmYIgnJYtt7drCiwyQDMKHvUG3461F
	 KZ7iITQ34IgFvvhx3mHWPIWO3T+NQyos83AepD9zvX5kKDUJeevl2UMvKw5RWWyJ3U
	 YgYGshh6uxnNBCy47s4GYehtfW4rCvWE1nNR/V5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 246/252] bpf: put uprobe links path and task in release callback
Date: Mon,  8 Apr 2024 14:59:05 +0200
Message-ID: <20240408125314.293365955@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit e9c856cabefb71d47b2eeb197f72c9c88e9b45b0 upstream.

There is no need to delay putting either path or task to deallocation
step. It can be done right after bpf_uprobe_unregister. Between release
and dealloc, there could be still some running BPF programs, but they
don't access either task or path, only data in link->uprobes, so it is
safe to do.

On the other hand, doing path_put() in dealloc callback makes this
dealloc sleepable because path_put() itself might sleep. Which is
problematic due to the need to call uprobe's dealloc through call_rcu(),
which is what is done in the next bug fix patch. So solve the problem by
releasing these resources early.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240328052426.3042617-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3065,6 +3065,9 @@ static void bpf_uprobe_multi_link_releas
 
 	umulti_link = container_of(link, struct bpf_uprobe_multi_link, link);
 	bpf_uprobe_unregister(&umulti_link->path, umulti_link->uprobes, umulti_link->cnt);
+	if (umulti_link->task)
+		put_task_struct(umulti_link->task);
+	path_put(&umulti_link->path);
 }
 
 static void bpf_uprobe_multi_link_dealloc(struct bpf_link *link)
@@ -3072,9 +3075,6 @@ static void bpf_uprobe_multi_link_deallo
 	struct bpf_uprobe_multi_link *umulti_link;
 
 	umulti_link = container_of(link, struct bpf_uprobe_multi_link, link);
-	if (umulti_link->task)
-		put_task_struct(umulti_link->task);
-	path_put(&umulti_link->path);
 	kvfree(umulti_link->uprobes);
 	kfree(umulti_link);
 }


