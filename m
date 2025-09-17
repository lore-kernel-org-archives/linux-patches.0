Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5791E489;
	Wed, 17 Sep 2025 12:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112989; cv=none; b=gqZfJM0OWlAPK69lWSce47LwNPS/5TzqMDtEtpTzYGYQhxvuySi3RwBiEZ3IHo2O+7VBX84WW0OF3LduXLv/V9RrJdMOw7eZ71KfffqGQKlN/MahZiKDd4zRnvIbhi3os+blFz16/SYff8MhIW006NWKF70kiA4ewm+8aLnNzUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112989; c=relaxed/simple;
	bh=sTPMpxYKwKQc9/cp5I+GdhWTOw9QJ+cHLa9g2ADLc2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdqLIud9RobeBHzI326SHkwyCH0pGsk5rs67eojbSX16otgsjr9ynObAuGc19fz1ODP9xzQt9VFloymg4nvy3SHiXIuH81iYlq35r9nS53eyZ8HLSkol9EH8rsxJuGrB85q3S9ifXuqFFTp3eMv6oG0nZUNqQUfjhQGDKooXKmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FUp1twS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FUp1twS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94592C4CEF7;
	Wed, 17 Sep 2025 12:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112989;
	bh=sTPMpxYKwKQc9/cp5I+GdhWTOw9QJ+cHLa9g2ADLc2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FUp1twSV2IllreY6iAGe7sa+SElJqGKTm+1rV4o0E41036tagfcliO5T7cs6RtgK
	 j/Da8ke/NCgVJV/2M7GtoG8kHVYwheqIKbyGLxCYykszI1NQXFJht6oq+vC+6DdL9q
	 IJTY9aH9foGSqiGQr8BUrgP3SP0M+36COhyDmy3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 136/189] net: dsa: b53: fix ageing time for BCM53101
Date: Wed, 17 Sep 2025 14:34:06 +0200
Message-ID: <20250917123355.186158921@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 674b34c4c770551e916ae707829c7faea4782d3a ]

For some reason Broadcom decided that BCM53101 uses 0.5s increments for
the ageing time register, but kept the field width the same [1]. Due to
this, the actual ageing time was always half of what was configured.

Fix this by adapting the limits and value calculation for BCM53101.

So far it looks like this is the only chip with the increased tick
speed:

$ grep -l -r "Specifies the aging time in 0.5 seconds" cdk/PKG/chip | sort
cdk/PKG/chip/bcm53101/bcm53101_a0_defs.h

$ grep -l -r "Specifies the aging time in seconds" cdk/PKG/chip | sort
cdk/PKG/chip/bcm53010/bcm53010_a0_defs.h
cdk/PKG/chip/bcm53020/bcm53020_a0_defs.h
cdk/PKG/chip/bcm53084/bcm53084_a0_defs.h
cdk/PKG/chip/bcm53115/bcm53115_a0_defs.h
cdk/PKG/chip/bcm53118/bcm53118_a0_defs.h
cdk/PKG/chip/bcm53125/bcm53125_a0_defs.h
cdk/PKG/chip/bcm53128/bcm53128_a0_defs.h
cdk/PKG/chip/bcm53134/bcm53134_a0_defs.h
cdk/PKG/chip/bcm53242/bcm53242_a0_defs.h
cdk/PKG/chip/bcm53262/bcm53262_a0_defs.h
cdk/PKG/chip/bcm53280/bcm53280_a0_defs.h
cdk/PKG/chip/bcm53280/bcm53280_b0_defs.h
cdk/PKG/chip/bcm53600/bcm53600_a0_defs.h
cdk/PKG/chip/bcm89500/bcm89500_a0_defs.h

[1] https://github.com/Broadcom/OpenMDK/blob/a5d3fc9b12af3eeb68f2ca0ce7ec4056cd14d6c2/cdk/PKG/chip/bcm53101/bcm53101_a0_defs.h#L28966

Fixes: e39d14a760c0 ("net: dsa: b53: implement setting ageing time")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250905124507.59186-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d15d912690c40..073d20241a4c9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1229,9 +1229,15 @@ static int b53_setup(struct dsa_switch *ds)
 	 */
 	ds->untag_vlan_aware_bridge_pvid = true;
 
-	/* Ageing time is set in seconds */
-	ds->ageing_time_min = 1 * 1000;
-	ds->ageing_time_max = AGE_TIME_MAX * 1000;
+	if (dev->chip_id == BCM53101_DEVICE_ID) {
+		/* BCM53101 uses 0.5 second increments */
+		ds->ageing_time_min = 1 * 500;
+		ds->ageing_time_max = AGE_TIME_MAX * 500;
+	} else {
+		/* Everything else uses 1 second increments */
+		ds->ageing_time_min = 1 * 1000;
+		ds->ageing_time_max = AGE_TIME_MAX * 1000;
+	}
 
 	ret = b53_reset_switch(dev);
 	if (ret) {
@@ -2448,7 +2454,10 @@ int b53_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 	else
 		reg = B53_AGING_TIME_CONTROL;
 
-	atc = DIV_ROUND_CLOSEST(msecs, 1000);
+	if (dev->chip_id == BCM53101_DEVICE_ID)
+		atc = DIV_ROUND_CLOSEST(msecs, 500);
+	else
+		atc = DIV_ROUND_CLOSEST(msecs, 1000);
 
 	if (!is5325(dev) && !is5365(dev))
 		atc |= AGE_CHANGE;
-- 
2.51.0



