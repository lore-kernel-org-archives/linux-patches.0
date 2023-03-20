Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E021C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F932C433D2;
	Mon, 20 Mar 2023 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326079;
	bh=lWW/VY38AlwU6YHPeRlP42qLae9QEwTaW8/ZpqJFjeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9kGKaCL9JhQeyZXdr6ArhwxbVeS+57QWXF7E8dkpTvVkm9ezGqXn3FUZHAwlVIrt
	 pItAbe8FRiyKE/PyYvJzqAMPjfV8fRKVUlprZkTEDao3b7eVOC+VW6qqatxciS4/3K
	 M6P/+8QK4AZk1EfU1z0yRzm7s/nMhBhoqH46MU0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.1 196/198] virt/coco/sev-guest: Convert the sw_exit_info_2 checking to a switch-case
Date: Mon, 20 Mar 2023 15:55:34 +0100
Message-Id: <20230320145515.684303331@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit fa4ae42cc60a7dea30e8f2db444b808d80862345 upstream.

snp_issue_guest_request() checks the value returned by the hypervisor in
sw_exit_info_2 and returns a different error depending on it.

Convert those checks into a switch-case to make it more readable when
more error values are going to be checked in the future.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230307192449.24732-8-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2210,15 +2210,21 @@ int snp_issue_guest_request(u64 exit_cod
 		goto e_put;
 
 	*fw_err = ghcb->save.sw_exit_info_2;
-	if (ghcb->save.sw_exit_info_2) {
+	switch (*fw_err) {
+	case 0:
+		break;
+
+	case SNP_GUEST_REQ_INVALID_LEN:
 		/* Number of expected pages are returned in RBX */
-		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
-		    ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN) {
+		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
 			input->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
-		} else {
-			ret = -EIO;
+			break;
 		}
+		fallthrough;
+	default:
+		ret = -EIO;
+		break;
 	}
 
 e_put:


