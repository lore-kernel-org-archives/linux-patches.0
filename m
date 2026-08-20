Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F055360745;
	Thu, 20 Aug 2026 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238757; cv=none; b=al8gr+MEEpE17YPLaSPPMUNU3q7mFHTA9uXXPuIOcOSD1AY9Wb7zB9Zml3gxExn17lpqqGc2Oo8zmIkvBcRqiG3/QETW+LIizqoN3UJppLA5GiXuDrM9JYUP3tBwVq73TjUyUVxbWmZZn4ucCArvBSPj0PoLS7w7qR+XfZet5AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238757; c=relaxed/simple;
	bh=9UQ45mGdoGCI5VNmzqjphzqGhS5kBrzlHAvv1MhpFhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLZbAZ30jMImtF2Fc7lSKXroA51+pxtnMMYlz+KucA+Ak6so9BmLHnYZ75h8GFfcGIEX7j9BknGyHLiwcM118O5RAbKvGbGwZTJmR70ncsItI6pwDzqXKvzlhNbchoASeBV/K0aqGFWWHo3fCyhnZIPpZxq+t5EXPduMI9WXkjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTLC/rAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTLC/rAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047561F000E9;
	Thu, 20 Aug 2026 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238756;
	bh=eK3dFgHomykb4QTAb2D2RxRFfPTdcw2FZ+8pcYGFjLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTLC/rADF1NRog4T5FiKvjS/x4x8K+Mei4Ki+9OWdf14JCM1IjUioFhooIyVEiPgi
	 CgH0Pt475PWEsUZDYS8NlKtsKa+vjUaGePqXe6TkqJGWErmX0/KNz94+t42gcDswId
	 ow/4jZ7PIBe45lIY/T9UccxEseBUVrQYKaq687ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Ming Lin <chengminglin@mxic.com.tw>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/217] mtd: ubi: skip programming unused bits in ubi headers
Date: Thu, 20 Aug 2026 16:52:51 +0200
Message-ID: <20260820145237.658087483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Cheng Ming Lin <chengminglin@mxic.com.tw>

[ Upstream commit 77530d1a78ca5c274e37d6494a965223672630b2 ]

This patch prevents unnecessary programming of bits in ec_hdr and
vid_hdr that are not used or read during normal UBI operation. These
unused bits are typcially already set to 1 in erased flash and do not
need to be explicitly programmed to 0 if they are not used.

Programming such unused areas offers no functional benefit and may
result in unnecessary flash wear, reducing the overall lifetime of the
device. By skipping these writes, we preserve the flash state as much as
possible and minimize wear caused by redundant operations.

This change ensures that only necessary fields are written when preparing
UBI headers, improving flash efficiency without affecting functionality.

Additionally, the Kioxia TC58NVG1S3HTA00 datasheet (page 63) also notes
that continuous program/erase cycling with a high percentage of '0' bits
in the data pattern can accelerate block endurance degradation.
This further supports avoiding large 0x00 patterns.

Link: https://europe.kioxia.com/content/dam/kioxia/newidr/productinfo/datasheet/201910/DST_TC58NVG1S3HTA00-TDE_EN_31442.pdf

Signed-off-by: Cheng Ming Lin <chengminglin@mxic.com.tw>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index a4999bce435f..915eb64cb001 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -868,6 +868,8 @@ int ubi_io_write_ec_hdr(struct ubi_device *ubi, int pnum,
 		return -EROFS;
 	}
 
+	memset((char *)ec_hdr + UBI_EC_HDR_SIZE, 0xFF, ubi->ec_hdr_alsize - UBI_EC_HDR_SIZE);
+
 	err = ubi_io_write(ubi, ec_hdr, pnum, 0, ubi->ec_hdr_alsize);
 	return err;
 }
@@ -1150,6 +1152,14 @@ int ubi_io_write_vid_hdr(struct ubi_device *ubi, int pnum,
 		return -EROFS;
 	}
 
+	if (ubi->vid_hdr_shift) {
+		memset((char *)p, 0xFF, ubi->vid_hdr_shift);
+		memset((char *)p + ubi->vid_hdr_shift + UBI_VID_HDR_SIZE, 0xFF,
+		       ubi->vid_hdr_alsize - (ubi->vid_hdr_shift + UBI_VID_HDR_SIZE));
+	} else {
+		memset((char *)p + UBI_VID_HDR_SIZE, 0xFF, ubi->vid_hdr_alsize - UBI_VID_HDR_SIZE);
+	}
+
 	err = ubi_io_write(ubi, p, pnum, ubi->vid_hdr_aloffset,
 			   ubi->vid_hdr_alsize);
 	return err;
-- 
2.53.0



