Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED312512D9;
	Wed,  5 Mar 2025 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198120; cv=none; b=FVwxzDd5O9FntkZgXA6FSwUq7bPrIOU83h4mx5/2WNgaNw32/NjtTzGdWZwGoHD6KktKtFzT6im1lZkdhXsFICoCpe1OlXfdo0EKvz2nrgZZPfMqvMqbLz9NpJzApSoEOO3uOkkZ2fy5XtVVU8ljd5IVJW0EFheG3djJFdrgFe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198120; c=relaxed/simple;
	bh=mbYeaev7IbsvvJ1ErQL985FvhPC2O5nF4A8DJrZqo7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPz6LZYVm0Te+qaaGTO5MesgYr9jzPXqv8k3TGW1g/aj/bVm9b91bdwKjEi80WX607sTT6fPsoZryiHWmxlyK+LyH1XahgXNUXKMiQZC7KJ2Yu7QFhOH7lFsoYYNaAnYYGlTpAtCfxWG0MEJS+tpFGzmMydeRi0oNMbucRHmpYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDTwV3GR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDTwV3GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC25CC4CEE0;
	Wed,  5 Mar 2025 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198120;
	bh=mbYeaev7IbsvvJ1ErQL985FvhPC2O5nF4A8DJrZqo7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDTwV3GRxJvojqNGat3Bdiy57xYpbsRCu/Gnf4izmjOudI4Dx3RVD7aN7Yl3EmYbR
	 3vSBA+GDX/BSi+Z345owloE0/AeVc6j716BQ/JNMO+ybjwZxBR5OLRnYSPkO5lZdE8
	 4xYAEV4ZNscOsZKwQ8gDkXYA7BYn1j8itiqE0J5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Che Cheng <giver@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/150] thermal/of: Fix cdev lookup in thermal_of_should_bind()
Date: Wed,  5 Mar 2025 18:48:20 +0100
Message-ID: <20250305174506.667893614@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 423de5b5bc5b267586b449abd1c4fde562aa0cf9 ]

Since thermal_of_should_bind() terminates the loop after processing
the first child found in cooling-maps, it will never match more than
one cdev to a given trip point which is incorrect, as there may be
cooling-maps associating one trip point with multiple cooling devices.

Address this by letting the loop continue until either all
children have been processed or a matching one has been found.

To avoid adding conditionals or goto statements, put the loop in
question into a separate function and make that function return
right away after finding a matching cooling-maps entry.

Fixes: 94c6110b0b13 ("thermal/of: Use the .should_bind() thermal zone callback")
Link: https://lore.kernel.org/linux-pm/20250219-fix-thermal-of-v1-1-de36e7a590c4@chromium.org/
Reported-by: Yu-Che Cheng <giver@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Yu-Che Cheng <giver@chromium.org>
Tested-by: Yu-Che Cheng <giver@chromium.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/2788228.mvXUDI8C0e@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 50 +++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 111d2c15601b9..e0aa9d9d5604b 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -293,6 +293,34 @@ static bool thermal_of_get_cooling_spec(struct device_node *map_np, int index,
 	return true;
 }
 
+static bool thermal_of_cm_lookup(struct device_node *cm_np,
+				 const struct thermal_trip *trip,
+				 struct thermal_cooling_device *cdev,
+				 struct cooling_spec *c)
+{
+	for_each_child_of_node_scoped(cm_np, child) {
+		struct device_node *tr_np;
+		int count, i;
+
+		tr_np = of_parse_phandle(child, "trip", 0);
+		if (tr_np != trip->priv)
+			continue;
+
+		/* The trip has been found, look up the cdev. */
+		count = of_count_phandle_with_args(child, "cooling-device",
+						   "#cooling-cells");
+		if (count <= 0)
+			pr_err("Add a cooling_device property with at least one device\n");
+
+		for (i = 0; i < count; i++) {
+			if (thermal_of_get_cooling_spec(child, i, cdev, c))
+				return true;
+		}
+	}
+
+	return false;
+}
+
 static bool thermal_of_should_bind(struct thermal_zone_device *tz,
 				   const struct thermal_trip *trip,
 				   struct thermal_cooling_device *cdev,
@@ -312,27 +340,7 @@ static bool thermal_of_should_bind(struct thermal_zone_device *tz,
 		goto out;
 
 	/* Look up the trip and the cdev in the cooling maps. */
-	for_each_child_of_node_scoped(cm_np, child) {
-		struct device_node *tr_np;
-		int count, i;
-
-		tr_np = of_parse_phandle(child, "trip", 0);
-		if (tr_np != trip->priv)
-			continue;
-
-		/* The trip has been found, look up the cdev. */
-		count = of_count_phandle_with_args(child, "cooling-device", "#cooling-cells");
-		if (count <= 0)
-			pr_err("Add a cooling_device property with at least one device\n");
-
-		for (i = 0; i < count; i++) {
-			result = thermal_of_get_cooling_spec(child, i, cdev, c);
-			if (result)
-				break;
-		}
-
-		break;
-	}
+	result = thermal_of_cm_lookup(cm_np, trip, cdev, c);
 
 	of_node_put(cm_np);
 out:
-- 
2.39.5



