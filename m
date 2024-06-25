Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F66F149DE9;
	Tue, 25 Jun 2024 09:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309039; cv=none; b=A7yZkKDTDo01w+WMGmtk5f9ajg+1+DaQM8BARVjxlLJTgyEygiv7nUTSXmJIi7GHbuGaWDa5EPrdVdaf8XSB4bZAe256KEqvdjdPKByWmtRnR4GDX54qe4F8wg46DiZNBsKAtcn2mQI3zJJU7uK+rcGVtT6GP7qZPjs08YcjsDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309039; c=relaxed/simple;
	bh=RenFB+JCfEO/wvO/Oopg6I/C9AG3JNYgRzF68ncY3FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOUFk5SYT2/jgORgO8I2mYCSqlFyFM8zX5hmvyiy0OigfbXByvl2uvAcMjLc+GOMUgdciKSKi7s/nzvaS4Nn/tjUw+m1NsYnDdOviQNWNt3gfbwRAv2CPr8lsbn6lQs874ZWGEAVy3q+0Cdn8sMwu7xP8CIckgj80xX/NeuVqo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pizvfaEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pizvfaEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB92DC32781;
	Tue, 25 Jun 2024 09:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309039;
	bh=RenFB+JCfEO/wvO/Oopg6I/C9AG3JNYgRzF68ncY3FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pizvfaEIGHnvjXkim9/jv0q2hztku6mvTA2z4eA65lNBmnFoXeyCAl0FrXdtx/CrP
	 QkXr3Izm2U792rc/f53ripAhhT1UyYUM9d9YSWUKQADZb5R4SzbIA7Pn7SrXm5P4gO
	 5PsCRmNP5YiUnijUEHqLzLnV/+zevpmCF0yU8qQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/192] ALSA: hda: cs35l56: Component should be unbound before deconstruction
Date: Tue, 25 Jun 2024 11:32:26 +0200
Message-ID: <20240625085540.017127413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 721f2e6653f5ab0cc52b3a459c4a2158b92fcf80 ]

The interface associated with the hda_component should be deactivated
before the driver is deconstructed during removal.

Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240613133713.75550-2-simont@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 15e20d9261393..78e2eeba49345 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -1021,12 +1021,12 @@ void cs35l56_hda_remove(struct device *dev)
 {
 	struct cs35l56_hda *cs35l56 = dev_get_drvdata(dev);
 
+	component_del(cs35l56->base.dev, &cs35l56_hda_comp_ops);
+
 	pm_runtime_dont_use_autosuspend(cs35l56->base.dev);
 	pm_runtime_get_sync(cs35l56->base.dev);
 	pm_runtime_disable(cs35l56->base.dev);
 
-	component_del(cs35l56->base.dev, &cs35l56_hda_comp_ops);
-
 	cs_dsp_remove(&cs35l56->cs_dsp);
 
 	kfree(cs35l56->system_name);
-- 
2.43.0



