Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039948;
	b=ESF8I5/SpzkZ5F4ji7jwEAHIeuCcGIvp7Yy5joPIiAedUOMwh5A7UgZzh+tkXwY0n9Qv
	 gA8nexMwIEqDOi8gWiQhL2mu/MSgjZX8GADseUhkiVZP326R/+cgsdRyRKKMsl5FaEqiA
	 BwABkDA3N9dqtokrMbm2BRPgDETTZjgrUbDOwAFDk+g3IOUO2SR2cwpjECZbwrxhEYEFw
	 k1yQDqNumFZwuNcYXRyoepQ0HCp9FKQPQ7YbkhZtK6vmbV1oym3eElikpFHfuRusocYrY
	 Kv9RgOPtrU+Eg/9NlMa4eKK/z8DbhaRSyGhGtc8iXbKi8PJA0SyHjFgxJQBm92pUUJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/a2EM6fvLI58cWmjFHm9Yga+8l8GMWxbypUkWetv7zY=;
	b=0PgDWHYQCFZWwKZuTsM05fexH8Sn3lh+t6koSRflCVSkN7aFsCycx51v2iJj33bL3L01
	 Z69XR1rgRGFSUZJ87CC/xl6GwfxLeWC/BUfwr4C5sPqxIVupD42Yo0cvvHXIuQUOYW6A9
	 uIcok2glO2F9aQnS3BhmcPVBcWklTY0J/k36DtP5SN+3qvx7dK5JsBSpTOtNm/bqPDA9a
	 iEq1ycG5o7muhzoNSfMrjP4ZMHbgztQgF1zUS5NAW6TvgZ3j6WJ1dXWOIvvn/PBAuMl0S
	 ZOB6mjQhT2jGeL3BBWvd25pm8baTx5I6fjbIg68lA5cuDpHc+Pj5JUuvEHIitLmNzJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f5sn6/Gf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A56606A31C;
	Wed, 18 Nov 2026 22:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f5sn6/Gf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB291F000C4;
	Wed, 18 Nov 2026 22:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039947;
	bh=/a2EM6fvLI58cWmjFHm9Yga+8l8GMWxbypUkWetv7zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5sn6/GfCrA/G/zzDI79UiwsOrvnMpPNsbxIjIJAqG2So/8dJjadVQjiofTgyfkMx
	 7B9odHhQZMt3NM76F8wS5OJlXPennix57npEzI4i9G6p59SsfGhvsrM74AdrDIynQD
	 Zhw+n8SICxWepDYXto9ksHYInvuHrim1ttmXCnLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Krause <mileskrause5200@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2283/3318] leds: lp8860: Fix device_node leak in lp8860_probe()
Date: Wed, 18 Nov 2026 15:48:25 +0100
Message-ID: <20261118150430.255647705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miles Krause <mileskrause5200@gmail.com>

[ Upstream commit f9879086c4eb4b3b0f4baa80139a5720b99b229e ]

lp8860_probe() looks up the driver's single LED child node with
of_get_next_available_child() and hands it to the LED core as
init_data.fwnode, but never drops the reference that lookup returned:

	child_node = of_get_next_available_child(np, NULL);
	if (!child_node)
		return -EINVAL;
	...
	init_data.fwnode = of_fwnode_handle(child_node);

of_get_next_available_child() returns the node with its refcount
incremented, and the LED core does not take a reference of its own:
led_classdev_register_ext() only reads properties out of
init_data.fwnode and then stores the bare pointer with
device_set_node().  The reference therefore stays owned by the driver
for as long as it holds the node.

Nothing in lp8860_probe() ever releases it, so it is leaked on every
error return taken after the lookup - the enable GPIO, the vled
regulator, devm_mutex_init(), the regmap allocation, the optional
EEPROM programming and the LED class registration - and on a fully
successful probe alike.  A device that binds and unbinds repeatedly
leaks one device_node reference per bind.

Sibling drivers already get this right: leds-lm3692x.c, from the same
TI LED family, calls fwnode_handle_put(init_data.fwnode) once after
devm_led_classdev_register_ext() to cover both outcomes, while
leds-ktd2692.c and leds-aat1290.c take the node with __free(device_node).

Use __free(device_node) here too.  Unlike a single of_node_put() at the
end of probe it also covers the intermediate error returns, and it keeps
the node alive for the whole function, which the LED core still needs
when it reads the child's properties during registration.

Fixes: 99ca0ea57309 ("leds: lp8860: Use generic support for composing LED names")
Signed-off-by: Miles Krause <mileskrause5200@gmail.com>
Link: https://patch.msgid.link/20260910-leds-lp8860-of-node-leak-v1-1-d333cff4345b@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp8860.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp8860.c b/drivers/leds/leds-lp8860.c
index 03d3ca414a75d..65c37150754ae 100644
--- a/drivers/leds/leds-lp8860.c
+++ b/drivers/leds/leds-lp8860.c
@@ -7,6 +7,7 @@
  * Author: Dan Murphy <dmurphy@ti.com>
  */
 
+#include <linux/cleanup.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/leds.h>
@@ -377,14 +378,14 @@ static int lp8860_probe(struct i2c_client *client)
 	int ret;
 	struct lp8860_led *led;
 	struct device_node *np = dev_of_node(&client->dev);
-	struct device_node *child_node;
 	struct led_init_data init_data = {};
 
 	led = devm_kzalloc(&client->dev, sizeof(*led), GFP_KERNEL);
 	if (!led)
 		return -ENOMEM;
 
-	child_node = of_get_next_available_child(np, NULL);
+	struct device_node *child_node __free(device_node) =
+		of_get_next_available_child(np, NULL);
 	if (!child_node)
 		return -EINVAL;
 
-- 
2.53.0



