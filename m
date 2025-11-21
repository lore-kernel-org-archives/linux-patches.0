Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E16F3446A0;
	Fri, 21 Nov 2025 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732728; cv=none; b=o+9aV8qHXC74mfTxjLQDcbskPRc8a/l3pY+SrJgC5ZH17rX9KfBoXY+KtkuTQoOiW+9K0RiZTTIOQth6dTxKMjIU1KM+s00nAX1BsYKzK7vdffIT8DLAOC5TYBQgf63WnlrORhSmVuU3HG8PUZB0wlRUnKDsjul2YWOBVXI6h6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732728; c=relaxed/simple;
	bh=5m3+L2vDNg0MmrAL5R+HRhRHH+NIAA8TsXxg2n60sUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfrfUMo0Bs5e8sVE9JkpRbyakCaxZzJTTbnWmv/ea3x/qd3aJS1cpbOPbq0KDtFo3/4qjHYMKXke5qY8cClWg2nexvCfcDDR3MZN7eeilY8Sg0te3kYPHiyGudtlG5XwWecmnf3Vpyu2A/g20Cosg2QS8iffyYY75pV31Hq5XkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwO/9AYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwO/9AYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900CFC4CEF1;
	Fri, 21 Nov 2025 13:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732728;
	bh=5m3+L2vDNg0MmrAL5R+HRhRHH+NIAA8TsXxg2n60sUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwO/9AYeu2vcPgzPYfIZspdSFKqLiDXJc/iHQh6U1sHqWKf5iF5Gpj/n6xyCQbABS
	 8ziX5/6T84KU4mYvbXdXSkF8IDqWoMN7L4hjCO0lj9zeGzc/MAdJXyKlSXLVj7woYm
	 NzxeUupnPvdmmx2hJ01F2pBh+b+dulJVG+pRkVVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 205/529] scsi: ufs: host: mediatek: Enhance recovery on resume failure
Date: Fri, 21 Nov 2025 14:08:24 +0100
Message-ID: <20251121130238.311969931@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 15ef3f5aa822f32524cba1463422a2c9372443f0 ]

Improve the recovery process for failed resume operations. Log the
device's power status and return 0 if both resume and recovery fail to
prevent I/O hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 7ede6531bf40c..6f2e5b83ff0c9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1444,8 +1444,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	return 0;
+
 fail:
-	return ufshcd_link_recovery(hba);
+	/*
+	 * Check if the platform (parent) device has resumed, and ensure that
+	 * power, clock, and MTCMOS are all turned on.
+	 */
+	err = ufshcd_link_recovery(hba);
+	if (err) {
+		dev_err(hba->dev, "Device PM: req=%d, status:%d, err:%d\n",
+			hba->dev->power.request,
+			hba->dev->power.runtime_status,
+			hba->dev->power.runtime_error);
+	}
+
+	return 0; /* Cannot return a failure, otherwise, the I/O will hang. */
 }
 
 static void ufs_mtk_dbg_register_dump(struct ufs_hba *hba)
-- 
2.51.0



