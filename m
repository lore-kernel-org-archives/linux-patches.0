Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4CC3B531D;
	Sat, 17 Oct 2026 17:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256680; cv=none; b=VvTo6GnLQcwd7JDcbIJp5TI71+i9DyBkvkXRqA9aKozRJWDcs/LHKXVr86Z3qYmCMOLFcV1FtBnhoSiRpnXqDQ6lfchZYwkKrSHxaJUel3cVijWI46dx7pigb3Erk8mPR4+kX4ECf8kcEfK8da/wv8Btir889cD/FMCKwTMngCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256680; c=relaxed/simple;
	bh=li4dYeca2YbEJHJlBApx2aSH8sescUHI9rxS/Q6Y9ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsxIuLP/SKUE8I7NFViV5l29Z/aMl+HIm4a2hZR3J4VzFrui93mmYMPiCPZ7fNZby7brY+4DKt2I2TJ5A6ubaTjMlCnYtQz5RKTfBPFAPuEesBwNajpZ0c9WS5XZRdBwYLPzDK8KQJZRVirT1Zz0sk5ByDrwm9QLIHTFgEsrg0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1zxKdBs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1zxKdBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF5F1F000C4;
	Sat, 17 Oct 2026 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256679;
	bh=WESae/6G8k58SYo4wg5lCTPyJX14Kp/7pW/wa5+qgIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1zxKdBszKxZpfg7WEth192VLC03toAZQ9OZbksAFrCiuyV/4cNC46CHx9Kfts2nS
	 fPBHvdyZY5m8uTRtzhzGDvJCiSx2nUBr0u5tr5z0+9L1EDWVxQJS3i67xIwWPEI58X
	 /L0u5PrGcrRh+wjYA6RQznKirDIaUMnZdaLvBVl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0316/1674] wifi: mac80211: minstrel_ht: validate fixed rate index
Date: Sat, 17 Oct 2026 17:43:08 +0200
Message-ID: <20261017160439.229567460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit 15fb9e3cea55fbc378261ce35a32b0f8828f0000 upstream.

The fixed_rate_idx debugfs file is a plain u32 attribute, so any value
can be written to it.  minstrel_ht_update_stats() then copies the value
into mi->max_tp_rate[] and mi->max_prob_rate, and
minstrel_ht_set_rate() uses MI_RATE_GROUP()/MI_RATE_IDX() to index
minstrel_mcs_groups[] (42 entries) and mi->groups[].rates[] (10 entries)
with it.

Writing e.g. 65535 selects group 4095 and rate index 15, far outside
both arrays.  The out-of-bounds entries are dereferenced and updated as
struct minstrel_rate_stats (retry counts, etc.), so the invalid index
corrupts adjacent kernel memory.  With CONFIG_UBSAN_BOUNDS the access is
reported as an array-index-out-of-bounds in minstrel_ht_set_rate().

Only a valid group/rate pair, or U32_MAX to disable fixed rate
processing, can be used safely, so reject any other value when the
debugfs file is written.

The file is only reachable through a root-only debugfs mount, so this is
not a privilege boundary.  The out-of-bounds access is still a bug that
must not be reachable through a writable debugfs attribute.

Fixes: 24f7580e852b ("minstrel_ht: fixed rate mode through debugfs")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/288e6f6d30dc82ff40da502755e6666982f6b735.1789798000.git.xuyuqiabc@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rc80211_minstrel_ht.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/skbuff.h>
 #include <linux/debugfs.h>
+#include <linux/limits.h>
 #include <linux/random.h>
 #include <linux/moduleparam.h>
 #include <linux/ieee80211.h>
@@ -1968,14 +1969,39 @@ minstrel_ht_alloc(struct ieee80211_hw *h
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
+static int minstrel_ht_fixed_rate_idx_get(void *data, u64 *val)
+{
+	*val = *(u32 *)data;
+	return 0;
+}
+
+static int minstrel_ht_fixed_rate_idx_set(void *data, u64 val)
+{
+	u32 idx = val;
+
+	/* U32_MAX is the default and keeps fixed rate processing disabled */
+	if (val != U32_MAX &&
+	    (val > U16_MAX ||
+	     MI_RATE_GROUP(idx) >= ARRAY_SIZE(minstrel_mcs_groups) ||
+	     MI_RATE_IDX(idx) >= MCS_GROUP_RATES))
+		return -EINVAL;
+
+	*(u32 *)data = idx;
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(minstrel_ht_fixed_rate_idx_fops,
+			 minstrel_ht_fixed_rate_idx_get,
+			 minstrel_ht_fixed_rate_idx_set, "%llu\n");
+
 static void minstrel_ht_add_debugfs(struct ieee80211_hw *hw, void *priv,
 				    struct dentry *debugfsdir)
 {
 	struct minstrel_priv *mp = priv;
 
 	mp->fixed_rate_idx = (u32) -1;
-	debugfs_create_u32("fixed_rate_idx", S_IRUGO | S_IWUGO, debugfsdir,
-			   &mp->fixed_rate_idx);
+	debugfs_create_file("fixed_rate_idx", S_IRUGO | S_IWUGO, debugfsdir,
+			    &mp->fixed_rate_idx, &minstrel_ht_fixed_rate_idx_fops);
 }
 #endif
 


