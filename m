Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026499;
	b=0gjbmc6EyfZey0SrpdHucaoirNIoih+7EydGZNTSXU9wGf5bfwgosk1Uhhh6H7WcGwaU
	 AsV5p3lBmgnCOsfxQzdeFkLb7wZ2GWPejML3LSUrYzUiAc+4md4fIeL3MUFPNxYNmP2c4
	 3/4NSmYkx3OoomGeHjtrms3shOVaujA949ZNxC4qiLluOurP7zakO4OTffofb3QVapogS
	 Oflw11orfKMnTMgxOjzEc2fcIvKWYZJzShg9yat9G8GG0VFc+Fhd5f3picFIdAcGNoMVx
	 h9TwS4KxuixyWq3Ppww8QyxBmyQhLnQ1rB+55NMikrymUXAolfgiiyTC1GWWSy47BWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/hVaZS5GYR1ehpNQMnkEZ7E8MofzTdom/+hqT0R6Gyk=;
	b=1/NnPij67v1HNUOxMMtSs8vzLenSvyziHxSCcPZ86OhVbQAe4ZRYgq/R3WzCQZbJUIGE
	 Ic6bWqBN1/ql6dkeoWCzm0daCwVn405VfzJWBfiQz5h8Ej356lrRCUlho1zMsVpH4dYjY
	 3LX0wXCjSNkGcDnOQLGmDd7MixGHfQVmLzg4dErvYC0UpowqIkSOCupDHwEnjzCZTZtH5
	 0ljS7s8lm5gvJ/kdlHoRMaxuyGhMN2g4BtZB80Y2558fEkt3WXLTfgkvB5hklC+R/424i
	 /SOYMD/hjzKrH9KFLoAwCagcjGODxMVF+nAawkhFN67UtZ2trnPCC2lJo49up7ZNTyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Be2t/kkj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366A4606A334;
	Wed, 18 Nov 2026 18:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Be2t/kkj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC7A1F000C4;
	Wed, 18 Nov 2026 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026499;
	bh=/hVaZS5GYR1ehpNQMnkEZ7E8MofzTdom/+hqT0R6Gyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Be2t/kkjIPoURKfWGjGLiLBwrjq2aIup/FXRILoJnX69SZy1+u2Zp4pyNelOv3HI1
	 OF6q8TeXLKKhWR40qGFLUeuTvKadzXISw+9/CqPDQ+mLYtgpLtVgTdoEgQUrvo1WdT
	 IxwjJOEAL9HBVXBdb7usGZwiRg7GNfoH8tg28yts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1456/2151] ASoC: Intel: atom: Use scoped_guard() for scoped locking
Date: Wed, 18 Nov 2026 15:53:11 +0100
Message-ID: <20261118150214.949873512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 08d2d5e683e85a7dc33c1abfd50fdc380bfafb5a ]

Clean up the code using scoped_guard() for mutex locks.
Merely code refactoring, and no behavior change.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260626082904.32344-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e3bb57581104 ("ASoC: intel: atom: Fix .shutdown() being skipped on rollback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-atom-controls.c     | 38 ++++++++++----------
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 20 ++++-------
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/sound/soc/intel/atom/sst-atom-controls.c b/sound/soc/intel/atom/sst-atom-controls.c
index 38116c7587174..ec1dd9aec2fa1 100644
--- a/sound/soc/intel/atom/sst-atom-controls.c
+++ b/sound/soc/intel/atom/sst-atom-controls.c
@@ -761,27 +761,29 @@ int sst_handle_vb_timer(struct snd_soc_dai *dai, bool enable)
 			return ret;
 	}
 
-	mutex_lock(&drv->lock);
-	if (enable)
-		timer_usage++;
-	else
-		timer_usage--;
-
-	/*
-	 * Send the command only if this call is the first enable or last
-	 * disable
-	 */
-	if ((enable && (timer_usage == 1)) ||
-	    (!enable && (timer_usage == 0))) {
-		ret = sst_fill_and_send_cmd_unlocked(drv, SST_IPC_IA_CMD,
-				SST_FLAG_BLOCKED, SST_TASK_SBA, 0, &cmd,
-				sizeof(cmd.header) + cmd.header.length);
-		if (ret && enable) {
+	scoped_guard(mutex, &drv->lock) {
+		if (enable)
+			timer_usage++;
+		else
 			timer_usage--;
-			enable  = false;
+
+		/*
+		 * Send the command only if this call is the first enable or last
+		 * disable
+		 */
+		if ((enable && timer_usage == 1) ||
+		    (!enable && timer_usage == 0)) {
+			ret = sst_fill_and_send_cmd_unlocked(drv, SST_IPC_IA_CMD,
+							     SST_FLAG_BLOCKED,
+							     SST_TASK_SBA, 0, &cmd,
+							     sizeof(cmd.header) +
+							     cmd.header.length);
+			if (ret && enable) {
+				timer_usage--;
+				enable  = false;
+			}
 		}
 	}
-	mutex_unlock(&drv->lock);
 
 	if (!enable)
 		sst->ops->power(sst->dev, false);
diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 516b480559026..2feb09f90f8e6 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -313,15 +313,14 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 	spin_lock_init(&stream->status_lock);
 
 	/* get the sst ops */
-	mutex_lock(&sst_lock);
-	if (!sst ||
-	    !try_module_get(sst->dev->driver->owner)) {
-		dev_err(dai->dev, "no device available to run\n");
-		ret_val = -ENODEV;
-		goto out_ops;
+	scoped_guard(mutex, &sst_lock) {
+		if (!sst ||
+		    !try_module_get(sst->dev->driver->owner)) {
+			dev_err(dai->dev, "no device available to run\n");
+			return -ENODEV;
+		}
+		stream->ops = sst->ops;
 	}
-	stream->ops = sst->ops;
-	mutex_unlock(&sst_lock);
 
 	stream->stream_info.str_id = 0;
 
@@ -356,11 +355,6 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	stream = NULL;
 
-	return ret_val;
-
-out_ops:
-	mutex_unlock(&sst_lock);
-
 	return ret_val;
 }
 
-- 
2.53.0



