Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C15E44AB9D;
	Tue, 21 Jul 2026 21:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670127; cv=none; b=eljy9MVhbFYAycqM3FxA7oyK+JtQ7hv3VZd5styzz8PeJzOC31XrZyaTOJeMSb1zD1qtqMsrzy9L/W3pmAzpclll9Qj0uU9zT1MZmjgYmVDso8QsiU8zzuiae+9ZSAkSWMklJDDGLehwmMywPia8BDjBpdr9M5BNHov7bTOpn9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670127; c=relaxed/simple;
	bh=H1hQ6q7bb0zMzxwiqq7+mzw7YLllq6FoneRUhstn3uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOy48BQafb1dgLtU9jt9WDk5ZCkEW6mayNA6cpJX1DeQz9UjhH9l4r+rtdh+W/c46MXybZ9G2OI35SuP88g9trSlekBCt4DW0WjKUl2tjJatpUYFbmHZmWdcdzjAdtopeBBHaEhKkrrUhIC81J+foY5tsxsd7eh+yk38io3trqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wh2W0ai3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wh2W0ai3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C190D1F000E9;
	Tue, 21 Jul 2026 21:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670126;
	bh=ypiNPc+6hgNv9T21uRNBc+PD/rQ9gIGsRX3XVFnghT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wh2W0ai3TRQ7bWc5BhNQTAaiT5/RentgkS/JG88WRteGNlalWPeU4RJOiAskqWc4b
	 EXuWFjfPkeZ8+LG2JTqe/tcsdKAnmlFyi31AwOBTr3f9cQ4EEwqI5/T0kmmdEOJgoH
	 aHJZvdcT8VPDL+ws8S8yVoDbyFILG2Y9CoAEQi5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.1 0815/1067] mtd: spi-nor: swp: Improve locking user experience
Date: Tue, 21 Jul 2026 17:23:36 +0200
Message-ID: <20260721152442.784607610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit e1d456b26bf23e30db305a6184e8abd9ab68bbf2 upstream.

In the case of the first block being locked (or the few first blocks),
if the user want to fully unlock the device it has two possibilities:
- either it asks to unlock the entire device, and this works;
- or it asks to unlock just the block(s) that are currently locked,
  which fails.

It fails because the conditions "can_be_top" and "can_be_bottom" are
true. Indeed, in this case, we unlock everything, so the TB bit does not
matter. However in the current implementation, use_top would be true (as
this is the favourite option) and lock_len, which in practice should be
reduced down to 0, is set to "nor->params->size - (ofs + len)" which is
a positive number. This is wrong.

An easy way is to simply add an extra condition. In the unlock() path,
if we can achieve the same result from both sides, it means we unlock
everything and lock_len must simply be 0. A comment is added to clarify
that logic.

Fixes: 3dd8012a8eeb ("mtd: spi-nor: add TB (Top/Bottom) protect support")
Cc: stable@kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/swp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -272,8 +272,15 @@ static int spi_nor_sr_unlock(struct spi_
 	/* Prefer top, if both are valid */
 	use_top = can_be_top;
 
-	/* lock_len: length of region that should remain locked */
-	if (use_top)
+	/*
+	 * lock_len: length of region that should remain locked.
+	 *
+	 * When can_be_top and can_be_bottom booleans are true, both adjacent
+	 * regions are unlocked, thus the entire flash can be unlocked.
+	 */
+	if (can_be_top && can_be_bottom)
+		lock_len = 0;
+	else if (use_top)
 		lock_len = nor->params->size - (ofs + len);
 	else
 		lock_len = ofs;


