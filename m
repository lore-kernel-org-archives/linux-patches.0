Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C6E263C83;
	Tue,  8 Apr 2025 11:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113506; cv=none; b=OnI3aZo1rUltgS6cdQXgTEMLH+lJ8BjJrmXNMuY35EkXCCQTduK/0TMv4cD9FuKQfIXqEN1x+smrAcYSqW3kxk4LJ2awxn4GkB/wKqtZ+XHVFHuFDY/LNjGKcNVbl8G9hvqP7q9fySKBM4gMnwGocowjFb5vRqr/OgiR64IhZXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113506; c=relaxed/simple;
	bh=YGvTEsWhJuEn7+EvGy1pvcRQ2WwweZcdJUAA6wz885k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azgeokbIZ2/NLLk6rD8iopEyZNIM2ISquMW9ieh9Zvv/LIkzrcT8IBvK+tFb9Cr3ciqlu1EdZ6WV8S3ESJqpKN/9vIIeg+Dc72M2UApQQnvYd0ql4H0cd8TF+RwB436zGki9Z6eY+blGO/mg/AujDhR9Xku/Ydh84C1bfikiSaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1zvHb5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1zvHb5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004EBC4CEE5;
	Tue,  8 Apr 2025 11:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113505;
	bh=YGvTEsWhJuEn7+EvGy1pvcRQ2WwweZcdJUAA6wz885k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1zvHb5jVj0dAhcmboKraSaJQXXLF1jZ2uYEk7osr0OT6J8q31orWCrnPCISwBnhA
	 +ZKudz+8DanDkm4lCRlzk5L1ytd1BTgTava45aEsmGqGKFeKbzJMdaqNwZ5mlN3n4x
	 SG1F1PbsLgg4x1c2QaUqTE73VraZlIurMudBcVIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/268] x86/hyperv: Fix output argument to hypercall that changes page visibility
Date: Tue,  8 Apr 2025 12:49:54 +0200
Message-ID: <20250408104833.486799654@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit 09beefefb57bbc3a06d98f319d85db4d719d7bcb ]

The hypercall in hv_mark_gpa_visibility() is invoked with an input
argument and an output argument. The output argument ostensibly returns
the number of pages that were processed. But in fact, the hypercall does
not provide any output, so the output argument is spurious.

The spurious argument is harmless because Hyper-V ignores it, but in the
interest of correctness and to avoid the potential for future problems,
remove it.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250226200612.2062-2-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250226200612.2062-2-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/ivm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 8c6bf07f7d2b8..e50e43d1d4c87 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -464,7 +464,6 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
 			   enum hv_mem_host_visibility visibility)
 {
 	struct hv_gpa_range_for_visibility *input;
-	u16 pages_processed;
 	u64 hv_status;
 	unsigned long flags;
 
@@ -493,7 +492,7 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
 	memcpy((void *)input->gpa_page_list, pfn, count * sizeof(*pfn));
 	hv_status = hv_do_rep_hypercall(
 			HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY, count,
-			0, input, &pages_processed);
+			0, input, NULL);
 	local_irq_restore(flags);
 
 	if (hv_result_success(hv_status))
-- 
2.39.5



