Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E040714B080;
	Wed,  5 Feb 2025 13:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763833; cv=none; b=MNxKNkYGic3UAAHU1SH9SmDEMHkev4mz4UmDaOPSMFJcTOXVb3ivOU4trocyzC+qtiBIeJ2/MPbwTvh2diBCndZPrL2bslG1VRuRt2ncSCyTiWJ6+5r7KNat7Yfy7UExpbbIpm6vXPMIItuabSvSp4/6K31pUUXcJYMbNYARfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763833; c=relaxed/simple;
	bh=En40v7Ks7XHnPympzPUbpYmbGe9UTURiEdnrKgGQhgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyWdj/OZAG/yu2Ag2Z0jrBMTU5+v5Gtewhy94yTCWdvyQfq2tQdIj4ouLZKQrII/ZmunA4Layy4krWwLNL6NrHX6JaynjoNZtO55YhgSshi3KlRu2tncvJpfZJK04noDaatkUwpXNBZNVD6h4PCE9tsmVixgf4CStq+NWR3EgLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFvXb2PK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFvXb2PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9F3C4CEDD;
	Wed,  5 Feb 2025 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763832;
	bh=En40v7Ks7XHnPympzPUbpYmbGe9UTURiEdnrKgGQhgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFvXb2PKabeN1K4r3928ExwenBqEG5tIzqt0bcT3ETzkCv56p4+5sVfdYmtnlulDO
	 0Hx33f1edR6V/FGkY5CF1MVUP5ovmEMjj2/DivE4pebWJCP9V681JAf1VJungmy0Bb
	 WAY2EUczqOHEW7oE5isDdY4T1AnZdfSiGGhQ0uaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/590] drm/v3d: Fix performance counter source settings on V3D 7.x
Date: Wed,  5 Feb 2025 14:36:31 +0100
Message-ID: <20250205134456.632527799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit e987e22e9229d70c2083a91cc61269b2c4924955 ]

When the new register addresses were introduced for V3D 7.x, we added
new masks for performance counter sources on V3D 7.x.  Nevertheless,
we never apply these new masks when setting the sources.

Fix the performance counter source settings on V3D 7.x by introducing
a new macro, `V3D_SET_FIELD_VER`, which allows fields setting to vary
by version. Using this macro, we can provide different values for
source mask based on the V3D version, ensuring that sources are
correctly configure on V3D 7.x.

Fixes: 0ad5bc1ce463 ("drm/v3d: fix up register addresses for V3D 7.x")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241106121736.5707-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_debugfs.c |  4 ++--
 drivers/gpu/drm/v3d/v3d_perfmon.c | 15 ++++++++-------
 drivers/gpu/drm/v3d/v3d_regs.h    | 29 +++++++++++++++++------------
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_debugfs.c b/drivers/gpu/drm/v3d/v3d_debugfs.c
index 19e3ee7ac897f..76816f2551c10 100644
--- a/drivers/gpu/drm/v3d/v3d_debugfs.c
+++ b/drivers/gpu/drm/v3d/v3d_debugfs.c
@@ -237,8 +237,8 @@ static int v3d_measure_clock(struct seq_file *m, void *unused)
 	if (v3d->ver >= 40) {
 		int cycle_count_reg = V3D_PCTR_CYCLE_COUNT(v3d->ver);
 		V3D_CORE_WRITE(core, V3D_V4_PCTR_0_SRC_0_3,
-			       V3D_SET_FIELD(cycle_count_reg,
-					     V3D_PCTR_S0));
+			       V3D_SET_FIELD_VER(cycle_count_reg,
+						 V3D_PCTR_S0, v3d->ver));
 		V3D_CORE_WRITE(core, V3D_V4_PCTR_0_CLR, 1);
 		V3D_CORE_WRITE(core, V3D_V4_PCTR_0_EN, 1);
 	} else {
diff --git a/drivers/gpu/drm/v3d/v3d_perfmon.c b/drivers/gpu/drm/v3d/v3d_perfmon.c
index 6ee56cbd3f1bf..e3013ac3a5c2a 100644
--- a/drivers/gpu/drm/v3d/v3d_perfmon.c
+++ b/drivers/gpu/drm/v3d/v3d_perfmon.c
@@ -240,17 +240,18 @@ void v3d_perfmon_start(struct v3d_dev *v3d, struct v3d_perfmon *perfmon)
 
 	for (i = 0; i < ncounters; i++) {
 		u32 source = i / 4;
-		u32 channel = V3D_SET_FIELD(perfmon->counters[i], V3D_PCTR_S0);
+		u32 channel = V3D_SET_FIELD_VER(perfmon->counters[i], V3D_PCTR_S0,
+						v3d->ver);
 
 		i++;
-		channel |= V3D_SET_FIELD(i < ncounters ? perfmon->counters[i] : 0,
-					 V3D_PCTR_S1);
+		channel |= V3D_SET_FIELD_VER(i < ncounters ? perfmon->counters[i] : 0,
+					     V3D_PCTR_S1, v3d->ver);
 		i++;
-		channel |= V3D_SET_FIELD(i < ncounters ? perfmon->counters[i] : 0,
-					 V3D_PCTR_S2);
+		channel |= V3D_SET_FIELD_VER(i < ncounters ? perfmon->counters[i] : 0,
+					     V3D_PCTR_S2, v3d->ver);
 		i++;
-		channel |= V3D_SET_FIELD(i < ncounters ? perfmon->counters[i] : 0,
-					 V3D_PCTR_S3);
+		channel |= V3D_SET_FIELD_VER(i < ncounters ? perfmon->counters[i] : 0,
+					     V3D_PCTR_S3, v3d->ver);
 		V3D_CORE_WRITE(0, V3D_V4_PCTR_0_SRC_X(source), channel);
 	}
 
diff --git a/drivers/gpu/drm/v3d/v3d_regs.h b/drivers/gpu/drm/v3d/v3d_regs.h
index 1b1a62ad95852..6da3c69082bd6 100644
--- a/drivers/gpu/drm/v3d/v3d_regs.h
+++ b/drivers/gpu/drm/v3d/v3d_regs.h
@@ -15,6 +15,14 @@
 		fieldval & field##_MASK;				\
 	 })
 
