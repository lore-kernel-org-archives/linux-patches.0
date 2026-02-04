Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E4D3C1963;
	Wed,  4 Feb 2026 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218088; cv=none; b=SqnRhd5aiHIAUVNgcPziHbqu8xau4fXP5oUJlsSlY3i4bJvWdmgTHA2z47eFuRvmOYZQlYwmSdKy4uH2bKVdCEfUPXZAij4KF24lxg/Eaevh9zpXAa8nCt/YsjDiSen9MmcGetwzsRiiYWNytLNpXONcSnzYYISplo1Krx07Obk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218088; c=relaxed/simple;
	bh=EXMhfTRz0ciSezjh0Wd97lKCu3icnboPdM7zI88bK3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/HBedYKHSpmPkMyzr0XxgnqdMZ8HHpfoAEZi/xn81gGJVuYNhCNyjMOZ54H1ZpuglIcfp9AWo4GMhBub5hrxg4M7d+5ee/xnIcFwnNk6oZ1pFD72/Vi2oLFBUylJNTwul38dQhWclSyIOPzhpnoDPQ3qDF3qbsZ5wd0XreZV8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPGGKgJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPGGKgJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BFCC4CEF7;
	Wed,  4 Feb 2026 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218088;
	bh=EXMhfTRz0ciSezjh0Wd97lKCu3icnboPdM7zI88bK3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPGGKgJGIvQGJ8bKiHslor+ZMA1xX/KJKLpciQIQEFOv5UtV1C342U+zOSH29wvrz
	 bytbV7JcD2CMv1Z+b0wp2jYDoekiHSwQdXmjk5SNO9qAwoazVaxtsKzBaaNs3uJFGF
	 kjlxZC6maqpE4PDoQkL33tEitk9gD2Zz4jU1aPbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 209/280] scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()
Date: Wed,  4 Feb 2026 15:39:43 +0100
Message-ID: <20260204143917.121005178@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 4747bafaa50115d9667ece446b1d2d4aba83dc7f upstream.

If nonemb_cmd->va fails to be allocated, free the allocation previously
made by alloc_mcc_wrb().

Fixes: 50a4b824be9e ("scsi: be2iscsi: Fix to make boot discovery non-blocking")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1025,6 +1025,7 @@ unsigned int beiscsi_boot_get_sinfo(stru
 					      &nonemb_cmd->dma,
 					      GFP_KERNEL);
 	if (!nonemb_cmd->va) {
+		free_mcc_wrb(ctrl, tag);
 		mutex_unlock(&ctrl->mbox_lock);
 		return 0;
 	}


