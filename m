Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC1578C9C;
	Sun,  7 Jun 2026 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826827; cv=none; b=fy2vBVel6CiT5EVaJr5cUMlRXHLafqeq1rluK3I3ZFGAuzS49jnb8tK1gjaVPxksS2VGoRj2pEn1TcLwcaJhiRGwPgzhJmbGVjYaFQjPuFrpiOFySwKwDBGptng7ydRqRi1F6T4DQ60LHpSqDDVVVSDV9h0bJH5x8cEbDtoYGas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826827; c=relaxed/simple;
	bh=CHf0luEhe3zFXSHWQH2ezubJfr9pH2wwHGNYYB8pVHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZPWf/ZtnHJRwT+jJ3vPQR2VL2Guo3SwHrUIyk/m8EjkTPgxhyejYju2rNl0w+2XBvkzxg29SVLamJ6iZ3GGG7jwNdql/RK9fwkmIhBap9gQgu0lWrLsjVWgBaNm4edU0E97gwKZD29a6h08PnwKIurDYx5BQoVBYBuxNeJQ5HnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ErPeEPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ErPeEPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEC71F00893;
	Sun,  7 Jun 2026 10:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826826;
	bh=2JSSuqcVl3JDMbWPX3Lv87ytmweoCexQF//US5sqRuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ErPeEPuwJS8tEs5W0mwabMNPnJmdgU7e+nsFLSfgjttgB4Y/je7N6ZRW88izzeY0
	 2ofJrkTSM1e6Xs9l28aH2zZxX6Wqrz9YLmuUUhEZhu1BP4s83fXtVQ7fvA52i6tXDi
	 yTo4k5sEq6jGz1VCZJg0UiJC21t1ZglmrVJdXd+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 032/332] ALSA: hda: cs35l56: Fix system name string leaks
Date: Sun,  7 Jun 2026 11:56:41 +0200
Message-ID: <20260607095729.271206086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit a0d9e8df2ebca290c2efff70abc05426e5a476b0 ]

cs35l56_hda_read_acpi() gets an allocated ACPI _SUB string from
acpi_get_subsystem_id(). On success, that string is used to create the
firmware system name.

Several error paths after the _SUB lookup can return without releasing
the allocated string. This includes speaker ID lookup errors other than
-ENOENT, and errors after a firmware system name has been allocated.

Use scoped cleanup for the temporary _SUB string and make
cs35l56->system_name device-managed. This releases the temporary _SUB
string on every error path and lets devres release the firmware system
name on probe failure and device removal.

Fixes: 6f03b446cbae ("ALSA: hda: cs35l56: Add support for speaker id")
Fixes: 40b1c2f9b299 ("ALSA: hda/cs35l56: Workaround bad dev-index on Lenovo Yoga Book 9i GenX")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260522-alsa-cs35l56-system-name-leak-v4-1-a6154dd09cd9@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index cdbc576569efee..a0ea08eb96a93f 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -1025,7 +1025,7 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 	u32 values[HDA_MAX_COMPONENTS];
 	char hid_string[8];
 	struct acpi_device *adev;
-	const char *property, *sub;
+	const char *property;
 	int i, ret;
 
 	/*
@@ -1047,7 +1047,8 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 	/* Initialize things that could be overwritten by a fixup */
 	cs35l56->index = -1;
 
-	sub = acpi_get_subsystem_id(ACPI_HANDLE(cs35l56->base.dev));
+	const char *sub __free(kfree) = acpi_get_subsystem_id(ACPI_HANDLE(cs35l56->base.dev));
+
 	ret = cs35l56_hda_apply_platform_fixups(cs35l56, sub, &id);
 	if (ret)
 		return ret;
@@ -1095,15 +1096,16 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 		ret = cirrus_scodec_get_speaker_id(cs35l56->base.dev, cs35l56->index,
 						   cs35l56->num_amps, -1);
 		if (ret == -ENOENT) {
-			cs35l56->system_name = sub;
+			cs35l56->system_name = devm_kstrdup(cs35l56->base.dev, sub, GFP_KERNEL);
 		} else if (ret >= 0) {
-			cs35l56->system_name = kasprintf(GFP_KERNEL, "%s-spkid%d", sub, ret);
-			kfree(sub);
-			if (!cs35l56->system_name)
-				return -ENOMEM;
+			cs35l56->system_name = devm_kasprintf(cs35l56->base.dev, GFP_KERNEL,
+							      "%s-spkid%d", sub, ret);
 		} else {
 			return ret;
 		}
+
+		if (!cs35l56->system_name)
+			return -ENOMEM;
 	}
 
 	cs35l56->base.reset_gpio = devm_gpiod_get_index_optional(cs35l56->base.dev,
@@ -1254,7 +1256,6 @@ void cs35l56_hda_remove(struct device *dev)
 
 	cs_dsp_remove(&cs35l56->cs_dsp);
 
-	kfree(cs35l56->system_name);
 	pm_runtime_put_noidle(cs35l56->base.dev);
 
 	gpiod_set_value_cansleep(cs35l56->base.reset_gpio, 0);
-- 
2.53.0



