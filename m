Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C101C3054EC;
	Tue,  2 Sep 2025 13:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820222; cv=none; b=IFIvWaSVBT4TJQNrt9vFUKiu7lPr4RHU4WlAKqDGf4UtCaA+0Tss73DH31QhFXh/nA5E6QtL5sVyxBuhj0yxnZrjJk7FqaK3b7r15FC1k2V9k/U0SMRx7nFzNKkXAiuB0h9xdRWcHCUjVv69FAarPkvcmsGlHl0HIz5f3hjz1wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820222; c=relaxed/simple;
	bh=HHmRj2tZVNrxpD7z80ejDNq9rlnpWgyhvrkvqAeNIsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsS06ibdmKZQ+p/nWjsHTrNR0iMpaXPiGuDA7hFntKVDhG6WT7y7ENApaFexAH37fTlicJFlqnWqBtsVqfcTXQ3uiThPi3eBsSY8WvkeLUhP6qUmIbQi8JaH2408OyUy/N0DGPhhPHWuVMZK3vcrYJsDYyK725xLVksW0ZMSLCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ebajfyoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ebajfyoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D402BC4CEED;
	Tue,  2 Sep 2025 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820222;
	bh=HHmRj2tZVNrxpD7z80ejDNq9rlnpWgyhvrkvqAeNIsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbajfyoiQlmeWxDGgTQwcCMe0x+Q30byKXY0myTOsTKhdksbkUvhaUMyR1LCB2d1X
	 qu46t/3qeVkck2/mCXLGAV/nTHCbx/oFx0sBeg432Yhkue7hKvmogAXayHLoroEvsa
	 IFBV/ST4eBxLfak1ywrxL18lNVBqZ+3ZFannGOy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/75] of: Add a helper to free property struct
Date: Tue,  2 Sep 2025 15:20:17 +0200
Message-ID: <20250902131935.326327706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 1c5e3d9bf33b811e1c6dd9081b322004acc4a1fd ]

Freeing a property struct is 3 kfree()'s which is duplicated in multiple
spots. Add a helper, __of_prop_free(), and replace all the open coded
cases in the DT code.

Reviewed-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240409-dt-cleanup-free-v2-1-5b419a4af38d@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 80af3745ca46 ("of: dynamic: Fix use after free in of_changeset_add_prop_helper()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/dynamic.c    | 26 ++++++++++++--------------
 drivers/of/of_private.h |  1 +
 drivers/of/overlay.c    | 11 +++--------
 drivers/of/unittest.c   | 12 +++---------
 4 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 7f78fba502ec4..72531f44adf09 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -306,15 +306,20 @@ int of_detach_node(struct device_node *np)
 }
 EXPORT_SYMBOL_GPL(of_detach_node);
 
+void __of_prop_free(struct property *prop)
+{
+	kfree(prop->name);
+	kfree(prop->value);
+	kfree(prop);
+}
+
 static void property_list_free(struct property *prop_list)
 {
 	struct property *prop, *next;
 
 	for (prop = prop_list; prop != NULL; prop = next) {
 		next = prop->next;
-		kfree(prop->name);
-		kfree(prop->value);
-		kfree(prop);
+		__of_prop_free(prop);
 	}
 }
 
@@ -427,9 +432,7 @@ struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags)
 	return new;
 
  err_free:
-	kfree(new->name);
-	kfree(new->value);
-	kfree(new);
+	__of_prop_free(new);
 	return NULL;
 }
 
@@ -471,9 +474,7 @@ struct device_node *__of_node_dup(const struct device_node *np,
 			if (!new_pp)
 				goto err_prop;
 			if (__of_add_property(node, new_pp)) {
-				kfree(new_pp->name);
-				kfree(new_pp->value);
-				kfree(new_pp);
+				__of_prop_free(new_pp);
 				goto err_prop;
 			}
 		}
@@ -933,11 +934,8 @@ static int of_changeset_add_prop_helper(struct of_changeset *ocs,
 		return -ENOMEM;
 
 	ret = of_changeset_add_property(ocs, np, new_pp);
-	if (ret) {
-		kfree(new_pp->name);
-		kfree(new_pp->value);
-		kfree(new_pp);
-	}
+	if (ret)
+		__of_prop_free(new_pp);
 
 	new_pp->next = np->deadprops;
 	np->deadprops = new_pp;
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 21f8f5e80917d..73b55f4f84a3c 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -123,6 +123,7 @@ extern void *__unflatten_device_tree(const void *blob,
  * own the devtree lock or work on detached trees only.
  */
 struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags);
+void __of_prop_free(struct property *prop);
 struct device_node *__of_node_dup(const struct device_node *np,
 				  const char *full_name);
 
diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index a9a292d6d59b2..dc13299586414 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -262,9 +262,7 @@ static struct property *dup_and_fixup_symbol_prop(
 	return new_prop;
 
 err_free_new_prop:
-	kfree(new_prop->name);
-	kfree(new_prop->value);
-	kfree(new_prop);
+	__of_prop_free(new_prop);
 err_free_target_path:
 	kfree(target_path);
 
@@ -361,11 +359,8 @@ static int add_changeset_property(struct overlay_changeset *ovcs,
 		pr_err("WARNING: memory leak will occur if overlay removed, property: %pOF/%s\n",
 		       target->np, new_prop->name);
 
-	if (ret) {
-		kfree(new_prop->name);
-		kfree(new_prop->value);
-		kfree(new_prop);
-	}
+	if (ret)
+		__of_prop_free(new_prop);
 	return ret;
 }
 
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 3b22c36bfb0b7..5bfec440b4fd7 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -800,15 +800,11 @@ static void __init of_unittest_property_copy(void)
 
 	new = __of_prop_dup(&p1, GFP_KERNEL);
 	unittest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
-	kfree(new->value);
-	kfree(new->name);
-	kfree(new);
+	__of_prop_free(new);
 
 	new = __of_prop_dup(&p2, GFP_KERNEL);
 	unittest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
-	kfree(new->value);
-	kfree(new->name);
-	kfree(new);
+	__of_prop_free(new);
 #endif
 }
 
@@ -3665,9 +3661,7 @@ static __init void of_unittest_overlay_high_level(void)
 				goto err_unlock;
 			}
 			if (__of_add_property(of_symbols, new_prop)) {
-				kfree(new_prop->name);
-				kfree(new_prop->value);
-				kfree(new_prop);
+				__of_prop_free(new_prop);
 				/* "name" auto-generated by unflatten */
 				if (!strcmp(prop->name, "name"))
 					continue;
-- 
2.50.1



