Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626032;
	b=A4wOnryqo9wk3foPjtEgAQ1IuEFPT1Cp5ghz5utnjhe5hr8HtQOX1kfHjGUcB3u9JZLh
	 9575UxpzliKJqaJDBiryvZ0KQq5pVMSbk7uMunnXocdo1/Ko6ooaw4RCDm7BxzCAuXqO5
	 InLxyv4IIfTRsvfBs2RM7LWc2w5bfgv+l6/M4GVUQEL+5U1NoWkYQ0skMsYnbhZbVLy9I
	 I2EDyikPicGl3BOh1SRFGi08zyIG3dD9EvxB0nCBOuSvvS2atOxFg7+l1jrcAS6BrUy1i
	 pgNba+1IPeYVpqrbk0NCSwav4dbEymuQjH7n5pWZbxeR5IZCfZGUacdLhTfMn9sjbWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8+KiR38dxxUdh6krx8yS562E6NBNgtjEV/hT/B+JS4M=;
	b=L09xXUU6J1G/I0lUGoaf0syVG9GDUWPXvGmv0tnZU0j6aY7U9GkJ6J6ky9HDcjcyetpu
	 d8I3X2kKJ/2PMrEUNXeqgGLweewxApK9OHeICO0V4JOSCNVUf+euV3G9g6FW8A+l8AYpU
	 fcxMQ3k5HTSj0IXDwpofvjno/12Nw2htfkNKxmeULtDf8+SxgmvXa2u1NUGA3Wnn6Otfk
	 MOXUmRpJu2vlWY3XQ9Ga2OWHSrgAZ2yFSDSlCdyuxBj6A0Wdp3MF40Y0ixkVPu+IoQs98
	 4aQGYm+SItmia45Mu2U9qd8yROXFGE08GywrtAlYZp3AgEhkg4eYwIXkPK+cwEuTNxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrTxVn9J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8AA606A321;
	Wed, 25 Nov 2026 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrTxVn9J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3301F000C0;
	Wed, 25 Nov 2026 17:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626031;
	bh=8+KiR38dxxUdh6krx8yS562E6NBNgtjEV/hT/B+JS4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrTxVn9JxuWmTb3IAUoyFySPss9Swv2nJKjyiFU8SOJDl1RF3GYsGXNyFDIitV/go
	 qTjNMCslskZEPmVhlCWEM7CE+Hypr4hF6sEJh+HldRqByAiqRnMACRq+TY1+n+/FBh
	 uNVnLqy/s8SsC1vpnP5AMCYfmJjyez9/KZ972zjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 664/816] wifi: mac80211: drain link readers before stopping removed links
Date: Wed, 25 Nov 2026 15:36:52 +0100
Message-ID: <20261125143904.548740315@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 745f5d04395dfc4c311f443c7c04ccb00c436984 upstream.

Removing an MLO link can leave work queued on its link container after
the container is freed.

ieee80211_tear_down_links() stops each link before the RCU grace period.
A reader that fetched the link earlier can therefore queue work after
ieee80211_link_stop() has canceled it. ieee80211_request_smps() and
ieee80211_csa_finish() can both reach this window.

Record each removed link while removing its keys and debugfs state. Wait
for RCU readers, then stop the recorded links so cancellation includes
work queued by those readers. Free the detached keys after the grace
period as before.

LLM assistance was used to find the bug and review.

Fixes: efe9c2bfd1a8 ("wifi: mac80211: isolate driver from inactive links")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028141708.5532-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/link.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -176,6 +176,7 @@ struct link_container {
 static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 				      struct link_container **links, u16 mask)
 {
+	struct ieee80211_link_data *stop[IEEE80211_MLD_MAX_NUM_LINKS] = {};
 	struct ieee80211_link_data *link;
 	LIST_HEAD(keys);
 	unsigned int link_id;
@@ -190,11 +191,16 @@ static void ieee80211_tear_down_links(st
 			continue;
 		ieee80211_remove_link_keys(link, &keys);
 		ieee80211_link_debugfs_remove(link);
-		ieee80211_link_stop(link);
+		stop[link_id] = link;
 	}
 
+	/* drain RCU readers before cancelling work they may queue */
 	synchronize_rcu();
 
+	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++)
+		if (stop[link_id])
+			ieee80211_link_stop(stop[link_id]);
+
 	ieee80211_free_key_list(sdata->local, &keys);
 }
 


