Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AB9152DFC;
	Tue, 20 Feb 2024 21:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464471; cv=none; b=hWV/4Phzg/Ls9EStY/ooc6snm70F1/DHBkRMcNKuMLLvfwf5wDSw/V8dUYx5EsQrP9k7DnaDgxOmcCsE62GxVro+5zthh+H/Xpxnvb4Bzj4KNsCimMGVcPoeZYduJnFaoP+LPe+ZDFmHcsZSaSrvj3f00mpiTpAm3+Y2pWMj0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464471; c=relaxed/simple;
	bh=0RLHtaeJVOiCcGdbVZ3LS9CYh88Q5Fpu4ufSnPs3Vu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEjBxCnsSjHQBuVE8UkWCHhM0IM1jbo67T8kFapjYaplVxGvOaITpWHeGRMmBvaQ9eb7f6ThA0LVo6S0gN+4bNqreGwJmP/aVwdxEjBhQYWNTMHMGVcYuzmbwxMKpl8ATl8E3yMnZoi9dsy6H9Jk5DVAxnwJLXK0x+PSTRknHK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPJRvFs9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPJRvFs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EDFC433F1;
	Tue, 20 Feb 2024 21:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464471;
	bh=0RLHtaeJVOiCcGdbVZ3LS9CYh88Q5Fpu4ufSnPs3Vu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPJRvFs9WzIIse0bNx6ERgVTxSAFESpZjVuptlgKw4cYZpC3JdOhSBfnjROS4/Egp
	 3CcoYaHJmaYMQTERuba4j6szSoktihQdpfQjVaiW7ljo5ZwQGgZ0BRay4QsUnh2FFa
	 abhX8O/NvFXx2KXgEEFpeXzZFkVHBx6Q7TR8Kdw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 036/309] of: property: Improve finding the supplier of a remote-endpoint property
Date: Tue, 20 Feb 2024 21:53:15 +0100
Message-ID: <20240220205634.315174018@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 782bfd03c3ae2c0e6e01b661b8e18f1de50357be ]

After commit 4a032827daa8 ("of: property: Simplify of_link_to_phandle()"),
remote-endpoint properties created a fwnode link from the consumer device
to the supplier endpoint. This is a tiny bit inefficient (not buggy) when
trying to create device links or detecting cycles. So, improve this the
same way we improved finding the consumer of a remote-endpoint property.

Fixes: 4a032827daa8 ("of: property: Simplify of_link_to_phandle()")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20240207011803.2637531-3-saravanak@google.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 41c3da8a54b6..aacedfdfedc6 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1231,7 +1231,6 @@ DEFINE_SIMPLE_PROP(pinctrl5, "pinctrl-5", NULL)
 DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
 DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
 DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
-DEFINE_SIMPLE_PROP(remote_endpoint, "remote-endpoint", NULL)
 DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-cells")
 DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
 DEFINE_SIMPLE_PROP(leds, "leds", NULL)
@@ -1297,6 +1296,17 @@ static struct device_node *parse_interrupts(struct device_node *np,
 	return of_irq_parse_one(np, index, &sup_args) ? NULL : sup_args.np;
 }
 
+static struct device_node *parse_remote_endpoint(struct device_node *np,
+						 const char *prop_name,
+						 int index)
+{
+	/* Return NULL for index > 0 to signify end of remote-endpoints. */
+	if (!index || strcmp(prop_name, "remote-endpoint"))
+		return NULL;
+
+	return of_graph_get_remote_port_parent(np);
+}
+
 static const struct supplier_bindings of_supplier_bindings[] = {
 	{ .parse_prop = parse_clocks, },
 	{ .parse_prop = parse_interconnects, },
-- 
2.43.0



