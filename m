Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0248F1D5ABA;
	Wed, 25 Feb 2026 01:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983190; cv=none; b=vGpaKc37EI+uX+P9NvqFf8rq5JXnkwos4r6B3JWBZXqycXIOlCHfpOYDUtzYd56dFDWnuOG0ZiIKILVTmvmxF8c5jA9S6LmGBWBCtXtjjM+Z3rhjfbDN5/gETx9dbMvmv2G0IEWzEvrPS0jAC//Ql/rTh7uhx4vmFCzgvC/MNc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983190; c=relaxed/simple;
	bh=ChonPSgZDZLZscUWs6vbttXzxVP4V6x9nRjwcaFgyEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xb3xqh7aDOalGA8EBaz1mlZhz2rMe8CyosEVnmHhlO7xRGOPVkG8Hx8H6hqiu+tPqCVMzHT/+tY/8WpVfK+0PS2dW3ZUDiEs/Yf8N1vy9N5qHTWjlA+koMXFkpk1bIba3yHNpWUZoL3zUmnakXGsPHeeGJBeNRSNaUge2zOf8OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLITzQpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLITzQpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D53C116D0;
	Wed, 25 Feb 2026 01:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983189;
	bh=ChonPSgZDZLZscUWs6vbttXzxVP4V6x9nRjwcaFgyEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLITzQpz1r1QqmeLREU9LAKu6msc7gp3Re+uykLx3Y74zEtAtm1Y5v7Ohj91QmV1P
	 8Ok7fpl1ojwyIqyblnnu36tfgdpEKg1C8Lg/hzVsK8ppKzRu6HheW964Ne3IYrJ1hv
	 OWqDtUDHEgSnVXFWJ7YMY0iAWQe/65RFb5SYTW8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 303/781] ASoC: SDCA: Handle volatile controls correctly
Date: Tue, 24 Feb 2026 17:16:52 -0800
Message-ID: <20260225012407.141266741@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 498aba9df5d9b..9685281529e9f 100644
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
@@ -792,6 +793,48 @@ static int control_limit_kctl(struct device *dev,
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
@@ -849,8 +892,13 @@ static int populate_control(struct device *dev,
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



