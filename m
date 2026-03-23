Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4E2823DD;
	Mon, 23 Mar 2026 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275559; cv=none; b=ToUONQS1feqdnLglS9nZMfwsx7b3nsopr1he+AUe7ySih2LprCA9iX1SjBa11FaowvvGzs+oIR6rn2QVVMI25RpJtaYLwn/of3eAGhHKgADFr0kkkZIAwzQGWzM31b/KEwWA+vYS8C86p1ncIHoclEYVko4A77Y5KJKvpnm5J4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275559; c=relaxed/simple;
	bh=FnmKVaDy0T4vTLis+nnhZV7/ASnTX9TAUNOBw7r4wXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO5I3KJ7CzXeAdQgbEdnRSS1IY/wcAyXCQslZ/1piuH8lc+pK8/QonEaFn52TIeIpwirXGOGk2ZAyXqooZ+2R3cdxSSXQ89OLdMef4R+zq1zLAsUYgN24oRaY4pvFZJQqxsoZRRPp2YD/tu44NP8fdecZRQVMPSOyjRKH3ZI/iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILYcZv63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILYcZv63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A05C4CEF7;
	Mon, 23 Mar 2026 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275559;
	bh=FnmKVaDy0T4vTLis+nnhZV7/ASnTX9TAUNOBw7r4wXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILYcZv63iaAJdgRsQCkGRAdJ8JHPw90JqK/Hy38ZUzGNTnwEv0lJFYKTM3s0LggGf
	 4hxG2F7Xd6l6lEepkDSQ00aNgAbx67x47EwyuezBr1/zJIRSVTjiSFXBj+C4qj9wtC
	 rXYNRH/AY7A9qpuZy73x5YEHI6RlvVz/IixpY59Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Arnaud Ferraris <arnaud.ferraris@collabora.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 141/460] Revert "tcpm: allow looking for role_sw device in the main node"
Date: Mon, 23 Mar 2026 14:42:17 +0100
Message-ID: <20260323134530.053472392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 6b275bfaa16be3fb1689fa6794e445ecd127a1b4 upstream.

This reverts commit 1366cd228b0c67b60a2c0c26ef37fe9f7cfedb7f.

The fwnode_usb_role_switch_get() returns NULL only if no connection is
found, returns ERR_PTR(-EPROBE_DEFER) if connection is found but deferred
probe is needed, or a valid pointer of usb_role_switch.

When switching from a NULL check to IS_ERR_OR_NULL(), usb_role_switch_get()
returns NULL and overwrites the ERR_PTR(-EPROBE_DEFER) returned by
fwnode_usb_role_switch_get(). This causes the deferred probe indication to
be lost, preventing the USB role switch from ever being retrieved.

Fixes: 1366cd228b0c ("tcpm: allow looking for role_sw device in the main node")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Tested-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260309074313.2809867-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -7697,7 +7697,7 @@ struct tcpm_port *tcpm_register_port(str
 	port->partner_desc.identity = &port->partner_ident;
 
 	port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
-	if (IS_ERR_OR_NULL(port->role_sw))
+	if (!port->role_sw)
 		port->role_sw = usb_role_switch_get(port->dev);
 	if (IS_ERR(port->role_sw)) {
 		err = PTR_ERR(port->role_sw);


