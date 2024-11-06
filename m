Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5538D1F1303;
	Wed,  6 Nov 2024 12:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897595; cv=none; b=prk1owi87MK8epe2EqbHHJ4wzxYaPsTOXeoo/ucHO6N0eKBQCYXtbj9FJoFS7PLAiEYAcAdll5tN75RQnzDMd0EC/6rGF8ikdrvEhIzoIEfhuYPKUV0GCHOPyKZOWv2yq6gF9sv3K43WN5GUSljgfKvpr6Lncbyar0DaIGwZwfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897595; c=relaxed/simple;
	bh=7l3BuBgy3XZTn8+59Nnah4AsFxkLkUt/bBZ9+2QJjRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0b5uyhGhUhSFg/KFtGb1YnsO4/USuAM82s2q2NxlXs638aYX/ZIa5ZnoNMTcHzn+FqQuuPtBLrvsqE0Y1FaDGjv/5d26lrkPQuCrzy1457C5oMX4fsbpdUPruahln8OpTFqEMWjpzk5kkjab7Pk5sBCMRk5njfUC2I+jnQAOm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/mNjaFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/mNjaFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0762C4CECD;
	Wed,  6 Nov 2024 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897595;
	bh=7l3BuBgy3XZTn8+59Nnah4AsFxkLkUt/bBZ9+2QJjRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/mNjaFUq0gKtMBzr38E0qKNiwZeSOzxMmUTy9JLOa1KOtfx5fcQHTN/VYmwxmggx
	 2lKYGuo3PhwGiEihCJNo98H8AoQy0H36qrPtoY5RcwuTfjhsSLcLY6QUQrRkYQNyAA
	 MXp8qrnsPmgAN9fU2FBJbrgfJMrpM0i9WZ6q+YI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 105/151] thunderbolt: Honor TMU requirements in the domain when setting TMU mode
Date: Wed,  6 Nov 2024 13:04:53 +0100
Message-ID: <20241106120311.765116049@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

commit 3cea8af2d1a9ae5869b47c3dabe3b20f331f3bbd upstream.

Currently, when configuring TMU (Time Management Unit) mode of a given
router, we take into account only its own TMU requirements ignoring
other routers in the domain. This is problematic if the router we are
configuring has lower TMU requirements than what is already configured
in the domain.

In the scenario below, we have a host router with two USB4 ports: A and
B. Port A connected to device router #1 (which supports CL states) and
existing DisplayPort tunnel, thus, the TMU mode is HiFi uni-directional.

1. Initial topology

          [Host]
         A/
         /
 [Device #1]
   /
Monitor

2. Plug in device #2 (that supports CL states) to downstream port B of
   the host router

         [Host]
        A/    B\
        /       \
 [Device #1]    [Device #2]
   /
Monitor

The TMU mode on port B and port A will be configured to LowRes which is
not what we want and will cause monitor to start flickering.

To address this we first scan the domain and search for any router
configured to HiFi uni-directional mode, and if found, configure TMU
mode of the given router to HiFi uni-directional as well.

Cc: stable@vger.kernel.org
Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |   48 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -383,6 +383,24 @@ static void tb_increase_tmu_accuracy(str
 	device_for_each_child(&sw->dev, NULL, tb_increase_switch_tmu_accuracy);
 }
 
+static int tb_switch_tmu_hifi_uni_required(struct device *dev, void *not_used)
+{
+	struct tb_switch *sw = tb_to_switch(dev);
+
+	if (sw && tb_switch_tmu_is_enabled(sw) &&
+	    tb_switch_tmu_is_configured(sw, TB_SWITCH_TMU_MODE_HIFI_UNI))
+		return 1;
+
+	return device_for_each_child(dev, NULL,
+				     tb_switch_tmu_hifi_uni_required);
+}
+
+static bool tb_tmu_hifi_uni_required(struct tb *tb)
+{
+	return device_for_each_child(&tb->dev, NULL,
+				     tb_switch_tmu_hifi_uni_required) == 1;
+}
+
 static int tb_enable_tmu(struct tb_switch *sw)
 {
 	int ret;
@@ -397,12 +415,30 @@ static int tb_enable_tmu(struct tb_switc
 	ret = tb_switch_tmu_configure(sw,
 			TB_SWITCH_TMU_MODE_MEDRES_ENHANCED_UNI);
 	if (ret == -EOPNOTSUPP) {
-		if (tb_switch_clx_is_enabled(sw, TB_CL1))
-			ret = tb_switch_tmu_configure(sw,
-					TB_SWITCH_TMU_MODE_LOWRES);
-		else
-			ret = tb_switch_tmu_configure(sw,
-					TB_SWITCH_TMU_MODE_HIFI_BI);
+		if (tb_switch_clx_is_enabled(sw, TB_CL1)) {
+			/*
+			 * Figure out uni-directional HiFi TMU requirements
+			 * currently in the domain. If there are no
+			 * uni-directional HiFi requirements we can put the TMU
+			 * into LowRes mode.
+			 *
+			 * Deliberately skip bi-directional HiFi links
+			 * as these work independently of other links
+			 * (and they do not allow any CL states anyway).
+			 */
+			if (tb_tmu_hifi_uni_required(sw->tb))
+				ret = tb_switch_tmu_configure(sw,
+						TB_SWITCH_TMU_MODE_HIFI_UNI);
+			else
+				ret = tb_switch_tmu_configure(sw,
+						TB_SWITCH_TMU_MODE_LOWRES);
+		} else {
+			ret = tb_switch_tmu_configure(sw, TB_SWITCH_TMU_MODE_HIFI_BI);
+		}
+
+		/* If not supported, fallback to bi-directional HiFi */
+		if (ret == -EOPNOTSUPP)
+			ret = tb_switch_tmu_configure(sw, TB_SWITCH_TMU_MODE_HIFI_BI);
 	}
 	if (ret)
 		return ret;


