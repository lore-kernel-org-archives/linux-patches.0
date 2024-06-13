Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2581143884;
	Thu, 13 Jun 2024 11:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279971; cv=none; b=mVMZUTwm9dbGCLdIGawiiSeQybKZRXilRr/wlSYmR2w7EOrUmYnXXufgL0M8TZOVdnxUHJKlX5Io2mUMwhpqvEBUybZ1gsfyZhldYeoH8HXYr2srLCIK+bggrGw5qAj6Q0JPpNgegl+yuVyaut361e9s5asYRhCbgYu5l24x0rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279971; c=relaxed/simple;
	bh=IIs9XRDvhV/ORB99K/sNCcFRN5ciba9cr30us46JC98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daPXiKXvcQOeT4dgXDcRDpthWEl78E/vJ5ws3Ys0ijkq/Fyk8BsjyOfpJUXe8xWLkZvOXKlcOvejUilw/PMFAGucALgyok//AwNwARIHsNPd3n6B7jsVFs6oGwqeY43fH/jwIo/f9V3LB3eHNX/K5M7LWxA8iz8PkE8u4R6C9SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8CxsXyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8CxsXyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68810C2BBFC;
	Thu, 13 Jun 2024 11:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279970;
	bh=IIs9XRDvhV/ORB99K/sNCcFRN5ciba9cr30us46JC98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8CxsXyBih269JHh+e3DkJccjqqEaFwrF8fivB2MD5/c/xKHhackV22Z30A6hM8s2
	 G5oSM5xD2snqbFA413puqVJlhwQJagaSss92GR9gXPGlZcejKZqBMrxt95WIbRo5BG
	 1mWO83vHYTCw4LOWXBJLmomxUR93nEzE35LSMZwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/202] soundwire: cadence_master: improve PDI allocation
Date: Thu, 13 Jun 2024 13:33:17 +0200
Message-ID: <20240613113231.585786612@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 1b53385e7938d5a093e92044f9c89e4e76106f1b ]

PDI number should match dai->id, there is no need to track if a PDI is
allocated or not.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190916192348.467-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8ee1b439b154 ("soundwire: cadence: fix invalid PDI offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 27 ++++++++++++++-------------
 drivers/soundwire/cadence_master.h |  4 +---
 drivers/soundwire/intel.c          |  5 ++---
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 95dcdac008bb0..e589aa99e4292 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -845,7 +845,6 @@ static int cdns_allocate_pdi(struct sdw_cdns *cdns,
 
 	for (i = 0; i < num; i++) {
 		pdi[i].num = i + pdi_offset;
-		pdi[i].assigned = false;
 	}
 
 	*stream = pdi;
@@ -1198,21 +1197,20 @@ EXPORT_SYMBOL(cdns_set_sdw_stream);
  * @num: Number of PDIs
  * @pdi: PDI instances
  *
- * Find and return a free PDI for a given PDI array
+ * Find a PDI for a given PDI array. The PDI num and dai_id are
+ * expected to match, return NULL otherwise.
  */
 static struct sdw_cdns_pdi *cdns_find_pdi(struct sdw_cdns *cdns,
 					  unsigned int offset,
 					  unsigned int num,
-					  struct sdw_cdns_pdi *pdi)
+					  struct sdw_cdns_pdi *pdi,
+					  int dai_id)
 {
 	int i;
 
-	for (i = offset; i < num; i++) {
-		if (pdi[i].assigned)
-			continue;
-		pdi[i].assigned = true;
-		return &pdi[i];
-	}
+	for (i = offset; i < offset + num; i++)
+		if (pdi[i].num == dai_id)
+			return &pdi[i];
 
 	return NULL;
 }
@@ -1252,18 +1250,21 @@ EXPORT_SYMBOL(sdw_cdns_config_stream);
  */
 struct sdw_cdns_pdi *sdw_cdns_alloc_pdi(struct sdw_cdns *cdns,
 					struct sdw_cdns_streams *stream,
-					u32 ch, u32 dir)
+					u32 ch, u32 dir, int dai_id)
 {
 	struct sdw_cdns_pdi *pdi = NULL;
 
 	if (dir == SDW_DATA_DIR_RX)
-		pdi = cdns_find_pdi(cdns, 0, stream->num_in, stream->in);
+		pdi = cdns_find_pdi(cdns, 0, stream->num_in, stream->in,
+				    dai_id);
 	else
-		pdi = cdns_find_pdi(cdns, 0, stream->num_out, stream->out);
+		pdi = cdns_find_pdi(cdns, 0, stream->num_out, stream->out,
+				    dai_id);
 
 	/* check if we found a PDI, else find in bi-directional */
 	if (!pdi)
-		pdi = cdns_find_pdi(cdns, 2, stream->num_bd, stream->bd);
+		pdi = cdns_find_pdi(cdns, 2, stream->num_bd, stream->bd,
+				    dai_id);
 
 	if (pdi) {
 		pdi->l_ch_num = 0;
diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index 3e963614a216b..6199e71edeab7 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -8,7 +8,6 @@
 /**
  * struct sdw_cdns_pdi: PDI (Physical Data Interface) instance
  *
- * @assigned: pdi assigned
  * @num: pdi number
  * @intel_alh_id: link identifier
  * @l_ch_num: low channel for PDI
@@ -18,7 +17,6 @@
  * @type: stream type, PDM or PCM
  */
 struct sdw_cdns_pdi {
-	bool assigned;
 	int num;
 	int intel_alh_id;
 	int l_ch_num;
@@ -155,7 +153,7 @@ int sdw_cdns_get_stream(struct sdw_cdns *cdns,
 			u32 ch, u32 dir);
 struct sdw_cdns_pdi *sdw_cdns_alloc_pdi(struct sdw_cdns *cdns,
 					struct sdw_cdns_streams *stream,
-					u32 ch, u32 dir);
+					u32 ch, u32 dir, int dai_id);
 void sdw_cdns_config_stream(struct sdw_cdns *cdns,
 			    u32 ch, u32 dir, struct sdw_cdns_pdi *pdi);
 
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 9ac45e6dbe9df..7470adfaabf37 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -636,11 +636,10 @@ static int intel_hw_params(struct snd_pcm_substream *substream,
 	if (dma->stream_type == SDW_STREAM_PDM)
 		pcm = false;
 
-	/* FIXME: We would need to get PDI info from topology */
 	if (pcm)
-		pdi = sdw_cdns_alloc_pdi(cdns, &cdns->pcm, ch, dir);
+		pdi = sdw_cdns_alloc_pdi(cdns, &cdns->pcm, ch, dir, dai->id);
 	else
-		pdi = sdw_cdns_alloc_pdi(cdns, &cdns->pdm, ch, dir);
+		pdi = sdw_cdns_alloc_pdi(cdns, &cdns->pdm, ch, dir, dai->id);
 
 	if (!pdi) {
 		ret = -EINVAL;
-- 
2.43.0



