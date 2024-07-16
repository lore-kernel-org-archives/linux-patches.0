Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36587F9E8;
	Tue, 16 Jul 2024 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144074; cv=none; b=X6QYQvye/OtqwoLeg0zg32WIvRQcY4X+l7pTz1TDMvVcAJAzxIh0n+kDHj2e+51n8VCDwFR+sc3idm1GVcVDFtOwB3tA3iOAWwK5dzVPwlnW0WOyvyb80MMvV+wLfYoow2xADoUD8fTG40uSk9evXM9kCRri+hiqqKMagxm8ZW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144074; c=relaxed/simple;
	bh=VCy/aIiO6yabSE6W+L77burEioZCrIT6z8tC9zv8vsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XETSHUI28kpr0GNLpDNiZcFOKZwyeoxJDWA1ZcpO5OaNGLmt4Ozd5ii4z/+Y5d9JvmGP+DOys2fEEEbFXlPU7dGQ1tGYC/sPoV5xScV6eyAHD70LJM1wiEuSL49rzTKDnPLy7VFQ17bOA7q16yI66/I7gAAp4tpKXNhRCijaH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+VK+Pjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+VK+Pjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A802DC4AF0B;
	Tue, 16 Jul 2024 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144074;
	bh=VCy/aIiO6yabSE6W+L77burEioZCrIT6z8tC9zv8vsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+VK+Pjx4nWKv9O3k0iadDp118jDpNVTiyHY1cbe6pHw0arLWgmB8IRIFdX6TtwkB
	 G+Z+9s+btwLCZU9xNETOfXxRIUVs0y6D4OqLWDzKgmUivuZ7zxyWhjJlbsXx/Fm8oN
	 ZRWQ+GdD92t5pcXA2bcayXenX96kAgJM3kZtvxPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Michael Kelley <mhklinux@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/66] firmware: dmi: Stop decoding on broken entry
Date: Tue, 16 Jul 2024 17:30:42 +0200
Message-ID: <20240716152738.448722314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 0ef11f604503b1862a21597436283f158114d77e ]

If a DMI table entry is shorter than 4 bytes, it is invalid. Due to
how DMI table parsing works, it is impossible to safely recover from
such an error, so we have to stop decoding the table.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Link: https://lore.kernel.org/linux-kernel/Zh2K3-HLXOesT_vZ@liuwe-devbox-debian-v2/T/
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi_scan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 0dc0c78f1fdb2..311c396bdda7d 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -95,6 +95,17 @@ static void dmi_decode_table(u8 *buf,
 	       (data - buf + sizeof(struct dmi_header)) <= dmi_len) {
 		const struct dmi_header *dm = (const struct dmi_header *)data;
 
+		/*
+		 * If a short entry is found (less than 4 bytes), not only it
+		 * is invalid, but we cannot reliably locate the next entry.
+		 */
+		if (dm->length < sizeof(struct dmi_header)) {
+			pr_warn(FW_BUG
+				"Corrupted DMI table, offset %zd (only %d entries processed)\n",
+				data - buf, i);
+			break;
+		}
+
 		/*
 		 *  We want to know the total length (formatted area and
 		 *  strings) before decoding to make sure we won't run off the
-- 
2.43.0



