Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0AF474273;
	Sat, 12 Sep 2026 11:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212629; cv=none; b=G2RHkWxiTkoK1x2UFiJO4CzGPA0z8zHUJ/Ia7YHD5ECwEl9g6sKMjtCaB+SIX/lwtV9oWwAW/k4bd4RKmeQEsHLuiFj/c9xAk17Kz9A9oV31Sf+fvGAKinrBaOYr4hcBt+BtBFuPh7aGCv9U/xGvzhcAsp/SUlt+JT/EF4YxlYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212629; c=relaxed/simple;
	bh=p2Mlmk21DNljJwVTNrQW/Q21wqcgfL0yQGqc9xB6IeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taX+QxJ7wubojJuNhfBXcDrmokee1N+KSNhZe9ZSgfySXhUW5qLsOxI0tO0R/bKcjILJUY2UQBpWd1JSMJIVlTlIHlq8Nsaj2mS6yPCpvpaJpprZ2UIc2C+YFJRSre4R4rLl93jQkMtwhEM2+rUj4Qh7dE5ECTrprQx/JJAUyWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riuaH4wL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riuaH4wL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773031F000FF;
	Sat, 12 Sep 2026 11:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212627;
	bh=e1CGXrLvfgNerUPPXoprAnZmxqJRxd/3L4gHWh/Svp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riuaH4wLpWtQ/++IMoGm8lt6RprtSGrsw4Q7yPAknAdAMKZZuQ4Xx/a1K0t9101bf
	 rj0qPsfBrBtH/+cH/toy2T8pYV6rSF79HOkPX7cRm/wp5oaQ9UwiQxc32dyObi8LiE
	 ffqskwSUUkZ0TWeh3+gu5ZIPVUMk5Tfta3e5V6TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1468/1518] usb: ucsi: huawei_gaokun: move typec_altmode off stack
Date: Sat, 12 Sep 2026 09:00:37 +0200
Message-ID: <20260912065656.763595726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c7eaea5c6eeb391d445583fa6419c957ca74a86b ]

The typec_altmode structure contains a 'struct device' object
that cannot be allocated on the stack because of its size, even
when ignoring the lifetime rules:

drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c:326:13: error: stack frame size (1456) exceeds limit (1280) in 'gaokun_ucsi_usb_notify_ind' [-Werror,-Wframe-larger-than]
  326 | static void gaokun_ucsi_usb_notify_ind(struct gaokun_ucsi *uec)

Since the altmode is always associated with a port here, move
it into the port object and avoid at least the stack allocation
issue.

Fixes: 1c2b66a7d725 ("usb: ucsi: huawei_gaokun: support mode switching")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Pengyu Luo <mitltlatltl@gmail.com>
Link: https://patch.msgid.link/20260618143341.1900221-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
index b40718f402370..4d53f37ae1193 100644
--- a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
+++ b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
@@ -84,6 +84,8 @@ struct gaokun_ucsi_port {
 	struct auxiliary_device *bridge;
 
 	struct typec_mux *typec_mux;
+	struct typec_mux_state state;
+	struct typec_altmode dp_alt;
 
 	int idx;
 	enum gaokun_ucsi_ccx ccx;
@@ -293,24 +295,22 @@ static int gaokun_ucsi_refresh(struct gaokun_ucsi *uec)
 static void gaokun_ucsi_handle_usb_mode(struct gaokun_ucsi_port *port)
 {
 	struct gaokun_ucsi *uec = port->ucsi;
-	struct typec_mux_state state = {};
-	struct typec_altmode dp_alt = {};
 	int idx = port->idx, ret;
 
 	/*
 	 * For every typec port on this platform, the only mode-switch is
 	 * controlled by its qmp combo phy which consumes svid and mode only.
 	 */
-	dp_alt.svid = port->svid;
-	state.mode = port->mode;
-	state.alt = &dp_alt;
+	port->dp_alt.svid = port->svid;
+	port->state.mode = port->mode;
+	port->state.alt = &port->dp_alt;
 
 	if (idx >= uec->num_ports) {
 		dev_warn(uec->dev, "altmode port out of range: %d\n", idx);
 		return;
 	}
 
-	ret = typec_mux_set(port->typec_mux, &state);
+	ret = typec_mux_set(port->typec_mux, &port->state);
 	if (ret)
 		dev_err(uec->dev, "failed to set mux %d\n", ret);
 
-- 
2.53.0



