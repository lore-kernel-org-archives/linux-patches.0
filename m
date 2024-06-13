Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1083209;
	Thu, 13 Jun 2024 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281801; cv=none; b=RbR9hC0PhgGm6Zbdcvs/k/RQeiMh88fdwt6lsIA+Mp8on2V3Vx+/erh4kishHjgI7ybi+dm56nPrj0xqN0jTktS6zojuV9GEBREnY/Mx6GDvxwZClKs8gbezW62Ax+Pgnlct0SaiDI/p3l8oH+rU5TS8y4xvs+DgbjZ314111yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281801; c=relaxed/simple;
	bh=UPk+gMWcc41r2KB9ZPsC8tfJ6kbJgF2JZ6ORq7usOEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8LVpDNwvqexVxsca1PI42YJ2RjkUgSsolT+9I6pmnnTpfqWiWngbt9ws84hikiLk29rZabBUssJV+VqDclHhZJn923upEa49rMfQA/WtCJh1YsUc3g/m4K6kfOZlsmc3idQlMFFFirkzECAEeyj2iL38sSzoa/L1EH5r6RGq0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXa5M32r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXa5M32r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A89C2BBFC;
	Thu, 13 Jun 2024 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281801;
	bh=UPk+gMWcc41r2KB9ZPsC8tfJ6kbJgF2JZ6ORq7usOEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXa5M32r8HQ1F3HwtNjZOJmEkrki04fApFict8TvEQsSdQuzojrpn1l1lQ+yVIbhB
	 WH7ibkUKj+NSeSKR/N7Dm4tSJapQUeQUFlUp5MgmCJooSyNctpC9M74jCFE6bzwIYf
	 7O+9p9l/MzVeTImRKMWVHzfZJ7BFLnF/+GylCJtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/402] scsi: ufs: qcom: Perform read back after writing unipro mode
Date: Thu, 13 Jun 2024 13:30:18 +0200
Message-ID: <20240613113304.517163302@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/ufs/ufs-qcom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index fb82a27ac9aaa..ce45f3e8a35c3 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -245,9 +245,6 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 
 	if (host->hw_ver.major == 0x05)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
-
-	/* make sure above configuration is applied before we return */
-	mb();
 }
 
 /*
-- 
2.43.0



