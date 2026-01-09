Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F95B35A94E;
	Fri,  9 Jan 2026 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960951; cv=none; b=hDEmJgwH2GmBbLwwnPdl74U7OpHe8bQA4w8jp1C+3can1qRuQH3YSNl1F8YPH8c0xmu30k4U68nI1N/Q76qgjpHirDTk/HMTPRsprHCEsUe8r1pS9oKW/OwIrx9RkU0ivKDBhCNYZV6bi/4RCyUaGUzJ6obH49qThyjoLCc4Aws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960951; c=relaxed/simple;
	bh=G0YH6oaRNKFvq84xWme+GXJqy9nK2P34X2UXh8fqP2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkpssE3f/4u26pf6Uk6v53alZS7+E7t+wwWlT/pif4ZNPqf/cBPBJYKlE2tFooBcmX7wUTvVG9hpDip3o3OgmluGsePYVbrMsW+oAkobj4kjghdBdubJm0N4zFQBMPUvgDuo0kAPXD41h1Y45qt0mIMNtFX+UpXy772i4QROQIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7PIS7iZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7PIS7iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34D6C4CEF1;
	Fri,  9 Jan 2026 12:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960951;
	bh=G0YH6oaRNKFvq84xWme+GXJqy9nK2P34X2UXh8fqP2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7PIS7iZKY1tZvxK+hRijXP4wJj4M4Pr/TbOUbBuZbJPAP6BtbaTPDK3BC/g1Fpn0
	 L2V4DI12PwosiMmCS4QPlHY5fTcOjKAf3J3hprN4kDjmR+podt31rgOIdWuDqpUYbd
	 UzpG8xXZy8+k6lRVAuHCNPnVTKDv4z7JUfXupfE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 583/737] media: cec: Fix debugfs leak on bus_register() failure
Date: Fri,  9 Jan 2026 12:42:02 +0100
Message-ID: <20260109112155.932024941@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit c43bcd2b2aa3c2ca9d2433c3990ecbc2c47d10eb upstream.

In cec_devnode_init(), the debugfs directory created with
debugfs_create_dir() is not removed if bus_register() fails.
This leaves a stale "cec" entry in debugfs and prevents
proper module reloading.

Fix this by removing the debugfs directory in the error path.

Fixes: a56960e8b406 ("[media] cec: add HDMI CEC framework (core)")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -449,6 +449,7 @@ static int __init cec_devnode_init(void)
 
 	ret = bus_register(&cec_bus_type);
 	if (ret < 0) {
+		debugfs_remove_recursive(top_cec_dir);
 		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
 		pr_warn("cec: bus_register failed\n");
 		return -EIO;


