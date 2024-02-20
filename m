Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280C3612D7;
	Tue, 20 Feb 2024 21:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463478; cv=none; b=YncQLXar13ft9xNR1ENj1kY1l4Ud06Mjklar6goTsZGID9ivYf27YaHE6mPFsTsjQ7XT+IDIWY39RYQfZ+qL3Ao2OM7WkCQq+zBUhmQ4zouA+f8wizCSgiGMWIhgNgxWqpPox6sv6eh/I37d55ne73y4QNbxE6XvZFu8yK8Du5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463478; c=relaxed/simple;
	bh=jwHdQHk774/S2KrJUza3r/lHKk9RiVNPJ9wzUunrFec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRufh5yU5BmgPn/BINyhar4o2b4XfebXyzXW+PbC3dUACyPwAdVx5iO7QXg9CB8stkCGBxk26iCZUpn/lpQvG5p2Xqzh2+eCRj40i/JHvWRFhzZxB5PdivdY1xbx3DApZfFJdzL6xyMQ3GwB4fFFpTG3kvajZVD61CxHeWftbac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUQ5AoB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUQ5AoB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1515C433F1;
	Tue, 20 Feb 2024 21:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463478;
	bh=jwHdQHk774/S2KrJUza3r/lHKk9RiVNPJ9wzUunrFec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUQ5AoB4t7+c0axainfsI6LwywrhO8wreuTtvgaHuMJ3xhHfmStUYej5Yg1LrNDr2
	 +kzkA/6S+8MxsX9hJH7zZrgKl+4NEn2BN1KPe1jE1ZAMjvGIAwjYwDM0jIlNjVTM+x
	 V/ZF+SMziTqMzruZiU3zLtXuqpUFhdliUU8/4Www=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/331] of: property: Improve finding the supplier of a remote-endpoint property
Date: Tue, 20 Feb 2024 21:52:23 +0100
Message-ID: <20240220205638.438517075@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4411a08fccb3..d9b3c8769fa7 100644
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
@@ -1296,6 +1295,17 @@ static struct device_node *parse_interrupts(struct device_node *np,
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



