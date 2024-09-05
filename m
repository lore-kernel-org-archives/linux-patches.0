Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD561198822;
	Thu,  5 Sep 2024 09:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529731; cv=none; b=hB1QcbTee42IeiymQW3AxIXmYUqQuZLHwVW6yijcUVp/UcSb+fRwdfdr1FhLfg78CPwMy+1omol9YSwY+sHe+daWG6fu7cRHTDj9JJHXyTl1mUTe5mUSYJVGM7gLgF7G2G+lbjZ4iTRZjl2bySjcihqIIuOeByMTO9AIpxV+p68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529731; c=relaxed/simple;
	bh=C/Ses7QeOAYV3/O7kuj/lcj9ejEwqCayWzPZX2p4Xds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSJvA1pSnzGXzqyhXFV/q3UqpICcEw679Fv4dF27PEeUyyNvCPfIi2SQo9QYz3JeGXOrOLDZjIXAPklC5VuFu6wUv4CvU9jSQ4GAdl7d7qKeXXJ3BiTgAVrRIaHtGaj4JId8bGO814J+8kvwngyY0JF62fqRy40j6rNfMeOy/n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRUn04Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRUn04Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B00C4CEC6;
	Thu,  5 Sep 2024 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529731;
	bh=C/Ses7QeOAYV3/O7kuj/lcj9ejEwqCayWzPZX2p4Xds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRUn04LvJ2mNjMEoUWf9Qdw/ojoTtVdsRLCVqonO1v2qxhgE7Ie6G6+t105VDrm0Z
	 z8aJnHsxAmPXIq/qaZrJF6t2pawn2g3vzd3XhBDDeWvWiZMgzl79HlDt0Vr7XTxjO1
	 RoioQzojCr5CJZp0NSBEBVjq/QmaJPU3ETuo4e4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 095/184] drm/xe/hwmon: Remove unwanted write permission for currN_label
Date: Thu,  5 Sep 2024 11:40:08 +0200
Message-ID: <20240905093735.951849321@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit 515f08972355e160f896f612347121fbb685e740 ]

Change umode of currN_label from 0644 to 0444 as write permission
not needed for label.

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240419125945.4085629-1-karthik.poosa@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index bb815dbde63a..daf0d15354fe 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -551,12 +551,17 @@ xe_hwmon_curr_is_visible(const struct xe_hwmon *hwmon, u32 attr, int channel)
 {
 	u32 uval;
 
+	/* hwmon sysfs attribute of current available only for package */
+	if (channel != CHANNEL_PKG)
+		return 0;
+
 	switch (attr) {
 	case hwmon_curr_crit:
-	case hwmon_curr_label:
-		if (channel == CHANNEL_PKG)
 			return (xe_hwmon_pcode_read_i1(hwmon->gt, &uval) ||
 				(uval & POWER_SETUP_I1_WATTS)) ? 0 : 0644;
+	case hwmon_curr_label:
+			return (xe_hwmon_pcode_read_i1(hwmon->gt, &uval) ||
+				(uval & POWER_SETUP_I1_WATTS)) ? 0 : 0444;
 		break;
 	default:
 		return 0;
-- 
2.43.0