+#define V3D_SET_FIELD_VER(value, field, ver)				\
+	({								\
+		typeof(ver) _ver = (ver);				\
+		u32 fieldval = (value) << field##_SHIFT(_ver);		\
+		WARN_ON((fieldval & ~field##_MASK(_ver)) != 0);		\
+		fieldval & field##_MASK(_ver);				\
+	 })
+
 #define V3D_GET_FIELD(word, field) (((word) & field##_MASK) >>		\
 				    field##_SHIFT)
 
@@ -354,18 +362,15 @@
 #define V3D_V4_PCTR_0_SRC_28_31                        0x0067c
 #define V3D_V4_PCTR_0_SRC_X(x)                         (V3D_V4_PCTR_0_SRC_0_3 + \
 							4 * (x))
-# define V3D_PCTR_S0_MASK                              V3D_MASK(6, 0)
-# define V3D_V7_PCTR_S0_MASK                           V3D_MASK(7, 0)
-# define V3D_PCTR_S0_SHIFT                             0
-# define V3D_PCTR_S1_MASK                              V3D_MASK(14, 8)
-# define V3D_V7_PCTR_S1_MASK                           V3D_MASK(15, 8)
-# define V3D_PCTR_S1_SHIFT                             8
-# define V3D_PCTR_S2_MASK                              V3D_MASK(22, 16)
-# define V3D_V7_PCTR_S2_MASK                           V3D_MASK(23, 16)
-# define V3D_PCTR_S2_SHIFT                             16
-# define V3D_PCTR_S3_MASK                              V3D_MASK(30, 24)
-# define V3D_V7_PCTR_S3_MASK                           V3D_MASK(31, 24)
-# define V3D_PCTR_S3_SHIFT                             24
+# define V3D_PCTR_S0_MASK(ver) (((ver) >= 71) ? V3D_MASK(7, 0) : V3D_MASK(6, 0))
+# define V3D_PCTR_S0_SHIFT(ver)                        0
+# define V3D_PCTR_S1_MASK(ver) (((ver) >= 71) ? V3D_MASK(15, 8) : V3D_MASK(14, 8))
+# define V3D_PCTR_S1_SHIFT(ver)                        8
+# define V3D_PCTR_S2_MASK(ver) (((ver) >= 71) ? V3D_MASK(23, 16) : V3D_MASK(22, 16))
+# define V3D_PCTR_S2_SHIFT(ver)                        16
+# define V3D_PCTR_S3_MASK(ver) (((ver) >= 71) ? V3D_MASK(31, 24) : V3D_MASK(30, 24))
+# define V3D_PCTR_S3_SHIFT(ver)                        24
+
 #define V3D_PCTR_CYCLE_COUNT(ver) ((ver >= 71) ? 0 : 32)
 
 /* Output values of the counters. */
-- 
2.39.5



