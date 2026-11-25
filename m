Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623307;
	b=gwGHarFw2T7tOtzpIa+ReOSycPPPp4v7ijNzLa23YYJEhYFTUsynGV12qxAVPZHsZTpW
	 2B73uwCC6fli2OiY+N2AU0v239ZC15FJShbMxK70uYGebPkQC3mXmBN/YGyDZz9qpozsl
	 SLE2+08L9Tz2uPBBwVoxeiY7oFR5qAad2Broonk6T3xBVOoMqvObZHYOsrZQgUNRLO3a8
	 j00CabzIyHhzhk2lUqn30IM86+X0zpT/K5qsvvHRnwiqI4NpkheMCZI0x62o51KgBLvqV
	 0QsJyOK98oHEnkHB7K9JAZraNQBZL0+7W9b5slRk6p9Su12Gn4vGYy2XvQlR85lFVlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SYtmeky/x3ToTVb5GaEKWBaT7956L+6tkdlapHN+6BI=;
	b=e4V/y990AJCUJUw6OBBEVrt0MOU8xR2StEYYBNFnZkhwjYLA4EmoENX/VWxPNH6uQaNr
	 DxSIIf+38j/4ydiUGBhgKoQeCkqKlmvSAVMcRYdCbww1ndNWw8Kq+9209RTPpxP3ffkDf
	 AX/4f4G/9w2dr0BMQU1dqK7DgrJJKupu4t3Ix7pl5JYLLxbT766/GREvh7EZoWOCPwjnH
	 Xx6Yj+fec/4wQSkBQQtexySVdkMCI3XDLVkMEY2pDmg9jg0KFrqDN/2uRNGJ8FJE9KKlp
	 37/ySMV7OF56s5ckACl/UU9NKEdw1944YII+YR+qdvIa6rkVm6QUJOmh8Z1fqcuYmkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VdRcdqry;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ADB606A326;
	Wed, 25 Nov 2026 16:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VdRcdqry
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C611F000C0;
	Wed, 25 Nov 2026 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623307;
	bh=SYtmeky/x3ToTVb5GaEKWBaT7956L+6tkdlapHN+6BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdRcdqryvf0nsyplGLEuZnrdw1ZEr1b3ONMH1o4NVPitUSsGJR2fjq0AlXKCRsKVb
	 I1mQooLDD8hOdcuaHL9aDcF1zoguyWD36I3OAhVFLjXNDm9G19hLzQiSTa5vg3KmZJ
	 wua8QOXSt1rYIV6o6KD/vz9iG8g9pamX2L2GlkBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 815/990] wifi: mac80211: drain link readers before stopping removed links
Date: Wed, 25 Nov 2026 15:36:22 +0100
Message-ID: <20261125143841.132709847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -179,6 +179,7 @@ struct link_container {
 static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 				      struct link_container **links, u16 mask)
 {
+	struct ieee80211_link_data *stop[IEEE80211_MLD_MAX_NUM_LINKS] = {};
 	struct ieee80211_link_data *link;
 	LIST_HEAD(keys);
 	unsigned int link_id;
@@ -193,11 +194,16 @@ static void ieee80211_tear_down_links(st
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
 


