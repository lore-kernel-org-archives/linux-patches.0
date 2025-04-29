Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A665221DA7;
	Tue, 29 Apr 2025 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946822; cv=none; b=FwImVuTYoRdn+TA8SOoFtgac1IaFZx0o6M0Dwgcq2hlaNW7dcv1bosBVwDRglF9AE3dAv3eaaGnBAjqnSBwPj1av754M0B1tfRMFUVjlK/Qoujo3mFQXl4FFinA5grP197z3BgwrE0Yub51GiDVkU1cCIusSf/vhu/PPSnkbKtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946822; c=relaxed/simple;
	bh=7xA7pfQR2nDC3bhVeC/yJAYl1LAfbmyOicsJZ10LiOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbKHmmBktd73qpCnO16TFYA2V78VfGjzHYSJ9GrMitejTv/Py91sn3KaEp1O+MqZe333OIG0703+akRB1g8RYt3dkksIT5GEesuHvksJlAmRRk4kf2ODKnEGvtXtDKBhi0/ewJoVrAFudMl2VVQvVbDTqN5WZgaNcbHUeR5Q0Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5jMcCVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5jMcCVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5A9C4CEE3;
	Tue, 29 Apr 2025 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946822;
	bh=7xA7pfQR2nDC3bhVeC/yJAYl1LAfbmyOicsJZ10LiOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5jMcCVZbKv2WtxR4Nh42C11jCqaKf5w7ROSDVeNEQWWXj+jpaQWZvtw3rX6TPIyE
	 haF6c7J2V97BXolamTfCK5Wx49selE+3KkQIgFxFIQLJXH25wEAtWpFV2uycyBcFKg
	 9S1RX/asWrjfscCsuEVqvTVMT4QZzMjornMAeaG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 081/286] mtd: rawnand: Add status chack in r852_ready()
Date: Tue, 29 Apr 2025 18:39:45 +0200
Message-ID: <20250429161111.183211980@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


