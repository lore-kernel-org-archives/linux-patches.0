Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE20A1A4F12;
	Mon, 23 Jun 2025 22:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716348; cv=none; b=NafX1TYgPI3+LBnOCF0lVoh41n1M6rtwMCSxiFVVOOq/UAP7BPXB4eYLPxATr615NsGwwsThhd1WzLWJkEwLY8Q/HII3rZ5VKW9dX3WP1bFaZ/riZMf58IrD1mE7gCprH83y4WUX95e85vU+cLZhVl6qKqI1lKf/yIM9e2uxnFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716348; c=relaxed/simple;
	bh=pJ8WgIbtX2f4lbVy7oMOYFg8SdC8ra6BnnzQD3Hg+zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU7is/1pV2fmDRK4Hl3VJlgogWAGBHoUKZAnABkgJt6r51DJbSjl/98KESS+UPx0wNvUBWhDzJYn3PryWTsntFqy2MKihkINBNj4XWCZq4lDaEmhK1CFH33BwtWwWERi/mnt4f2qcPOKdDy5fm7QYlsNV2Vw60IJAHgUO2FZoZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcPKaQKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcPKaQKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88119C4CEEA;
	Mon, 23 Jun 2025 22:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716347;
	bh=pJ8WgIbtX2f4lbVy7oMOYFg8SdC8ra6BnnzQD3Hg+zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcPKaQKt1Nyd2+lIJcv48PGbkmRLlQ12MZStejNbmdtwfTU7i0HUjPKaAOGseTM1f
	 /eo7tHnibG3hGERKVgrZIj/wLuvSbEry4OIPi2PZdU1qQdKMmt5O8m5viSMbMhQUGM
	 6VuN17yjJ0GPVNmMSSmYAkPsrQqkv5QdpOL1ram0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Rouven Czerwinski <rouven@czerwinskis.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/411] wifi: mac80211: do not offer a mesh path if forwarding is disabled
Date: Mon, 23 Jun 2025 15:07:47 +0200
Message-ID: <20250623130641.768873661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Benjamin Berg <benjamin@sipsolutions.net>

[ Upstream commit cf1b684a06170d253b47d6a5287821de976435bd ]

When processing a PREQ the code would always check whether we have a
mesh path locally and reply accordingly. However, when forwarding is
disabled then we should not reply with this information as we will not
forward data packets down that path.

Move the check for dot11MeshForwarding up in the function and skip the
mesh path lookup in that case. In the else block, set forward to false
so that the rest of the function becomes a no-op and the
dot11MeshForwarding check does not need to be duplicated.

This explains an effect observed in the Freifunk community where mesh
forwarding is disabled. In that case a mesh with three STAs and only bad
links in between them, individual STAs would occionally have indirect
mpath entries. This should not have happened.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Reviewed-by: Rouven Czerwinski <rouven@czerwinskis.de>
Link: https://patch.msgid.link/20250430191042.3287004-1-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_hwmp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e6b6a7508ff1b..8bf238afb5442 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -620,7 +620,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				mesh_path_add_gate(mpath);
 		}
 		rcu_read_unlock();
-	} else {
+	} else if (ifmsh->mshcfg.dot11MeshForwarding) {
 		rcu_read_lock();
 		mpath = mesh_path_lookup(sdata, target_addr);
 		if (mpath) {
@@ -638,6 +638,8 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 		rcu_read_unlock();
+	} else {
+		forward = false;
 	}
 
 	if (reply) {
@@ -655,7 +657,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (forward && ifmsh->mshcfg.dot11MeshForwarding) {
+	if (forward) {
 		u32 preq_id;
 		u8 hopcount;
 
-- 
2.39.5



