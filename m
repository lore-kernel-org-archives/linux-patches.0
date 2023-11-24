Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C3139FC6;
	Fri, 24 Nov 2023 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgnNVL97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5732C433C7;
	Fri, 24 Nov 2023 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849259;
	bh=xfPWXGgWC6LeMAUH5afBrj+OTDXeY1LQu6IZChf2Mb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgnNVL97IELroSuPlYg6Usuutl+b4ZPllz42Aluw4P1rKAMeZ7pisy72DjNnfbvRM
	 Mcz9NKMYv12q4AaoAkEMgzsDJ5N7OI/PKImQWINDoT9s4BM6kTkYrwcZiX8MWaWZYx
	 Umz6cO7A2nuc8llzxQKkUdJeHg46yAXSiiVsnwUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/530] ASoC: cs35l56: Use PCI SSID as the firmware UID
Date: Fri, 24 Nov 2023 17:44:12 +0000
Message-ID: <20231124172030.699845115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 1a1c3d794ef65ef2978c5e65e1aed3fe6f014e90 ]

If the driver properties do not define a cirrus,firmware-uid try to get the
PCI SSID as the UID.

On PCI-based systems the PCI SSID is used to uniquely identify the specific
sound hardware. This is the standard mechanism for x86 systems and is the
way to get a unique system identifier for systems that use the CS35L56 on
SoundWire.

For non-SoundWire systems there is no Windows equivalent of the ASoC driver
in I2C/SPI mode. These would be:

1. HDA systems, which are handled by the HDA subsystem.
2. Linux-specific systems.
3. Composite devices where the cs35l56 is not present in ACPI and is
   configured using software nodes.

Case 2 can use the firmware-uid property, though the PCI SSID is supported
as an alternative, as it is the standard PCI mechanism.

Case 3 is a SoundWire system where some other codec is the SoundWire bridge
device and CS35L56 is not listed in ACPI. As these are SoundWire systems
they will normally use the PCI SSID.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230912163207.3498161-5-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index f9059780b7a7b..32d4ab2cd6724 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -772,9 +772,20 @@ static int cs35l56_component_probe(struct snd_soc_component *component)
 {
 	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(component);
 	struct dentry *debugfs_root = component->debugfs_root;
+	unsigned short vendor, device;
 
 	BUILD_BUG_ON(ARRAY_SIZE(cs35l56_tx_input_texts) != ARRAY_SIZE(cs35l56_tx_input_values));
 
+	if (!cs35l56->dsp.system_name &&
+	    (snd_soc_card_get_pci_ssid(component->card, &vendor, &device) == 0)) {
+		cs35l56->dsp.system_name = devm_kasprintf(cs35l56->base.dev,
+							  GFP_KERNEL,
+							  "%04x%04x",
+							  vendor, device);
+		if (!cs35l56->dsp.system_name)
+			return -ENOMEM;
+	}
+
 	if (!wait_for_completion_timeout(&cs35l56->init_completion,
 					 msecs_to_jiffies(5000))) {
 		dev_err(cs35l56->base.dev, "%s: init_completion timed out\n", __func__);
-- 
2.42.0



