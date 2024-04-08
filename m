Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4062DF73;
	Mon,  8 Apr 2024 13:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581709; cv=none; b=gHmn5kCte12CqvXYujbTW3sB6lRzsCZQBtZ1MnYbMfGJMvO4tTEjAlFtPqJVxoXE3pT/NqezfO5S4DarNYQGCwqrOE9PkBM4HOfjDkyCquu/tn8Tb0o3rTkrjdaAMVs5UT/Rn6L2OsAHHMSRDStPlbVMThsQklDTwI2hqi5GsxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581709; c=relaxed/simple;
	bh=/v6xcaatby8wpjpO1f3b5BYTDkMqHUs+cmVmmG3AzRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msi4BzwjFAokSpf41nHR+PgsPk+LAe14trEAECcL/Hvd0gBWv2BbzzbhXVWtYm2L3pVRdhDCHOTZagVe96BssudFZG7J/Kc3ZdT8Ba9a36p5ZXRoHN4hKEL0+FJwguJqxlgo2v+OmqfntJe0S467ouZga7dlLLg6NL1qAjSqDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FM9+BUX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FM9+BUX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE4CC43390;
	Mon,  8 Apr 2024 13:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581709;
	bh=/v6xcaatby8wpjpO1f3b5BYTDkMqHUs+cmVmmG3AzRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM9+BUX6ySiSdM72QJCfTQqyp/DYFC86z05YaTGclEszp4cTIDDxBOIJBkKE4Mw8/
	 uO2OzeUvqkbC71PkxGdrdOHjcfh1G/Z8lnptJKn6rvMk1ksgm4VlFO03eyafd9r8Sq
	 a5u8EEkaWJmwT87zvD+5fYxB2L214tFeMenFanNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 014/273] ALSA: hda: cs35l56: Set the init_done flag before component_add()
Date: Mon,  8 Apr 2024 14:54:49 +0200
Message-ID: <20240408125309.728109990@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit cafe9c6a72cf1ffe96d2561d988a141cb5c093db ]

Initialization is completed before adding the component as that can
start the process of the device binding and trigger actions that check
init_done.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Message-ID: <20240325145510.328378-1-rf@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 75a14ba54fcd1..43a445bd961fb 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -1017,14 +1017,14 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int id)
 	pm_runtime_mark_last_busy(cs35l56->base.dev);
 	pm_runtime_enable(cs35l56->base.dev);
 
+	cs35l56->base.init_done = true;
+
 	ret = component_add(cs35l56->base.dev, &cs35l56_hda_comp_ops);
 	if (ret) {
 		dev_err(cs35l56->base.dev, "Register component failed: %d\n", ret);
 		goto pm_err;
 	}
 
-	cs35l56->base.init_done = true;
-
 	return 0;
 
 pm_err:
-- 
2.43.0



