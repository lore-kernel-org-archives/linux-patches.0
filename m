Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65190253930;
	Tue, 29 Apr 2025 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949358; cv=none; b=DApFG51UMuQJu0sm8D4x7lOzft7RM3z4KhQPB/ZEGb5LpeLfdyv9BWw1Fyl6/9wRDrL/m7aJ7CXHijhPHZl9eY8AS3wmKw+00DheaZkgnSHanEyJKayi10H0SOhSpeMYL24X4bZi0g+nAgtMUJ/kQf4OKgMVyO8+HUbYy0y7E7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949358; c=relaxed/simple;
	bh=/D2t7jDMPb/Clgx16h4JcUkPqPYRiiX4012LrAwnBxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQraSBo1RTjC9LD/gNJv1r3dG61JEvycCoQOs43oQsqkripNjMWFi6IFKqFZ2Fczquk8lEGrQE3652Ii20rPe2NXMfeyzb7FSWa5KJD6gT9uEdKIwRk3XZJ5YCobhcGR0nrqo/5deuY4ovC5V5mdJ7GdLDOvJv+wkL6Oa/aeanM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8A9GNoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8A9GNoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B750C4CEE3;
	Tue, 29 Apr 2025 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949357;
	bh=/D2t7jDMPb/Clgx16h4JcUkPqPYRiiX4012LrAwnBxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8A9GNoyPuUNpjrtYuB8NmQaWtJ+k6006zeZekBVUbvWNLyoIB1XZnr63eOt3MqAK
	 rUZoIwZwBcEtgb9BslviMaKPBuEvv0w2ufVn92BlwkvsOdfN4d3xJcOpeT5q22ge/l
	 yfvyGZkhYOtubzToEi5LrKLbu250zV7zHrACCaNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/373] net: dsa: mt7530: sync driver-specific behavior of MT7531 variants
Date: Tue, 29 Apr 2025 18:42:51 +0200
Message-ID: <20250429161135.207985097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 497041d763016c2e8314d2f6a329a9b77c3797ca ]

MT7531 standalone and MMIO variants found in MT7988 and EN7581 share
most basic properties. Despite that, assisted_learning_on_cpu_port and
mtu_enforcement_ingress were only applied for MT7531 but not for MT7988
or EN7581, causing the expected issues on MMIO devices.

Apply both settings equally also for MT7988 and EN7581 by moving both
assignments form mt7531_setup() to mt7531_setup_common().

This fixes unwanted flooding of packets due to unknown unicast
during DA lookup, as well as issues with heterogenous MTU settings.

Fixes: 7f54cc9772ce ("net: dsa: mt7530: split-off common parts from mt7531_setup")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://patch.msgid.link/89ed7ec6d4fa0395ac53ad2809742bb1ce61ed12.1745290867.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 86db6a18c8377..abd61514d3361 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2534,6 +2534,9 @@ mt7531_setup_common(struct dsa_switch *ds)
 	struct mt7530_priv *priv = ds->priv;
 	int ret, i;
 
+	ds->assisted_learning_on_cpu_port = true;
+	ds->mtu_enforcement_ingress = true;
+
 	mt753x_trap_frames(priv);
 
 	/* Enable and reset MIB counters */
@@ -2673,9 +2676,6 @@ mt7531_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ds->assisted_learning_on_cpu_port = true;
-	ds->mtu_enforcement_ingress = true;
-
 	return 0;
 }
 
-- 
2.39.5



