Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D98A126BF7;
	Tue, 29 Apr 2025 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945291; cv=none; b=Q2mSwcfGahc30QwxeY0iAinxz0SgbskRDj5BLJdjEguDwZDmLal3mLnbtrMJaKYiNc04d/Ent4gQqJRQHJH+NedZm+gLEd/c4mRR5ojo4G5yE+5ePzRau/wtTO42hNDqqy3Wz9fhTWqDK6ZAqhBoITZeMdXbUJdNH+pDCxT68+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945291; c=relaxed/simple;
	bh=aE0co5hDSQQIIlTulipBcnFkCb6slXeASCRbsWbg4ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toa7RLokbKYy/BEdI+9smwMaKnANPfIpEsdmSgiomnAHr7NlhpDJerGLHLWPhvmvTQ/DWR2ycegGi2cpdMAFnKWEOE/AcvXxDwwNZfgklc3lufO3ytjagZaQkQtvS10Kczm+dloweqiHGX+qDZqrZ683OuhAK6GyvWsZvdVZOS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jz2ZO8im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jz2ZO8im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA84DC4CEE3;
	Tue, 29 Apr 2025 16:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945291;
	bh=aE0co5hDSQQIIlTulipBcnFkCb6slXeASCRbsWbg4ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz2ZO8imVbJeyjrOWCJVdQldDUR0aw2PVCtDmKrIN+5nLb8I1Io3eYpZZt1hRRXhN
	 NuSapaL390khu++zn3vb2Cg06ytgrY1xjQ/Qk5c/lcbl09Tc5PvG2HNdHS/T3IWVM6
	 X3+CAP96jU56EIPaj40vpU+hNsRHtZ3IpleLuVZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 064/179] mtd: rawnand: Add status chack in r852_ready()
Date: Tue, 29 Apr 2025 18:40:05 +0200
Message-ID: <20250429161051.997324601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit b79fe1829975556854665258cf4d2476784a89db upstream.

In r852_ready(), the dev get from r852_get_dev() need to be checked.
An unstable device should not be ready. A proper implementation can
be found in r852_read_byte(). Add a status check and return 0 when it is
unstable.

Fixes: 50a487e7719c ("mtd: rawnand: Pass a nand_chip object to chip->dev_ready()")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/r852.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/r852.c
+++ b/drivers/mtd/nand/raw/r852.c
@@ -387,6 +387,9 @@ static int r852_wait(struct nand_chip *c
 static int r852_ready(struct nand_chip *chip)
 {
 	struct r852_device *dev = r852_get_dev(nand_to_mtd(chip));
+	if (dev->card_unstable)
+		return 0;
+
 	return !(r852_read_reg(dev, R852_CARD_STA) & R852_CARD_STA_BUSY);
 }
 


