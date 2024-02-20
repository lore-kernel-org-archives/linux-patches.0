Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3700F151CD9;
	Tue, 20 Feb 2024 20:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462726; cv=none; b=Acbz7nXCtY0AOLkJui5sBMYBPp8IiLWH/CDZKr7aPu0Q0nsqoiNiToKapx5WXX1kCy4/SNeas4nmht1xBPWPe61km3BfTbWRJer14Zx5AmNmt5SNeYQH0Xqgu5lcEgYdUZTYl/Ddz1ZiNZ+66rtpmzNiGTS7MenxoBKk0mXe7S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462726; c=relaxed/simple;
	bh=lPuwFjXzsFAx38ESGRmYHWvRWrYuh8+aM3eQzaqQT+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOSKIQq/ogn4dOIbFskvn1bsMVyCSJ2UdqOvQKODJsYJJ5dotFb7DfAhunt/qSA7MvKeCZCuwh2oLhzgIJJrCPgjsF09VM74D55m6sbmwjMZFIj9jqM3jB+OE1jQqwqJMYViaKyGFmxbvWtYATcxK9h0uJygc63hpEmof6nKN+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JV8R76na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JV8R76na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996EAC433C7;
	Tue, 20 Feb 2024 20:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462726;
	bh=lPuwFjXzsFAx38ESGRmYHWvRWrYuh8+aM3eQzaqQT+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JV8R76naXqHIpegtdIT8w1+BlCiS8JTiPt273nr9gOnhe7Wsp0zbL98vmmLL5Cz+C
	 AXsltvGEDOU/CCwQH9yNH3+chkjB4v77QWeO0CNGhUs3nn2DhdZhEQijCXy8jskdyW
	 1iU69E60Va3XgnKRr6RQ+6qTShsgvq9eDn629+NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/197] of: property: Improve finding the supplier of a remote-endpoint property
Date: Tue, 20 Feb 2024 21:49:37 +0100
Message-ID: <20240220204841.627618099@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b636777e6f7c..e1946cc17030 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1261,7 +1261,6 @@ DEFINE_SIMPLE_PROP(pinctrl5, "pinctrl-5", NULL)
 DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
 DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
 DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
-DEFINE_SIMPLE_PROP(remote_endpoint, "remote-endpoint", NULL)
 DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-cells")
 DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
 DEFINE_SIMPLE_PROP(leds, "leds", NULL)
@@ -1326,6 +1325,17 @@ static struct device_node *parse_interrupts(struct device_node *np,
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



