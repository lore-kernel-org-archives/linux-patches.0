Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D199B15EFC3;
	Mon, 27 May 2024 19:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837747; cv=none; b=VZeF2+LgJp3Cb7ipY21tQjY5yUDnCQCtxY9dJvTP54Oirzub0BfOh5W9lHo/7GZwi5WVpvr5Wk3TAxwG4ELrdnHtuzKmWSZW5wZB4wSpjfu4nbaTPHAND68QW7lW2otxgNiOb2TRihbYk0cVQ4gGiY86tVQmfpvUvWvMpMoUDLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837747; c=relaxed/simple;
	bh=ScK7hOdCBZzFenjl1Q2mzXWOO3qu9kjUZB/YDqCHS1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR483UnbkbVPiSJm4Rp4bUk63mMgw5GgaVWgK9dt+ETcJfU8Jo3GnkjA9V8dnboj0rs9xkZZMrQl/mXX+uZGf3VKvd35XfRpV2LeyIzrD1wvgpyNJ4oTgHxSXwuILU6oJRhJpB/xTpKbsgsGU/mj8NGsQhturSNLb5paZ+txPW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJmG/u0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJmG/u0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C45C32786;
	Mon, 27 May 2024 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837747;
	bh=ScK7hOdCBZzFenjl1Q2mzXWOO3qu9kjUZB/YDqCHS1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJmG/u0Xj9hz1odmoqrRhmI5ZHPvDs1vU7Su9ej73Ee9N0SkyMxcSyT0g5BpGhJjA
	 6EYOq6wJp+C7nwruOPFlMM1LM+iwrq+cs1uEn+foQexJS2mgluObW0b3og0xWmpUeH
	 t2Wwjsjw35keBoVGgJwhz1WnStF3/bkwqPGCEcjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 089/493] ASoC: cs35l56: fix usages of device_get_named_child_node()
Date: Mon, 27 May 2024 20:51:31 +0200
Message-ID: <20240527185633.277433206@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit fbd741f0993203d07b2b6562d68d1e5e4745b59b ]

The documentation for device_get_named_child_node() mentions this
important point:

"
The caller is responsible for calling fwnode_handle_put() on the
returned fwnode pointer.
"

Add fwnode_handle_put() to avoid leaked references.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240426152939.38471-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 6dd0319bc843c..ea72afe3f906f 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1297,6 +1297,7 @@ static int cs35l56_try_get_broken_sdca_spkid_gpio(struct cs35l56_private *cs35l5
 				    "spk-id-gpios", ACPI_TYPE_PACKAGE, &obj);
 	if (ret) {
 		dev_dbg(cs35l56->base.dev, "Could not get spk-id-gpios package: %d\n", ret);
+		fwnode_handle_put(af01_fwnode);
 		return -ENOENT;
 	}
 
@@ -1304,6 +1305,7 @@ static int cs35l56_try_get_broken_sdca_spkid_gpio(struct cs35l56_private *cs35l5
 	if (obj->package.count != 4) {
 		dev_warn(cs35l56->base.dev, "Unexpected spk-id element count %d\n",
 			 obj->package.count);
+		fwnode_handle_put(af01_fwnode);
 		return -ENOENT;
 	}
 
@@ -1318,6 +1320,7 @@ static int cs35l56_try_get_broken_sdca_spkid_gpio(struct cs35l56_private *cs35l5
 		 */
 		ret = acpi_dev_add_driver_gpios(adev, cs35l56_af01_spkid_gpios_mapping);
 		if (ret) {
+			fwnode_handle_put(af01_fwnode);
 			return dev_err_probe(cs35l56->base.dev, ret,
 					     "Failed to add gpio mapping to AF01\n");
 		}
@@ -1325,14 +1328,17 @@ static int cs35l56_try_get_broken_sdca_spkid_gpio(struct cs35l56_private *cs35l5
 		ret = devm_add_action_or_reset(cs35l56->base.dev,
 					       cs35l56_acpi_dev_release_driver_gpios,
 					       adev);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(af01_fwnode);
 			return ret;
+		}
 
 		dev_dbg(cs35l56->base.dev, "Added spk-id-gpios mapping to AF01\n");
 	}
 
 	desc = fwnode_gpiod_get_index(af01_fwnode, "spk-id", 0, GPIOD_IN, NULL);
 	if (IS_ERR(desc)) {
+		fwnode_handle_put(af01_fwnode);
 		ret = PTR_ERR(desc);
 		return dev_err_probe(cs35l56->base.dev, ret, "Get GPIO from AF01 failed\n");
 	}
@@ -1341,9 +1347,12 @@ static int cs35l56_try_get_broken_sdca_spkid_gpio(struct cs35l56_private *cs35l5
 	gpiod_put(desc);
 
 	if (ret < 0) {
+		fwnode_handle_put(af01_fwnode);
 		dev_err_probe(cs35l56->base.dev, ret, "Error reading spk-id GPIO\n");
 		return ret;
-		}
+	}
+
+	fwnode_handle_put(af01_fwnode);
 
 	dev_info(cs35l56->base.dev, "Got spk-id from AF01\n");
 
-- 
2.43.0



