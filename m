Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA451C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E62EC433EF;
	Mon, 20 Mar 2023 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326241;
	bh=TyN5NO7EWyDXC/jJe/OBArE6iGCuFaNI5iV2RfuG0DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVD2L/JXep12jeyBFA+nv0OOHjxR03M19H609fGmN4/qdN1BIym9nfvjPGpsFCK51
	 RSJsuQDgppqgu1JxqJPJpjKe76GVSVXtSorSTcEl4dJLZb+SQYb0K4ZLm1+L+H3bS+
	 NKrc9Qjsrcv59t8tENSfuu03dBgceg987uwj+7QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.2 205/211] virt/coco/sev-guest: Check SEV_SNP attribute at probe time
Date: Mon, 20 Mar 2023 15:55:40 +0100
Message-Id: <20230320145522.125165448@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

commit d6fd48eff7506bb866a54e40369df8899f2078a9 upstream.

No need to check it on every ioctl. And yes, this is a common SEV driver
but it does only SNP-specific operations currently. This can be
revisited later, when more use cases appear.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20230307192449.24732-3-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev.c                   |    3 ---
 drivers/virt/coco/sev-guest/sev-guest.c |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2183,9 +2183,6 @@ int snp_issue_guest_request(u64 exit_cod
 	struct ghcb *ghcb;
 	int ret;
 
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		return -ENODEV;
-
 	if (!fw_err)
 		return -EINVAL;
 
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -703,6 +703,9 @@ static int __init sev_guest_probe(struct
 	void __iomem *mapping;
 	int ret;
 
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return -ENODEV;
+
 	if (!dev->platform_data)
 		return -ENODEV;
 


