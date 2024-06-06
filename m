Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2A196D8C;
	Thu,  6 Jun 2024 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683243; cv=none; b=BjWj4qHmJMVQGmOsPtl5EdYf4FZFP7VeBstVM9ixKlzf0/eJ8DRoOxfipbZy+O81fnhzZfGLXsf97ul8lXbEzNsXVRETVxeeu8L3jiz0xcQwS/L1Xi1TZPpKlXcDq/ftI8vVqmjPCXAKK97q9d/7upDvhbQDvFLi+J7VbMwWp0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683243; c=relaxed/simple;
	bh=bM/hYyGw+K0uJvJSEWIYGjV302OgxXuAQQgSpqvyq8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=celhDbbaYVmYjnJM9T35oZF3MW2bRO8403i0QYYPUt4pxMw6GXmZ27POVbMQYijplzJtdpA9oShkzHM03BNWCHiLhiR1B2ckkNWZloE2uFtuDMj1K1oPOMRvP/TrJZPrdGGN1M7JBBgYBD2Ws3yr27Wr7i/hTP2UdoLWDiTlP/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPMUm4VQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPMUm4VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700C9C2BD10;
	Thu,  6 Jun 2024 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683243;
	bh=bM/hYyGw+K0uJvJSEWIYGjV302OgxXuAQQgSpqvyq8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPMUm4VQmLvLhNf9Z80bCc2gfS8LQvh18eMGxrjeARR07hMLOxLv6HeMsyeynWkk5
	 gfYW7t7Vdr/UVv8wCUW4tYYhD1XsxYsxZZB6D9YYI4GPX01gWySqiHE672z2VgRZ0L
	 J62tFr7Cd3N3EZUzgQwkkWaCMp3UJu09Q1W7fkWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/473] scsi: ufs: qcom: Perform read back after writing unipro mode
Date: Thu,  6 Jun 2024 16:00:36 +0200
Message-ID: <20240606131703.454490996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 823150ecf04f958213cf3bf162187cd1a91c885c ]

Currently, the QUNIPRO_SEL bit is written to and then an mb() is used to
ensure that completes before continuing.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

But, there's really no reason to even ensure completion before
continuing. The only requirement here is that this write is ordered to this
endpoint (which readl()/writel() guarantees already). For that reason the
mb() can be dropped altogether without anything forcing completion.

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-4-181252004586@redhat.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index ce18c43937a22..edbd3d7cf83aa 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -229,9 +229,6 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 
 	if (host->hw_ver.major == 0x05)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
-
-	/* make sure above configuration is applied before we return */
-	mb();
 }
 
 /*
-- 
2.43.0



