Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2BB1C578E;
	Tue, 27 Aug 2024 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770332; cv=none; b=gXfKkNYZ/Ogk+DWIk6Qb1whaurYlAoG/lOXu20xu4D8FjqrR88PEb22+dfEA1rEDa1wc+Sfir0DKOSHyA7fbdEqkH5l03s4yPFZpx46S67FN0drF9hfpPDmGKoCWM7s4RA7H0LHvz+EeI2BVZEsNBRNKwc68NtLkp7I5f/aFF6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770332; c=relaxed/simple;
	bh=d1WmX66YuaZo4z6bj70Yse5gqcNUnrDhLWTlJFFR4fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH6MIwx3c9GklKjV2dQY4EvHhjjM9vnc2Z/JInSZblGDW63h0f6biUKwP+pZCuiLt7+jV0w/Gs7sZkHTYn6JZP7F20fEZrmLJ9AW6Sbinf0C+kL0PQPkQD6llHMkacS8Q2vs+TwyvN7evjYxQOi/stxbStM84FTkhiea3aP7R48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEFMHc68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEFMHc68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F021CC4E66E;
	Tue, 27 Aug 2024 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770332;
	bh=d1WmX66YuaZo4z6bj70Yse5gqcNUnrDhLWTlJFFR4fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEFMHc68Msxt15VNknXwcqrtBH27uxSehGXkJMO8tGntjD7w9wuL355bwccXC0iiG
	 CD/QesZ1tKgnrj0dEn/2hp6DRSqsr1OLEQJeAGqSvQQJUeuvutvTOx1p1NlqcDnqAv
	 bS0rWSRJpi6NSpEYdy2+IoIMgpDRnPwhFwMHWPKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/341] firmware: cirrus: cs_dsp: Initialize debugfs_root to invalid
Date: Tue, 27 Aug 2024 16:37:09 +0200
Message-ID: <20240827143850.947808327@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

[ Upstream commit 66626b15636b5f5cf3d7f6104799f77462748974 ]

Initialize debugfs_root to -ENODEV so that if the client never sets a
valid debugfs root the debugfs files will not be created.

A NULL pointer passed to any of the debugfs_create_*() functions means
"create in the root of debugfs". It doesn't mean "ignore".

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://msgid.link/r/20240307105353.40067-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index bd1651e709365..a1da7581adb03 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -522,7 +522,7 @@ void cs_dsp_cleanup_debugfs(struct cs_dsp *dsp)
 {
 	cs_dsp_debugfs_clear(dsp);
 	debugfs_remove_recursive(dsp->debugfs_root);
-	dsp->debugfs_root = NULL;
+	dsp->debugfs_root = ERR_PTR(-ENODEV);
 }
 EXPORT_SYMBOL_NS_GPL(cs_dsp_cleanup_debugfs, FW_CS_DSP);
 #else
@@ -2343,6 +2343,11 @@ static int cs_dsp_common_init(struct cs_dsp *dsp)
 
 	mutex_init(&dsp->pwr_lock);
 
+#ifdef CONFIG_DEBUG_FS
+	/* Ensure this is invalid if client never provides a debugfs root */
+	dsp->debugfs_root = ERR_PTR(-ENODEV);
+#endif
+
 	return 0;
 }
 
-- 
2.43.0



