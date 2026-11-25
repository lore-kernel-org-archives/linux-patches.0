Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624828;
	b=3PhZej5xIgieyaVkASDd1X6Qiao3dZw83fdDR/l+1x+0XVHe/CskQFGkouvP2463LqNV
	 tkOTmVZZHGCGNMU8L9jtFBVKyHea0of8DfjlqADUXbDI4U/m0/Sm/K/JuLoMgMOy8opHG
	 hNYvpzvLZqzBZRZ+i2mZKzQae7pOKwc4u5LVBUYYhPqDUzoshxjQHQAohlsOyA1T1f2Uk
	 C+gYSprXUNit/no2OQM8s9aWwZCqkbeFcBwCmJKkoiyyQorkpMNCpni0QNIqJZ3fnF0F0
	 bs1oya/XsVQVBHL3guIhVaaL1sD6BvpxZ15nD2/yNWKKxyae8W6fHBpP7zn/xdU5M/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xx+QHzR/Vm8LKXIUuMIcF+CAee5PEOjOn5+gLLRbwsU=;
	b=tSlAgu6E6wwJ+vfwZbqDszQ09dZIoH27Mu5qYjMgUPh2n6qXMPjOfG0r5WBftQpp9PEf
	 +KXPyvytMyVmwJyBc1cJP4Tqm3zI/V+yTnierxsdWS5a1EdECtrOqhfUIuj5IA2PlVj8p
	 1WjMNqTXhoD2baGotKFryFcXQtuwbTMVvTKNnaMXe9V09yxEvDuxdc7/G6HhZxTrzwf7Z
	 nDRCt3Ik3+VGOQdLyaaM9iBKcVXfffgSxUkm4ys8eiHUL/17t/kVm39AnlEeu0LA7YUCw
	 Fs0A0Uy20EOXmCUBxvD7Mb26ea1QnOppyTc4TlyyBTvd5nCcGVDE4WduX4k5akDzj4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN8rXr7N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A277C606A687;
	Wed, 25 Nov 2026 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN8rXr7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62F1F00A19;
	Wed, 25 Nov 2026 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624828;
	bh=Xx+QHzR/Vm8LKXIUuMIcF+CAee5PEOjOn5+gLLRbwsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gN8rXr7NX3KYt1MmVg0VpJytLXymuvJW9SbzqiG+C0/bhV7TzDYM8dawEnRxHgF1u
	 FFhtyua0cHTvcS+2zlTQiZYzL2tzwhNtR5OMMlVBeWMjo/H+czN+Pae9nYOevMXwaD
	 CfUCWatevb2zDMOhhpkuTSG92j0/rKx5eD8Hj0jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/816] wifi: mac80211: abort chanswitch when leaving an IBSS
Date: Wed, 25 Nov 2026 15:31:06 +0100
Message-ID: <20261125143856.562244044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit 12f97c692dcbce088554a5530c79c55174ccee1a ]

ieee80211_ibss_disconnect() leaves CSA active, as ieee80211_stop_mesh()
did until commit ac7472a24bd4 ("wifi: mac80211: abort chanswitch when
leaving a mesh"). An IBSS left during its countdown and joined again
refuses every new channel switch with -EBUSY.

Abort the channel switch the same way.

Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-wireless/796598480d47c5bf474d11828769e864b8209558@linux.dev/
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20261025193615.1123718-1-mehmet.fide@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ibss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9df43cd76979e..96fad8c057e7c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -683,6 +683,10 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
 	netif_carrier_off(sdata->dev);
+
+	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_vif_unblock_queues_csa(sdata);
+
 	if (!sta_info_flush(sdata, -1))
 		synchronize_net();
 
-- 
2.53.0



