Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E9D13C90B;
	Tue, 25 Jun 2024 09:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308409; cv=none; b=odTO6RsHH45kwZCHLicLI6GV5shpr9kkoGs15Gqd3JpZb3/AxzY90LvXGigkkLlwywvHFHhzp9TM70vmcBIec1K8QiETS7eUbfYyORG28XEm2AwGaa7Te6P05DbISAXs1KOmJvZPHAgqwe37NMbG2CCN63Td6Trw2+fmZbC2QOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308409; c=relaxed/simple;
	bh=JVUTHU3ZhfiLDew1luEOWqndei+MANBZ9zaINe0p8/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr+cw++CoOxxXe0PLPb5nm5tIazNmdwx49f0KmQe8IYxTlbdi/X2V77Hu9qoCLXDOaOuC3kVF4W4zAaI3/JzCA+/ZDZPCiIx1Yx7tZh84aCfhqOHqHMQUAZvhJcNf26lspbXUp97vDF4YSJ3We/x5OuWNcC6/mPxGzaPH0Hc6K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMasKzH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMasKzH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DF3C32781;
	Tue, 25 Jun 2024 09:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308409;
	bh=JVUTHU3ZhfiLDew1luEOWqndei+MANBZ9zaINe0p8/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMasKzH6iBSmk8ZQwVBR/EqIJOnAF1gZcTX6NK4VfxhF16cxsKWr1w5dXlbvlBOaV
	 yCy2TcU0b9UbQPU4V3tq8Ln4wNI1rT1yYcmfmQ9rr/j0kNhr6qng3oDbt8M74XR0gI
	 vLT0b6Dm5Hd571kINGQq8irmMEMp2K94o8ejQNZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 112/250] ALSA: hda: cs35l41: Component should be unbound before deconstruction
Date: Tue, 25 Jun 2024 11:31:10 +0200
Message-ID: <20240625085552.371528259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 6f9a40d61cad0f5560e8530b4dd4a05fc4d15987 ]

The interface associated with the hda_component should be deactivated
before the driver is deconstructed during removal.

Fixes: 7b2f3eb492da ("ALSA: hda: cs35l41: Add support for CS35L41 in HDA systems")
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240613133713.75550-3-simont@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index 25cf072a2a10b..ec688c60c153b 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1857,6 +1857,8 @@ void cs35l41_hda_remove(struct device *dev)
 {
 	struct cs35l41_hda *cs35l41 = dev_get_drvdata(dev);
 
+	component_del(cs35l41->dev, &cs35l41_hda_comp_ops);
+
 	pm_runtime_get_sync(cs35l41->dev);
 	pm_runtime_dont_use_autosuspend(cs35l41->dev);
 	pm_runtime_disable(cs35l41->dev);
@@ -1864,8 +1866,6 @@ void cs35l41_hda_remove(struct device *dev)
 	if (cs35l41->halo_initialized)
 		cs35l41_remove_dsp(cs35l41);
 
-	component_del(cs35l41->dev, &cs35l41_hda_comp_ops);
-
 	acpi_dev_put(cs35l41->dacpi);
 
 	pm_runtime_put_noidle(cs35l41->dev);
-- 
2.43.0



