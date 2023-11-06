Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA29E200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFtjFdUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359F7C433C8;
	Mon,  6 Nov 2023 13:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276004;
	bh=AE//UPOHHy+cLU5FCz+5m7uwWbVh29ZRMlh2DVBmgGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFtjFdURfR5VsnUgQiAaxaEVHyK2XbAFN00K4iKXTvEGCgn78D8nbS+uBUeZjiy42
	 XATKJODaAOsNn0sxHy3eInRYftFRRC3XZOgOTnpuWBKxfwauVTlfeIZbxSHupwC8ag
	 Mm3JUqRPVjR7WQxEHDemd26N1dfkzoBeOAesCf8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/48] scsi: mpt3sas: Fix in error path
Date: Mon,  6 Nov 2023 14:03:28 +0100
Message-ID: <20231106130259.124374416@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
References: <20231106130257.862199836@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit e40c04ade0e2f3916b78211d747317843b11ce10 ]

The driver should be deregistered as misc driver after PCI registration
failure.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20231015114529.10725-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8fb7491c5bc02..0bccc4a12e53b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9482,8 +9482,10 @@ _mpt3sas_init(void)
 	mpt3sas_ctl_init(hbas_to_enumerate);
 
 	error = pci_register_driver(&mpt3sas_driver);
-	if (error)
+	if (error) {
+		mpt3sas_ctl_exit(hbas_to_enumerate);
 		scsih_exit();
+	}
 
 	return error;
 }
-- 
2.42.0



