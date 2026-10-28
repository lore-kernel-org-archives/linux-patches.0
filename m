Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216725;
	b=EVZQgp9uhiuvzUKJ6IS4FSQOz3nWJbiB1sVFeCZsmLHjNLjR/Ipz+qon7/xeF9u3Lto4
	 Qj96rvLhYUGyFltLsCekn1hGS2TER5NfohdMLZPfWENayGsXB5qpCbFcbAFvhfHZTNdwA
	 LxrQU21LpXWUgUv8qAfmICUhHcHGo+1OzU2NcPBtyCCSjHoenqurI26LO74OoDWceTQqK
	 S3FGegrVeW4znQ52miF3TIGzAf5lbgZjfpLCtM0utwFqprjRWGjGfMoxHHjI8ftCWTjan
	 USjQedL/pTyUm2as3FBF7iQxqJiGt3erQ6OD3BAqF+FxB2YpguL4Yxig47jSMuVCrCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9hb+W9DT6g9bjjhobiR1NRcdUoktBuhWZ2ajuiUlyhA=;
	b=sgvAtasJDSDnbKWQEolmXICtFuoOhMOC2FLuznEYWc+WmcuqueRiPVKRIhW8ELpI3vk8
	 l06sNz7x9lJPJrJP1lZD/B+RSYBCwvv8EgkW25KgBdtbjOEbtbBx9XdssH9qIJeK5jZBQ
	 ray4WiYANQ61XbUnIaCBy2ocQcve6FJXzWlipepLz2OLrLIZiAYN2pFO29+yaUhP3Sj1p
	 7TCUfokQ2V8NwfSV6rvVhJpX5bwJGJ3KvYbeCzZbjsGXFSbyyBrD9rKGPFMDOMYDC8V4s
	 4HXEWzD4KeKW7wXD5D/rVq597+/i/wSYzDMnukhexf6k8TT9nylzMq+JbNwBWveKe2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l7/3XaoH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBD3606A31A;
	Wed, 28 Oct 2026 19:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7/3XaoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1A01F01825;
	Wed, 28 Oct 2026 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216725;
	bh=9hb+W9DT6g9bjjhobiR1NRcdUoktBuhWZ2ajuiUlyhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7/3XaoHp9WBxkhOy2WJm5O5E/LgQZuwYU0ngeSwqKwEt/UQk0PRM74Arkyq3j8R+
	 zVQtLbhiT2NU6M0q4AQLRO0D3H/V1sKeSqZ7pZUU4AOXzD51ySMyoIlqXDBsC7mYKQ
	 FUDSqgrIC4lVUgrUws6osmyrxEnu1dfrALkr1ygk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1658/1887] wifi: iwlwifi: mvm: fix a possible underflow
Date: Wed, 28 Oct 2026 18:02:34 +0100
Message-ID: <20261028170537.188301883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0cb5260a1027a43f8cdb961e128f2ddd42e46832 ]

We shouldn't trust the firmware about the length of the wowlan packet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.fbd989cc85e2.If68de403bfa4943732c025961154c20b01b09e83@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d7b2781a1eeaf..b28c9627d5b04 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1508,6 +1508,10 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 		if (WARN_ON_ONCE(truncated < 0))
 			truncated = 0;
 
+		/* this would be a firmware bug */
+		if (WARN_ON_ONCE(pktsize < sizeof(*hdr)))
+			return;
+
 		if (ieee80211_is_data(hdr->frame_control)) {
 			int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 			int ivlen = 0, icvlen = 4; /* also FCS */
@@ -1516,10 +1520,6 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 			if (!pkt)
 				goto report;
 
-			skb_put_data(pkt, pktdata, hdrlen);
-			pktdata += hdrlen;
-			pktsize -= hdrlen;
-
 			if (ieee80211_has_protected(hdr->frame_control)) {
 				/*
 				 * This is unlocked and using gtk_i(c)vlen,
@@ -1545,6 +1545,16 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 				truncated = 0;
 			}
 
+			if (pktsize <= hdrlen + ivlen + icvlen) {
+				IWL_WARN(mvm, "pktsize is too small %d\n",
+					 pktsize);
+				kfree_skb(pkt);
+				return;
+			}
+
+			skb_put_data(pkt, pktdata, hdrlen);
+			pktdata += hdrlen;
+			pktsize -= hdrlen;
 			pktsize -= ivlen + icvlen;
 			pktdata += ivlen;
 
-- 
2.53.0



