Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDB036BCEC;
	Tue, 16 Dec 2025 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887439; cv=none; b=hlpQcRv7QE9AQLVC3U38r770gN50ml4AWJAxIOYvukr9Wk7F1OgoAT0qMUNdIEm8tOVLYL2KgDMbMIgp7fkro+WE/uWNM5CmOvbJdEGjldo3LJtOEghRyIoqgyQyYeBV+ceRwmfSiby/TjkMhDqSswQCpWq3Ux2zT852/Ly2Xmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887439; c=relaxed/simple;
	bh=OZzuleOfQx0e+HM7qm5csu/jf+YjrDuVzlLzOkvB6+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxeWhtnhBvqOvhneR3fOEebK1zMW4Uqb4OGQIuVBb1ctx8OgV/3dVdKT/Mumc5gQ+1WWLTavXesue2HcpNUGlwtM8IQFwm/pAOe5SbTx0hDinzBMSQyZYuNC4Q/JRbhgTJPFEcQbkAl2/p4mC01Jf3CLd7vZloaOYbXBbTj0qhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4f7X7y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4f7X7y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800DFC16AAE;
	Tue, 16 Dec 2025 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887439;
	bh=OZzuleOfQx0e+HM7qm5csu/jf+YjrDuVzlLzOkvB6+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4f7X7y4wtQL8f//z/xL/Lt4Lhbs1LSB72jROG5O+3M/OSlZVdCwTrwkAfO8Lu3SN
	 aaf7dfKIJETYkoNY51Nbv1kMObMeGb308kAmaCx3yQINrtrMSK+sQSVrjwRLV/icv6
	 6cuyoytNARRTDEoVQybdKxP3Ro2Y3Bb0bVVycS14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 230/614] scsi: stex: Fix reboot_notifier leak in probe error path
Date: Tue, 16 Dec 2025 12:09:57 +0100
Message-ID: <20251216111409.703991487@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 20da637eb545b04753e20c675cfe97b04c7b600b ]

In stex_probe(), register_reboot_notifier() is called at the beginning,
but if any subsequent initialization step fails, the function returns
without unregistering the notifier, resulting in a resource leak.

Add unregister_reboot_notifier() in the out_disable error path to ensure
proper cleanup on all failure paths.

Fixes: 61b745fa63db ("scsi: stex: Add S6 support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251104094847.270-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/stex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index d8ad02c293205..e02f28e5a104e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1844,6 +1844,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_scsi_host_put:
 	scsi_host_put(host);
 out_disable:
+	unregister_reboot_notifier(&stex_notifier);
 	pci_disable_device(pdev);
 
 	return err;
-- 
2.51.0



