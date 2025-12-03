Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD0435E551;
	Wed,  3 Dec 2025 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779270; cv=none; b=JVrD/R/PLdl74UDSEQ50jnbbx5vdiZYJunXaxwpruObrI0lrtiw7zUSXI8FzeszwFvp76xoW1T/yY8N4aj8ZnDh4xlmWltKCxqD+Ffu2gMtNf9xu0SJc9TMz4+OmXQrHbCCERKiMy9s0whEdWPAxtRTsN5b8xH3U0TYiohM9cN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779270; c=relaxed/simple;
	bh=CwgyjHJdgxJjLFdmUhgvSOrPPg2xwVfhvEBlWwEQDbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqQvMkmy5u6vt0bKv/DMJs/ooSzfsSvbPhgNAADqIGbaQuVtt/v+wbFRTHRLz6ndNxE7SJNfEgzQDRd+zMpSqg0Pg7AVo6zkQhNfk0wC2UaadG+CFzGv/2GlsnwQ0cVjviMDvfG3MU2Ks+o94qhsMRkX2g1nm37f9tAaUEq6krA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtwfeJre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtwfeJre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A4DC4CEF5;
	Wed,  3 Dec 2025 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779270;
	bh=CwgyjHJdgxJjLFdmUhgvSOrPPg2xwVfhvEBlWwEQDbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtwfeJrerxQTGhGi6x/b99gYpyw9io1HN7lAQ1VHqnejWeykcIlEFTIRNlKCpeTJ4
	 a2Y+/YqflMxdyAuRNtWdIcTU+pcbmnXat+SCAaPbjZy6n23RMIvQiebHj4WU+aV0eI
	 CRO4EwOl1hA3VSTXpK7/fBpqC8TG4hTCBoaKffsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/568] scsi: ufs: host: mediatek: Enhance recovery on resume failure
Date: Wed,  3 Dec 2025 16:23:28 +0100
Message-ID: <20251203152448.270480720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 1c6348ee58092..3dbcb30e610fc 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1359,8 +1359,21 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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



