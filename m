Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B2D1A83ED;
	Tue, 26 Aug 2025 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213983; cv=none; b=nWQxjE1gmwjl9r4AuhKtoC6FIuy+3BSTIE5cIOzY3raazrATah4zwHW5B+iEv34Z/QUme61hksjoQCXHay8tm9Bcxda4rXjDVF/aHoH7GVA3zZPR79MTUGLARsOlrx1nTWNgu26/vfzaIYiun0GMhWZ9dUX94MAPVkilFom3yRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213983; c=relaxed/simple;
	bh=xHkB9U9ODLeUUdws5FwQLvfSeotzW5Y5CLjVg7derjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akp66akoCpjnXuGaAjuTSgzSCvRMjnn3HJd8OYz+aZyZCaxJ6g/RidDRj2JSvp7KRGcEAft2yNnFM5kF7kL97L3XQDBKawVZ9K8LJTvvYyJI9X3HGirO4sLWOOiAbN3lDokmGxqvX1T5LB0z8Zsm26NOFPzhpAsJWuwTaLuaVnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0VrbjZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0VrbjZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04009C4CEF1;
	Tue, 26 Aug 2025 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213983;
	bh=xHkB9U9ODLeUUdws5FwQLvfSeotzW5Y5CLjVg7derjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0VrbjZtQjVv9q9DwzKkGnyjBVVvnzi5KJlW+Xw6X75xQtgYvckkNY1hwmKLOnJUB
	 gsUUnpKskecie6zNRW8WK+nA2rH5YVntGLcmyRfQi494WpoMLi7HVMKu+KlZB5SfS+
	 lmrnAtrKWZxt7ZcYGVbfiKBxiWVan6BgSmgGK8Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 546/587] usb: typec: maxim_contaminant: disable low power mode when reading comparator values
Date: Tue, 26 Aug 2025 13:11:35 +0200
Message-ID: <20250826111006.907857877@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

[ Upstream commit cabb6c5f4d9e7f49bdf8c0a13c74bd93ee35f45a ]

Low power mode is enabled when reading CC resistance as part of
`max_contaminant_read_resistance_kohm()` and left in that state.
However, it's supposed to work with 1uA current source. To read CC
comparator values current source is changed to 80uA. This causes a storm
of CC interrupts as it (falsely) detects a potential contaminant. To
prevent this, disable low power mode current sourcing before reading
comparator values.

Fixes: 02b332a06397 ("usb: typec: maxim_contaminant: Implement check_contaminant callback")
Cc: stable <stable@kernel.org>
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Rule: add
Link: https://lore.kernel.org/stable/20250814-fix-upstream-contaminant-v1-1-801ce8089031%40google.com
Link: https://lore.kernel.org/r/20250815-fix-upstream-contaminant-v2-1-6c8d6c3adafb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adapted macro names from CCLPMODESEL to CCLPMODESEL_MASK ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/maxim_contaminant.c |    6 ++++++
 drivers/usb/typec/tcpm/tcpci_maxim.h       |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/usb/typec/tcpm/maxim_contaminant.c
+++ b/drivers/usb/typec/tcpm/maxim_contaminant.c
@@ -5,6 +5,7 @@
  * USB-C module to reduce wakeups due to contaminants.
  */
 
+#include <linux/bitfield.h>
 #include <linux/device.h>
 #include <linux/irqreturn.h>
 #include <linux/module.h>
@@ -189,6 +190,11 @@ static int max_contaminant_read_comparat
 	if (ret < 0)
 		return ret;
 
+	/* Disable low power mode */
+	ret = regmap_update_bits(regmap, TCPC_VENDOR_CC_CTRL2, CCLPMODESEL_MASK,
+				 FIELD_PREP(CCLPMODESEL_MASK,
+					    LOW_POWER_MODE_DISABLE));
+
 	/* Sleep to allow comparators settle */
 	usleep_range(5000, 6000);
 	ret = regmap_update_bits(regmap, TCPC_TCPC_CTRL, TCPC_TCPC_CTRL_ORIENTATION, PLUG_ORNT_CC1);
--- a/drivers/usb/typec/tcpm/tcpci_maxim.h
+++ b/drivers/usb/typec/tcpm/tcpci_maxim.h
@@ -21,6 +21,7 @@
 #define CCOVPDIS                                BIT(6)
 #define SBURPCTRL                               BIT(5)
 #define CCLPMODESEL_MASK                        GENMASK(4, 3)
+#define LOW_POWER_MODE_DISABLE                  0
 #define ULTRA_LOW_POWER_MODE                    BIT(3)
 #define CCRPCTRL_MASK                           GENMASK(2, 0)
 #define UA_1_SRC                                1


