Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF602611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDBEC433C7;
	Mon, 28 Aug 2023 10:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218877;
	bh=8VMdgU5KrqO9SjFbkivCjHu5xZfCQbkZxMQqCD3wMsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RK5sMd8KHeNN5eUReEIsSg8F5bttL+KmFnJJA0l4WPGJqoMDjVV+lgzHh2DnG96eL
	 fpGc/3xEb07MEqs74NdoOc7qlyS64NGDkUs7QuMTAlob9gNhp+Y38A9TlYajKuYYgw
	 mwy/eHWXDcQ9yJq19qlo4n8Z+uRBSUzr14RsJbxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 088/122] of: dynamic: Refactor action prints to not use "%pOF" inside devtree_lock
Date: Mon, 28 Aug 2023 12:13:23 +0200
Message-ID: <20230828101159.326845462@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

commit 914d9d831e6126a6e7a92e27fcfaa250671be42c upstream.

While originally it was fine to format strings using "%pOF" while
holding devtree_lock, this now causes a deadlock.  Lockdep reports:

    of_get_parent from of_fwnode_get_parent+0x18/0x24
    ^^^^^^^^^^^^^
    of_fwnode_get_parent from fwnode_count_parents+0xc/0x28
    fwnode_count_parents from fwnode_full_name_string+0x18/0xac
    fwnode_full_name_string from device_node_string+0x1a0/0x404
    device_node_string from pointer+0x3c0/0x534
    pointer from vsnprintf+0x248/0x36c
    vsnprintf from vprintk_store+0x130/0x3b4

Fix this by moving the printing in __of_changeset_entry_apply() outside
the lock. As the only difference in the multiple prints is the action
name, use the existing "action_names" to refactor the prints into a
single print.

Fixes: a92eb7621b9fb2c2 ("lib/vsprintf: Make use of fwnode API to obtain node names and separators")
Cc: stable@vger.kernel.org
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230801-dt-changeset-fixes-v3-2-5f0410e007dd@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/dynamic.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -63,15 +63,14 @@ int of_reconfig_notifier_unregister(stru
 }
 EXPORT_SYMBOL_GPL(of_reconfig_notifier_unregister);
 
-#ifdef DEBUG
-const char *action_names[] = {
+static const char *action_names[] = {
+	[0] = "INVALID",
 	[OF_RECONFIG_ATTACH_NODE] = "ATTACH_NODE",
 	[OF_RECONFIG_DETACH_NODE] = "DETACH_NODE",
 	[OF_RECONFIG_ADD_PROPERTY] = "ADD_PROPERTY",
 	[OF_RECONFIG_REMOVE_PROPERTY] = "REMOVE_PROPERTY",
 	[OF_RECONFIG_UPDATE_PROPERTY] = "UPDATE_PROPERTY",
 };
-#endif
 
 int of_reconfig_notify(unsigned long action, struct of_reconfig_data *p)
 {
@@ -594,21 +593,9 @@ static int __of_changeset_entry_apply(st
 		}
 
 		ret = __of_add_property(ce->np, ce->prop);
-		if (ret) {
-			pr_err("changeset: add_property failed @%pOF/%s\n",
-				ce->np,
-				ce->prop->name);
-			break;
-		}
 		break;
 	case OF_RECONFIG_REMOVE_PROPERTY:
 		ret = __of_remove_property(ce->np, ce->prop);
-		if (ret) {
-			pr_err("changeset: remove_property failed @%pOF/%s\n",
-				ce->np,
-				ce->prop->name);
-			break;
-		}
 		break;
 
 	case OF_RECONFIG_UPDATE_PROPERTY:
@@ -622,20 +609,17 @@ static int __of_changeset_entry_apply(st
 		}
 
 		ret = __of_update_property(ce->np, ce->prop, &old_prop);
-		if (ret) {
-			pr_err("changeset: update_property failed @%pOF/%s\n",
-				ce->np,
-				ce->prop->name);
-			break;
-		}
 		break;
 	default:
 		ret = -EINVAL;
 	}
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
-	if (ret)
+	if (ret) {
+		pr_err("changeset: apply failed: %-15s %pOF:%s\n",
+		       action_names[ce->action], ce->np, ce->prop->name);
 		return ret;
+	}
 
 	switch (ce->action) {
 	case OF_RECONFIG_ATTACH_NODE:
@@ -921,6 +905,9 @@ int of_changeset_action(struct of_change
 	if (!ce)
 		return -ENOMEM;
 
+	if (WARN_ON(action >= ARRAY_SIZE(action_names)))
+		return -EINVAL;
+
 	/* get a reference to the node */
 	ce->action = action;
 	ce->np = of_node_get(np);


