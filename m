Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FFA14EC58;
	Tue, 23 Jul 2024 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759995; cv=none; b=G0/UTh9jFjl567El5/Emlw1l7kW9fEDSXCDYTABx9nVloubtFrlojWtiDY+bB1FknBzSPmkyLL5QUgwN5Ie+4mipuman3N7Nfa0O4wVvUt3dibd4BrO3tb0iZCD0MmcMpL5psLo8RDbRm3dW1o4CzE4x3aAiGWQFxAE9alNCX7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759995; c=relaxed/simple;
	bh=O62zmvb8+rJkeLa5jUterfr7QonZ6LarYTvltJaBQ8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QT6arXjqiYalImmR51aaMYi66cC0WvedEgafr4Bn110PU1b057C+m/QKs8xBkdx7ZIAosXdbhgYuKTafFgNwo7IA3h3BVlV1FccBPzitK9ijhTE/DhFFPWWjINR8JpEhRIgAFbDxL0WO9QXyJsY1hoGxgjyKwIfB4pJEhhkbnj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7Z9/O7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7Z9/O7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DF9C4AF0A;
	Tue, 23 Jul 2024 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759994;
	bh=O62zmvb8+rJkeLa5jUterfr7QonZ6LarYTvltJaBQ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7Z9/O7TEx5ktAXY+iXo15hnSA9RsWSryws7ZbPNUGwF3Y/c4PGQkv6xP9WjndKri
	 QVGNXlp9w0T+mM6/obgu5OiHsm1ONYJl2ZHRHTnN54P8VA8hdhoNmDsHN2oZXOgo3M
	 FW+U5928s4S417wfNsJU7lptMwWlNZ1kQ34ODtGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 066/163] ALSA: hda: cs35l56: Fix lifecycle of codec pointer
Date: Tue, 23 Jul 2024 20:23:15 +0200
Message-ID: <20240723180146.021934297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

[ Upstream commit d339131bf02d4ed918415574082caf5e8af6e664 ]

The codec should be cleared when the amp driver is unbound and when
resuming it should be tested to prevent loading firmware into the device
and ALSA in a partially configured system state.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20240531112716.25323-1-simont@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 6b77c38a0e155..e134ede6c5aa5 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -735,6 +735,8 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	if (comps[cs35l56->index].dev == dev)
 		memset(&comps[cs35l56->index], 0, sizeof(*comps));
 
+	cs35l56->codec = NULL;
+
 	dev_dbg(cs35l56->base.dev, "Unbound\n");
 }
 
@@ -840,6 +842,9 @@ static int cs35l56_hda_system_resume(struct device *dev)
 
 	cs35l56->suspended = false;
 
+	if (!cs35l56->codec)
+		return 0;
+
 	ret = cs35l56_is_fw_reload_needed(&cs35l56->base);
 	dev_dbg(cs35l56->base.dev, "fw_reload_needed: %d\n", ret);
 	if (ret > 0) {
-- 
2.43.0



