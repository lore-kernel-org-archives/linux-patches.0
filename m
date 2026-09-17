Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123C5582BBB;
	Thu, 17 Sep 2026 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659403; cv=none; b=eK/oCaBM1BJbqmChjdET/rAgyXhNf+xs3I2SKkForufsoD12oVC9MYfdnlh9PkNx6tEzHfpGE3hRa+HI9KOegZjYOl3+/bL1MTTHp0fvIty0RIZ7m2f3ysWWxINmhfLBDJZYSR+76ouM/9bMhDokkuUlLXnjpwa0c7sfYHncwsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659403; c=relaxed/simple;
	bh=SDYmh8g2MJnOxPVXV4S6RI47tIM645pcquSZ8WidQzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtoEIu43OB8UVB4BwrZPXCOHp/tqy9869z7gjcqpDmb9dxYbfolDJvf+U4JXtmLwNRyhxYEYfzCriu97TL8OAnw7i+uvb0P7jmFWpvg0euq7So2yhnoPxedRRmHKtsEtfqNu4SU+WPLeOkFpw72vi3bHjHrUwZGrRYiy506vTJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrzCphr3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrzCphr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3ED1F00899;
	Thu, 17 Sep 2026 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659395;
	bh=NIJALGeuDyQnoEqBuQIOEyzxpCtCfAuUfbXTJuzwZKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrzCphr3D/RI18Sv1+3KWRwRJKxvjhNYc+5ryg+gmu51Lw8ibsYEk8SVVaw1plcRT
	 qq+0q4XIx4aymw9XAJzaYc+IpV07+8UHHKhEE6lYWTIpWop7sE945tqCgv0lfA7rUk
	 fHdZCZx1Yyujb/KfA6I04656ra/mCLvK8xaErzOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 241/733] ASoC: Intel: avs: Do not ignore -ENOENT when loading a topology
Date: Thu, 17 Sep 2026 16:09:09 +0100
Message-ID: <20260917151357.268410394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c6dceca9f78fbd478c41735457c4de9c25a6b1c8 ]

avs_load_topology() combines request_firmware() and
snd_soc_tplg_component_load().  The fallback mechanism introduced for
the HDAudio based boards honors -ENOENT and checks for a generic
topology if no specific is found before giving up and failing the
component probing.

However, if -ENOENT is returned by the latter function -
snd_soc_tplg_component_load() - is shall not be ignored.  That means
there is an actual problem with the topology file and no fallback shall
be attempted.

Fixes: 739c031110da ("ASoC: Intel: avs: Provide support for fallback topology")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260902081814.1590883-7-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c      | 34 ++++++++++++++++++++--------------
 sound/soc/intel/avs/topology.c |  2 +-
 sound/soc/intel/avs/topology.h |  1 +
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 797b9c9163b49..094ea1366ea8f 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -6,6 +6,7 @@
 //          Amadeusz Slawinski <amadeuszx.slawinski@linux.intel.com>
 //
 
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <sound/hda_register.h>
@@ -987,13 +988,25 @@ static int avs_component_load_libraries(struct avs_soc_component *acomp)
 	return ret;
 }
 
+static int avs_request_topology(struct snd_soc_component *component, const char *name,
+				const struct firmware **fw)
+{
+	char *fullname __free(kfree) = NULL;
+
+	fullname = kasprintf(GFP_KERNEL, "%s/%s", component->driver->topology_name_prefix, name);
+	if (!fullname)
+		return -ENOMEM;
+
+	return request_firmware(fw, fullname, component->dev);
+}
+
 static int avs_component_probe(struct snd_soc_component *component)
 {
 	struct snd_soc_card *card = component->card;
 	struct snd_soc_acpi_mach *mach;
 	struct avs_soc_component *acomp;
+	const struct firmware *fw;
 	struct avs_dev *adev;
-	char *filename;
 	int ret;
 
 	dev_dbg(card->dev, "probing %s card %s\n", component->name, card->name);
@@ -1009,13 +1022,7 @@ static int avs_component_probe(struct snd_soc_component *component)
 		goto finalize;
 
 	/* Load specified topology and create debugfs for it. */
-	filename = kasprintf(GFP_KERNEL, "%s/%s", component->driver->topology_name_prefix,
-			     mach->tplg_filename);
-	if (!filename)
-		return -ENOMEM;
-
-	ret = avs_load_topology(component, filename);
-	kfree(filename);
+	ret = avs_request_topology(component, mach->tplg_filename, &fw);
 	if (ret == -ENOENT && !strncmp(mach->tplg_filename, "hda-", 4)) {
 		unsigned int vendor_id;
 
@@ -1030,18 +1037,17 @@ static int avs_component_probe(struct snd_soc_component *component)
 							     "hda-generic-tplg.bin");
 		if (!mach->tplg_filename)
 			return -ENOMEM;
-		filename = kasprintf(GFP_KERNEL, "%s/%s", component->driver->topology_name_prefix,
-				     mach->tplg_filename);
-		if (!filename)
-			return -ENOMEM;
 
 		dev_info(card->dev, "trying to load fallback topology %s\n", mach->tplg_filename);
-		ret = avs_load_topology(component, filename);
-		kfree(filename);
+		ret = avs_request_topology(component, mach->tplg_filename, &fw);
 	}
 	if (ret < 0)
 		return ret;
 
+	ret = snd_soc_tplg_component_load(component, &avs_tplg_ops, fw);
+	if (ret)
+		return ret;
+
 	ret = avs_component_load_libraries(acomp);
 	if (ret < 0) {
 		dev_err(card->dev, "libraries loading failed: %d\n", ret);
diff --git a/sound/soc/intel/avs/topology.c b/sound/soc/intel/avs/topology.c
index 9033f683393c4..0a267937044de 100644
--- a/sound/soc/intel/avs/topology.c
+++ b/sound/soc/intel/avs/topology.c
@@ -2194,7 +2194,7 @@ avs_control_load(struct snd_soc_component *comp, int index, struct snd_kcontrol_
 	return 0;
 }
 
-static const struct snd_soc_tplg_ops avs_tplg_ops = {
+const struct snd_soc_tplg_ops avs_tplg_ops = {
 	.io_ops			= avs_control_ops,
 	.io_ops_count		= ARRAY_SIZE(avs_control_ops),
 	.control_load		= avs_control_load,
diff --git a/sound/soc/intel/avs/topology.h b/sound/soc/intel/avs/topology.h
index 1cf7455b6c010..b5799c994b887 100644
--- a/sound/soc/intel/avs/topology.h
+++ b/sound/soc/intel/avs/topology.h
@@ -230,6 +230,7 @@ struct avs_tplg_module {
 	struct list_head node;
 };
 
+extern const struct snd_soc_tplg_ops avs_tplg_ops;
 struct avs_tplg *avs_tplg_new(struct snd_soc_component *comp);
 
 int avs_load_topology(struct snd_soc_component *comp, const char *filename);
-- 
2.53.0



