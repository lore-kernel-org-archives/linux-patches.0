Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5442040B119;
	Tue, 21 Jul 2026 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649752; cv=none; b=IbG9PTdfAGV2hmlfNBlKlTCf0RQ/Arl9C5DBkDMLXDl5T7YIc6PCoVGqj+gTf+G48jaSORnTWq95nnXI0G+shQ8RywPHbUXqKnHz8eF2xDRQgTi0R83UyMI8ygp3Bf9VtsfjbtFiuhBk7idqNpKY1M1FtAP+07HfPyVnxC53k2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649752; c=relaxed/simple;
	bh=e0d+yGf3nkX/CxTJmxZuYJez7gJkgtIpqFeYMvB/kxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOmmG5I7pJ32abdH/+tvgO9MkxAjgCm6+2ait1S9Oz4Mh69J1KMm9AmeJNhq8dz0S8SmxSyrTX9F8CzncAjNCCp7pRZOAbdcAVt7/n5e9CfIuj1CVOMLK1E76qrKio+dKeLm+eMxT1ChKmqDC76KXlGmI7tl+GLmqctxUZnAn2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFB+b/bN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFB+b/bN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669981F000E9;
	Tue, 21 Jul 2026 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649750;
	bh=LPt5LFL3xaqN/CegsMRYmHZcrCygaZkNyBFKH4e5ZFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFB+b/bNOryuCdW8XBy3JrlD5/p0Vz9UKGZW1ASrl2ERPznaU2oG0ebmafuce6fYE
	 QCYyZMvPZ96ZyMROMqZF3SN0nqlhjyy0ITe8QsrW6f9tw51Y510YcPuOYbeLGZyVEt
	 rjJvLa8TFo6TX77UXARvWL4o45jqPGig0XcJ0t9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko@sashiko.dev>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0640/2077] ASoC: cs35l56: Prevent double-free of debugfs
Date: Tue, 21 Jul 2026 17:05:13 +0200
Message-ID: <20260721152607.904601539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 344a12ca7ba6e10f9779476780afe9d977d47322 ]

Invalidate the debugfs pointer after debugfs_remove_recursive() in
cs35l56_remove_cal_debugfs(). This prevents a double-free situation when
a future commit adds proper failure cleanup in cs35l56_component_probe().

As described by Sashiko (including the future cs35l56_component_probe()
cleanup commit):

During a normal component unbind, cs35l56_component_remove() calls
cs35l56_remove_cal_debugfs() which removes the directory but leaves
a dangling pointer.

If the component is later bound again, but _cs35l56_component_probe()
fails early (for example, if the init_completion times out), this new
error path will call cs35l56_component_remove(). This causes
cs35l56_remove_cal_debugfs() to be called again with the dangling
cs35l56_base->debugfs pointer from the previous lifecycle, resulting in
a use-after-free in debugfs_remove_recursive().

Fixes: f7097161e94c ("ASoC: cs35l56: Add common code for factory calibration")
Reported-by: sashiko <sashiko@sashiko.dev>
Link: https://sashiko.dev/#/patchset/20260609120738.284770-1-rf%40opensource.cirrus.com
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260610093432.557375-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 795e2764d67ec8..e04b114a32b7f2 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -1293,6 +1293,7 @@ EXPORT_SYMBOL_NS_GPL(cs35l56_create_cal_debugfs, "SND_SOC_CS35L56_SHARED");
 void cs35l56_remove_cal_debugfs(struct cs35l56_base *cs35l56_base)
 {
 	debugfs_remove_recursive(cs35l56_base->debugfs);
+	cs35l56_base->debugfs = ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL_NS_GPL(cs35l56_remove_cal_debugfs, "SND_SOC_CS35L56_SHARED");
 
-- 
2.53.0



