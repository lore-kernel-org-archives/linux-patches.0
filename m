Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D1034889F;
	Tue, 16 Jun 2026 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624216; cv=none; b=IyHVdJr9YfaPlHdt0l1FEv2nhUGEWZGFfwGJUbK2wYWueBC565nhl+PV0QESFjUZDHdhWe8LbsfFJ7IR68PT21KMNHTnMovpo/IkihMgLSdofnyQ6a2jxd7CpXMeR4lrDPdTqVlivF7VV4CQyZ+Vlc7KgLVkumLeu0Amj3wZ4+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624216; c=relaxed/simple;
	bh=qDCslrJGTNisHFTqnlddg3fnePWkTCCgcExjmmldqGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9+sExf0HnGvi4bb8lC0IChKEcMKD5VmuQOlWtt1DQamOY+K2BubTuVh2MAnvt4RDXU2qYdAOPgpwZV6TkgRxmenWGjcoO+7Kou/ZeOrdMhGJ98reVtiNbPX1kwIVvS+Mp/Pw6SQqYuI7Ljm8DpctapzHzVpm3txTnJCzUN0/0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=si5zjOaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="si5zjOaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685111F00A3F;
	Tue, 16 Jun 2026 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624215;
	bh=ONMFNck8dsl0frLDkVjB/HsuFzsMdLjHzXvdFnQugpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=si5zjOafPKeCY7syuohshtqLClwomS3P1r4jZpbp+WBi0Vw+uXc/jnvQn8ngylxmq
	 fy7zPDW2DhdN0MOa5GIJrmf5T4Goobyxl5eueGKxEdEjmieAx1zAMT6CP28lFx21PE
	 DyCMywPX+kfW/IqQwEb8TvVN5HxDPV+ddpmeF/m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 293/378] net: sfp: initialize i2c_block_size at adapter configure time
Date: Tue, 16 Jun 2026 20:28:44 +0530
Message-ID: <20260616145125.490752370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Jelonek <jelonek.jonas@gmail.com>

commit 56d0885514491e5ed8f7593400879ab77c52504c upstream.

sfp->i2c_block_size is only assigned in sfp_sm_mod_probe(), which runs
from the state machine timer after SFP_F_PRESENT has been set. Between
those two points, sfp_module_eeprom() (the ethtool -m callback) gates
only on SFP_F_PRESENT and can be entered with i2c_block_size still at
its kzalloc'd value of 0.

On a pure-I2C adapter, sfp_i2c_read() then issues an i2c_transfer()
with msgs[1].len = 0 inside a loop that subtracts this_len from len
each iteration; on adapters that succeed a zero-length read the loop
never advances, spinning while holding rtnl_lock.

This was previously addressed by initializing i2c_block_size in
sfp_alloc() (commit 813c2dd78618), but the initialization was dropped
when i2c_block_size was split from i2c_max_block_size.

Initialize sfp->i2c_block_size from sfp->i2c_max_block_size in
sfp_i2c_configure(), so the field is valid as soon as the adapter is
known. sfp_sm_mod_probe() still reassigns it on each module insertion
to recover from a per-module clamp to 1 (sfp_id_needs_byte_io).

Fixes: 7662abf4db94 ("net: phy: sfp: Add support for SMBus module access")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Link: https://patch.msgid.link/20260528205242.971410-2-jelonek.jonas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -820,6 +820,7 @@ static int sfp_i2c_configure(struct sfp
 		return -EINVAL;
 	}
 
+	sfp->i2c_block_size = sfp->i2c_max_block_size;
 	return 0;
 }
 


