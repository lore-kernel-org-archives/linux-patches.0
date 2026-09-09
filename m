Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614E468C2C;
	Wed,  9 Sep 2026 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961743; cv=none; b=szj3DUHhSbNu/YaDCvDov9tbfD5Pim8OyVo9U8uh35bQV+wk1IhSnfLbSRNz0cloraHzQsfAquYNk2H90ZBVFoZrCeeST0PPNPv/hXn1WKCkV/2P9WEQ6lI6cvmJNFovucBr6e9P6egdICHdWQZeLatjJE1onbNqb7m4JPGjBJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961743; c=relaxed/simple;
	bh=yfsmms+bWa1G8C70vrUQOAGi8EBvVmQsuBbt+TcNlBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXgjfNKdmUYVxrmWBsXxVGSAEuymDFX3ZJ705ntyr6+y3H0CduHBAB3XcRNEl6lnNmS0V+0Mhw+9HZW2yiivkzJWPOVwCr0P51IZvaWaDWOD4CKU7/w/SdHbSDz6i8SQv77CmAekWFY9Fxn8ERTZiimXEgkhdUoychEdAY34Tdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAo6eoPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAo6eoPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7431F00A3A;
	Wed,  9 Sep 2026 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961742;
	bh=YXO2zFbudacd+M2EuszzlYfVvuEwrMYya5d306YEp1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAo6eoPG1r+ZU/4OBuYEBo67gYdKvoOhIXH6iTGIcvkb2sAl60KYKVPkgz/34QUmo
	 OmdStMf/0Rq5yLlZ854EVyB3ScKWqLRlWosbRXlkst4is9uVrghnAWRMhH0bZPSXHw
	 E3IsUx5Szm/Mu3xYMlJxSNSWSZDtB+yXWgeOkoEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Chang Wu <kunjinkao.jp@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Jan Remmet <j.remmet@phytec.de>,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Subject: [PATCH 7.2 035/556] usb: typec: hd3ss3220: track VBUS enable state per consumer
Date: Wed,  9 Sep 2026 15:35:15 +0200
Message-ID: <20260909134231.733908950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chang Wu <kunjinkao.jp@gmail.com>

commit c9a48db776d7184981630ecc01a3ad30a8f7dc24 upstream.

regulator_is_enabled() reports the aggregate regulator state, not
whether this consumer holds an enable reference. If another consumer
enables VBUS first, the driver can skip its own regulator_enable() call
and later attempt to drop a reference it never acquired, triggering an
unbalanced regulator disable warning.

Track successful enable and disable calls locally. Keep the state
unchanged when an operation fails so a later role or ID notification
retries the operation while this consumer keeps balanced references.

Fixes: b3f9d6e491fd ("usb: typec: hd3ss3220: Check if regulator needs to be switched")
Cc: stable <stable@kernel.org>
Link: https://github.com/qualcomm-linux/kernel/issues/472
Signed-off-by: Chang Wu <kunjinkao.jp@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Jan Remmet <j.remmet@phytec.de>
Reviewed-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Link: https://patch.msgid.link/20260819152027.90994-1-kunjinkao.jp@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/hd3ss3220.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/hd3ss3220.c b/drivers/usb/typec/hd3ss3220.c
index d0de5a2488f9..4eec90c82bae 100644
--- a/drivers/usb/typec/hd3ss3220.c
+++ b/drivers/usb/typec/hd3ss3220.c
@@ -62,6 +62,7 @@ struct hd3ss3220 {
 	int id_irq;
 
 	struct regulator *vbus;
+	bool vbus_enabled;
 };
 
 static int hd3ss3220_set_power_opmode(struct hd3ss3220 *hd3ss3220, int power_opmode)
@@ -208,7 +209,7 @@ static void hd3ss3220_regulator_control(struct hd3ss3220 *hd3ss3220, bool on)
 {
 	int ret;
 
-	if (regulator_is_enabled(hd3ss3220->vbus) == on)
+	if (hd3ss3220->vbus_enabled == on)
 		return;
 
 	if (on)
@@ -216,9 +217,13 @@ static void hd3ss3220_regulator_control(struct hd3ss3220 *hd3ss3220, bool on)
 	else
 		ret = regulator_disable(hd3ss3220->vbus);
 
-	if (ret)
+	if (ret) {
 		dev_err(hd3ss3220->dev,
 			"vbus regulator %s failed: %d\n", on ? "enable" : "disable", ret);
+		return;
+	}
+
+	hd3ss3220->vbus_enabled = on;
 }
 
 static void hd3ss3220_set_role(struct hd3ss3220 *hd3ss3220)
-- 
2.55.0



