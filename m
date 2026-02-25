Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0191251795;
	Wed, 25 Feb 2026 01:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983977; cv=none; b=oIBSrcasNJrPAQ3ly3NKOlNd2HuLro0i6sgdDCY57SczI+5IippeiVlp3AE/sv1ompeg3fLVkJzvJWGu6UxczvkQXjvXNha5CSA3+g8MO1KncyWRAAkfX6f/xPSgh+1mp10dGOOB4sUP8W6n9jZlil3wAdlXL4KUC5pcXJA9lKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983977; c=relaxed/simple;
	bh=MTsQemdt8StVzY778CwSdW1c0QFfwVMpJnUJOCbe31g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoW2YWar3qWgkWmOX35JQk09BLvZ3KNBpcou0tX53VMbrhYDoZ/I/N46dU44i+yNkndra8pVdZpBLmVkKuamQKEei6mAQXER58WCjvQnlkI9HY8l3YYJkmiITGQJUo+ZBBePoYHqLszH6lG0FvxwqYU6NJ4JkFp2or4WwdaJbmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KducAZbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KducAZbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883ACC116D0;
	Wed, 25 Feb 2026 01:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983977;
	bh=MTsQemdt8StVzY778CwSdW1c0QFfwVMpJnUJOCbe31g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KducAZbTvIb8ljSkNBV3yRqJw8wjZG7P8i/joqFGevdFk+Z/ukfrtUfB9gEvnzcx3
	 2j6iZUPhlXGxiSA+c4b+W3woqbG/jfaM/50fTJbv+cGZwWUCWT8PUYMIMc9cMWDW/M
	 BJkG5+DjItTGb27BfUU/KT58s0nMz3+TveCSWMFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 230/641] ASoC: SDCA: Handle volatile controls correctly
Date: Tue, 24 Feb 2026 17:19:16 -0800
Message-ID: <20260225012354.472778651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 9fad74b79e5ff353fe156c4b685cceffa5afdb1d ]

There are very few volatile controls in SDCA that are exported
as ALSA controls, typically Detected Mode is the only common
one. However, the current code does not resume the device when
these ALSA controls are accessed, which will result in the
read/write failing.

Add a new wrapper specifically for volatile controls that will do
the required pm_runtime operations before accessing the register.

Fixes: c3ca24e3fcb6 ("ASoC: SDCA: Create ALSA controls from DisCo")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260204125944.1134011-3-ckeepax@opensource.cirrus.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_asoc.c | 52 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sdca/sdca_asoc.c b/sound/soc/sdca/sdca_asoc.c
index 7e986870d48c5..197a592ec2f16 100644
--- a/sound/soc/sdca/sdca_asoc.c
+++ b/sound/soc/sdca/sdca_asoc.c
@@ -16,6 +16,7 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/overflow.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/string_helpers.h>
@@ -836,6 +837,48 @@ static int control_limit_kctl(struct device *dev,
 	return 0;
 }
 
+static int volatile_get_volsw(struct snd_kcontrol *kcontrol,
+			      struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
+	struct device *dev = component->dev;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0) {
+		dev_err(dev, "failed to resume reading %s: %d\n",
+			kcontrol->id.name, ret);
+		return ret;
+	}
+
+	ret = snd_soc_get_volsw(kcontrol, ucontrol);
+
+	pm_runtime_put(dev);
+
+	return ret;
+}
+
+static int volatile_put_volsw(struct snd_kcontrol *kcontrol,
+			      struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
+	struct device *dev = component->dev;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0) {
+		dev_err(dev, "failed to resume writing %s: %d\n",
+			kcontrol->id.name, ret);
+		return ret;
+	}
+
+	ret = snd_soc_put_volsw(kcontrol, ucontrol);
+
+	pm_runtime_put(dev);
+
+	return ret;
+}
+
 static int populate_control(struct device *dev,
 			    struct sdca_function_data *function,
 			    struct sdca_entity *entity,
@@ -890,8 +933,13 @@ static int populate_control(struct device *dev,
 	(*kctl)->private_value = (unsigned long)mc;
 	(*kctl)->iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	(*kctl)->info = snd_soc_info_volsw;
-	(*kctl)->get = snd_soc_get_volsw;
-	(*kctl)->put = snd_soc_put_volsw;
+	if (control->is_volatile) {
+		(*kctl)->get = volatile_get_volsw;
+		(*kctl)->put = volatile_put_volsw;
+	} else {
+		(*kctl)->get = snd_soc_get_volsw;
+		(*kctl)->put = snd_soc_put_volsw;
+	}
 
 	if (readonly_control(control))
 		(*kctl)->access = SNDRV_CTL_ELEM_ACCESS_READ;
-- 
2.51.0



