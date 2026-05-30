Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928111D63E4;
	Sat, 30 May 2026 18:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166942; cv=none; b=VUrynQLVaef1+FKMXutgooYeBYfFX9UbFzUGvfqb06/aFiiElOcduL8wb0man4EGohrqxMN9MbB9kHiXZsZF0mHILlqwOz5ajp2EM8SxwqV/LVVZ3zpjfkU0sbupmIOQKH9MSENr3SFT8bZNlcG/v5tT1h61UF+/56t6FBcitA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166942; c=relaxed/simple;
	bh=zD4XbFJn7XQV2YsoLWOJspI1G1iAnOBw1EUdY+zd5Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHNc7gtPBsjhkfuktDK9T4cc7iUrNrWZVm5VksLQCPO2RORFYt7YkzstxhD2mTi3z4uCztdcMHwckxe9ROMeRKViCsjFPN5vwH97OcdsbrqJJCrVJ5wze0Hb+BbCDME3cEo6fXV84w02G5QQhZhulCtWxgybRf7EjFmaHG1zE/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oW1rsLEo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oW1rsLEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFE81F00893;
	Sat, 30 May 2026 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166941;
	bh=vhGYLc1xlKB7P1Tohphm9cCdJquCm95dyD6/T2+fSzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oW1rsLEoHZ3KNV8JVxx1mlgZQDhoBUTxykI124DOAFZi1SrjLbweiHv0KNyagSMb0
	 CM/V7Zd60qu7YcoZtz6cQ3BbylM/J/wcrQWaiMg57YpvcytpvqAzSLf/MKu8N5yOnr
	 OfRd6uT/NJQCKObetppw6ELSXLcGNbgcBf/qF+bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.10 518/589] drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup
Date: Sat, 30 May 2026 18:06:39 +0200
Message-ID: <20260530160238.239874674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 950953f774b3f69da6f413e045ef075e1f3da2df upstream.

Make sure to drop the reference taken to the I2C adapter (and its
module) when setting up HDMI to allow the adapter to be deregistered.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Cc: stable@vger.kernel.org	# 3.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -576,6 +576,7 @@ static int oaktrail_hdmi_get_modes(struc
 	} else {
 		edid = (struct edid *)raw_edid;
 		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+		i2c_put_adapter(i2c_adap);
 	}
 
 	if (edid) {


