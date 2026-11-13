Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590282;
	b=ic4AsEefuF9XsrtzuyrbH7S75GUrTCLqGT6fNkQA/1WHof8IZ9tJQCsAyYqA06a/Zbbz
	 jwszojth9LTvFNo53sv4AALmzOPIbdswTVdK8fcqjuFEfLFwLDaFgFFbzjeamf2GAvyFz
	 C4dTCkXwF32T6ajdQFcvQ3VOBtEZ+pTKjo8i3H8wYfBEHRDdQE166RdggbERN4qNNBo07
	 LJi2Qv0y+uF/H6luIG1glQeBffloS2wFxxU1tNR2ic3hTJB1NGO/juV95CKh8rbntgs+y
	 nvD9AN9/DRbbAnIvQ6ia00LMBPNUZkxjRmBC3shlULpSxGFYmBMOXuU7iswowkHtaww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z9qFayyreLWsNar6k0rEVs1RPUkwgO+CVcOIyo0idg4=;
	b=s/MxmpXNcnOENIHLPFGV2/YXDff9A5WSg6BkAkEHY6gFfM6F81sJ9PZDcz0a0AtlF7TT
	 pJREhld1rNEGdWgK05+6w1pyXgbz+HEKnFklpiJ/OdH9wDxcMLQPkyUxJt33aB0cV3Udp
	 /ulHVqIiJ+xR5KGnThZM3WylCFqOhYJS+NEzQC0JO/w3oWSwBG4HfdYTyzgumzBkQBbZd
	 ZvWEX/s/e+x5bkCQVvmdlUUi67jln74ony/QDrsgbXeEyiGArUp+NTzqngDaxqOw7+E5t
	 lTZCrfxJ542dysg13mE0c0OmwkQzmf9GUPWpTUhaDkjRVGKgXoclnkWo69aMldUqDGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEkAsbPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC3A606CEE7;
	Fri, 13 Nov 2026 17:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEkAsbPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4211F000C4;
	Fri, 13 Nov 2026 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590282;
	bh=z9qFayyreLWsNar6k0rEVs1RPUkwgO+CVcOIyo0idg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEkAsbPcSW3EltwHNTvfelu02+bBMUnENl5YHCtf7eWNlWaVssFrZagflUIr35yiX
	 Pcxtmd0R16+E8N3L3xvMpjcmEYe9iMt+HE/aFOW69ylVJ1u+Q8DG7b3o8pODWzEsK8
	 j3R0kVEgCkx0drHJYP7Nwb8MiJiRDaUzfP63tZKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/686] hwmon: (corsair-cpro) Cache fan target only after a successful command
Date: Fri, 13 Nov 2026 10:46:43 -0500
Message-ID: <20261113153830.162914643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit e2c26431b4e47892378582a414b4bbaa9edf1798 ]

set_target() updates the cached fan target before sending the command.
If the command fails, subsequent fanN_target reads report the failed
request instead of the previous value. For example, after successfully
setting 1200 RPM, a rejected request for 1800 RPM returns an error but
leaves fanN_target reporting 1800. A failed request also replaces
-ENODATA when no target has been successfully set.

Update the target cache under the existing mutex only after
send_usb_cmd() succeeds, as set_pwm() already does when invalidating
the target. Preserve the previous cached value and return the original
error on failure.

Fixes: 40c3a4454225 ("hwmon: add Corsair Commander Pro driver")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261020160941.36787-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 17bb080eb9bb6..1c152a6db3806 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -215,10 +215,11 @@ static int set_target(struct ccp_device *ccp, int channel, long val)
 	int ret;
 
 	val = clamp_val(val, 0, 0xFFFF);
-	ccp->target[channel] = val;
 
 	mutex_lock(&ccp->mutex);
 	ret = send_usb_cmd(ccp, CTL_SET_FAN_TARGET, channel, val >> 8, val);
+	if (!ret)
+		ccp->target[channel] = val;
 
 	mutex_unlock(&ccp->mutex);
 	return ret;
-- 
2.53.0



