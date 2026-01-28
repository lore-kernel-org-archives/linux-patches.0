Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E549E246BC5;
	Wed, 28 Jan 2026 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614209; cv=none; b=dZqwNGisByJThZssuDIBo/TMk3h7hNeBIx2G9nFPVZEJ0VzncfYW2nM5tmKAD05el8luFzPNU0j2cb6FP540UbsYfRpT7WXgct4xg7GMnfxwkwWv32OwBIxlDnIYw5+agPy2Cybwg4F79RdTOPsA4InIywYIPB6rWAiCUwRkDCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614209; c=relaxed/simple;
	bh=xwHr60LyidAZcF3x44JW+sQGR5HjXeHKf6xK7iwj98M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGLjTWHtN+mR+Ygli6aAtwdxHuVkjIW5i2v91aqK9SgRv2uUdIGuwWjUoOUMpWFiwHfTdMhZvmv70aSK/FGbTUk7uhcFtHOq4mh47EKcTTCc9xVVpjeT5URbG/YAXKD+E9smypOoIRxwDsTOdHLVxLhPBcMxXjYNCtef71yQd84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfCvQZgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfCvQZgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB99C116C6;
	Wed, 28 Jan 2026 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614208;
	bh=xwHr60LyidAZcF3x44JW+sQGR5HjXeHKf6xK7iwj98M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfCvQZgG37dEb2VrIeWz6HsOA6SeZ0e3RJz+BTbDauZWGDdwMWC+qjfMF10zY3a2w
	 cfSdT+ykYA32lu/UzSca5Y4cDfcOuvrTUymQ4eUD58GPmVmeIMfQvjYHU1cLH/MBF7
	 HY8Db7VbfFdZMindSVT5Y7R9F57S0LQb1uZ09auI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Arnaud Ferraris <arnaud.ferraris@collabora.com>
Subject: [PATCH 6.6 066/254] tcpm: allow looking for role_sw device in the main node
Date: Wed, 28 Jan 2026 16:20:42 +0100
Message-ID: <20260128145347.073307669@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Ferraris <arnaud.ferraris@collabora.com>

commit 1366cd228b0c67b60a2c0c26ef37fe9f7cfedb7f upstream.

If ports are defined in the tcpc main node, fwnode_usb_role_switch_get()
returns an error, meaning usb_role_switch_get() (which would succeed)
never gets a chance to run as port->role_sw isn't NULL, causing a
regression on devices where this is the case.

Fix this by turning the NULL check into IS_ERR_OR_NULL(), so
usb_role_switch_get() can actually run and the device get properly probed.

Fixes: 2d8713f807a4 ("tcpm: switch check for role_sw device with fw_node")
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
Link: https://patch.msgid.link/20260105-fix-ppp-power-v2-1-6924f5a41224@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6637,7 +6637,7 @@ struct tcpm_port *tcpm_register_port(str
 	port->port_type = port->typec_caps.type;
 
 	port->role_sw = fwnode_usb_role_switch_get(tcpc->fwnode);
-	if (!port->role_sw)
+	if (IS_ERR_OR_NULL(port->role_sw))
 		port->role_sw = usb_role_switch_get(port->dev);
 	if (IS_ERR(port->role_sw)) {
 		err = PTR_ERR(port->role_sw);


