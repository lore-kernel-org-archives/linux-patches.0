Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206AB28C87C;
	Wed,  8 Apr 2026 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673377; cv=none; b=ARgIqsW9HqOPQ/nwTIPGqhFCcnrNMan3VLimEqMn4gdxZxJ/4zpqf8rSL9OZq5OsxU/IpboDU5NC5bS3j1xtfXrx59A9uoY0EZLEGHgrvCcyQ7LDHG/CctbydgbAZwcOWfyAb9GTwD0VT5pVt9dBZAyChTyLNAWyZoJnjHyt1U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673377; c=relaxed/simple;
	bh=8gXc3rxtlhfBZSu8A80/8/8U54BTUOXL/EBsJJMh5v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGPUqLVbPZQ9ub81f12debJ+B04QYuDzhslNSnFTTpIAFGOjKHnVCguDG/srKV0dC75Ejj21H1GMQxAb/eogBoI/tR1LoBLdfilr0AQ2wGMprs4tAG+mqXlmXK8E1bQN3UOKiOuSNGgt3GTioQsaPUgPsg07QElWelt5eSM7ZfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glvOYgDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glvOYgDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5EBC2BC87;
	Wed,  8 Apr 2026 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673377;
	bh=8gXc3rxtlhfBZSu8A80/8/8U54BTUOXL/EBsJJMh5v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glvOYgDnFBSUzixhokjQ8nI3eKhK93a5HqhwWT2JuOBkpTay9AWFnWeQ76yiBw6/T
	 lSzrXmZhwWNFzmW6i1keD6Ik9y3LpJtXPnvW95eyCQh4To7iqO8HAthpbLsnQI5F9m
	 K4oEGRstQRko2BF+mhwf4rJrN+wuejl0QQpsYrLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 208/277] x86/platform/geode: Fix on-stack property data use-after-return bug
Date: Wed,  8 Apr 2026 20:03:13 +0200
Message-ID: <20260408175941.629523170@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit b981e9e94c687b7b19ae8820963f005b842cb2f2 upstream.

The PROPERTY_ENTRY_GPIO macro (and by extension PROPERTY_ENTRY_REF)
creates a temporary software_node_ref_args structure on the stack
when used in a runtime assignment. This results in the property
pointing to data that is invalid once the function returns.

Fix this by ensuring the GPIO reference data is not stored on stack and
using PROPERTY_ENTRY_REF_ARRAY_LEN() to point directly to the persistent
reference data.

Fixes: 298c9babadb8 ("x86/platform/geode: switch GPIO buttons and LEDs to software properties")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Daniel Scally <djrscally@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Hans de Goede <hansg@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260329-property-gpio-fix-v2-1-3cca5ba136d8@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/platform/geode/geode-common.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/arch/x86/platform/geode/geode-common.c
+++ b/arch/x86/platform/geode/geode-common.c
@@ -28,8 +28,10 @@ static const struct software_node geode_
 	.properties = geode_gpio_keys_props,
 };
 
-static struct property_entry geode_restart_key_props[] = {
-	{ /* Placeholder for GPIO property */ },
+static struct software_node_ref_args geode_restart_gpio_ref;
+
+static const struct property_entry geode_restart_key_props[] = {
+	PROPERTY_ENTRY_REF_ARRAY_LEN("gpios", &geode_restart_gpio_ref, 1),
 	PROPERTY_ENTRY_U32("linux,code", KEY_RESTART),
 	PROPERTY_ENTRY_STRING("label", "Reset button"),
 	PROPERTY_ENTRY_U32("debounce-interval", 100),
@@ -64,8 +66,7 @@ int __init geode_create_restart_key(unsi
 	struct platform_device *pd;
 	int err;
 
-	geode_restart_key_props[0] = PROPERTY_ENTRY_GPIO("gpios",
-							 &geode_gpiochip_node,
+	geode_restart_gpio_ref = SOFTWARE_NODE_REFERENCE(&geode_gpiochip_node,
 							 pin, GPIO_ACTIVE_LOW);
 
 	err = software_node_register_node_group(geode_gpio_keys_swnodes);
@@ -99,6 +100,7 @@ int __init geode_create_leds(const char
 	const struct software_node *group[MAX_LEDS + 2] = { 0 };
 	struct software_node *swnodes;
 	struct property_entry *props;
+	struct software_node_ref_args *gpio_refs;
 	struct platform_device_info led_info = {
 		.name	= "leds-gpio",
 		.id	= PLATFORM_DEVID_NONE,
@@ -127,6 +129,12 @@ int __init geode_create_leds(const char
 		goto err_free_swnodes;
 	}
 
+	gpio_refs = kzalloc_objs(*gpio_refs, n_leds);
+	if (!gpio_refs) {
+		err = -ENOMEM;
+		goto err_free_props;
+	}
+
 	group[0] = &geode_gpio_leds_node;
 	for (i = 0; i < n_leds; i++) {
 		node_name = kasprintf(GFP_KERNEL, "%s:%d", label, i);
@@ -135,9 +143,11 @@ int __init geode_create_leds(const char
 			goto err_free_names;
 		}
 
+		gpio_refs[i] = SOFTWARE_NODE_REFERENCE(&geode_gpiochip_node,
+						       leds[i].pin,
+						       GPIO_ACTIVE_LOW);
 		props[i * 3 + 0] =
-			PROPERTY_ENTRY_GPIO("gpios", &geode_gpiochip_node,
-					    leds[i].pin, GPIO_ACTIVE_LOW);
+			PROPERTY_ENTRY_REF_ARRAY_LEN("gpios", &gpio_refs[i], 1);
 		props[i * 3 + 1] =
 			PROPERTY_ENTRY_STRING("linux,default-trigger",
 					      leds[i].default_on ?
@@ -171,6 +181,8 @@ err_unregister_group:
 err_free_names:
 	while (--i >= 0)
 		kfree(swnodes[i].name);
+	kfree(gpio_refs);
+err_free_props:
 	kfree(props);
 err_free_swnodes:
 	kfree(swnodes);


