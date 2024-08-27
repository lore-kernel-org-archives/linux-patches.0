Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7FF1BFE07;
	Tue, 27 Aug 2024 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772361; cv=none; b=P4WrSGpV7Wf3tnHPwvjeQ8+QLpfpypeNYnx6F9WnX9HQqy3T5UI1EF88ss7GWttlcr5fIJYtHyRSGAZUlpDByBQXJ/rTHolhWdhHKwaV6yGPiL/3H3g4s3m2hOlbYbfYhiCEzX9QbUEfSiWPFveVXhM4wsQmPOPaKgYKs1LPlyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772361; c=relaxed/simple;
	bh=1UQdwxUwk8KE3gCzZE2mt0N1cOKbUDuGcBMLvswWomw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xwbk+GdOcmP8A14rBWxVGjXHvsIKmqGn3DBtNYgtX6KscJleiLfm3YzPTQy3Rl8Mr/hPbYZ0q1u5mQ3AWEUbomV4JL8F8cImLOaX6KopdbBd2dZYuFeO0VRWC+61QhW/zmR8Cnp5E9qq2PygAD/OopMOPFiNVehkv16/tYXyj88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUf3Z/Fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUf3Z/Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADC5C61071;
	Tue, 27 Aug 2024 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772360;
	bh=1UQdwxUwk8KE3gCzZE2mt0N1cOKbUDuGcBMLvswWomw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUf3Z/FhZzKf15nf8ynVJQA7ADDQ8c1opJg8OPb9ltwL5X8gSDXCAUtpYJlohgxNs
	 aZFUpQ6FWkSoV4n/lGF1xZtGBLgL9dcGnZ5I0EEssaNul8TbcN/x4UHabAq3rz0pKG
	 jse65id28qop9Z1pZlVECb8MLtew/7pvrSMUA7dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/321] firmware: cirrus: cs_dsp: Initialize debugfs_root to invalid
Date: Tue, 27 Aug 2024 16:38:19 +0200
Message-ID: <20240827143845.502007635@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee4c32669607f..68005cce01360 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -490,7 +490,7 @@ void cs_dsp_cleanup_debugfs(struct cs_dsp *dsp)
 {
 	cs_dsp_debugfs_clear(dsp);
 	debugfs_remove_recursive(dsp->debugfs_root);
-	dsp->debugfs_root = NULL;
+	dsp->debugfs_root = ERR_PTR(-ENODEV);
 }
 EXPORT_SYMBOL_GPL(cs_dsp_cleanup_debugfs);
 #else
@@ -2300,6 +2300,11 @@ static int cs_dsp_common_init(struct cs_dsp *dsp)
 
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



