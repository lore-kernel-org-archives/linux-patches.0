Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626020;
	b=BSEoWChm1WFLMOcCH4nCDnWV6SJePMEMyuFCohCNXCVKipYpzR0vLfbjnKvUu6xVdKc9
	 YgLw3WbXjyL20ZzJ4E9GgwxU2d4DaB7kKTgsOw3keFFLlNGH5pCFE4tpCenRaL+YEDtgi
	 UulgL47M98Nth77w0E9E0z3OZMbk1rGyIcTsEgTDktiC9HjON/8IRg+H7gef74WQNH8ud
	 Un7HpnYl1FAysx5Id8/4CuyJuvcfgX1IZWymfaGrk3C4pFLN6gzWCr4bgMjMvWr+boOyI
	 Ssol3SCi5ri9jtfRJBBNjViOowyvxVENcielWp2ZqfTVHlJ2e2mNFBCx25NrXyJf2wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KFoqkv76TU11qKnOqbH3qQD5GlIXRVfrnKXOOVh0daA=;
	b=XgNRw6tYtolzOkTBZt84w6VmKLE8WNDTrgKcjk42L1rcJFjv97qmLeYnoNUwo6LcMFdU
	 yh0LnXeIjhFxoGej5u+ORfsQM3fEGyE0VP2djDTDn2wkHORj1K5/sT940NRdmbhpmdC/C
	 ZZzxBBnG82shhWKRw66UP9cTtBznZQuCgFc5xLIGJ8ZO5JqBMRmVdfSenBchsaCmqGquy
	 2WwMbxzb7LCehXxrKLwijae1UZ37q3TZ8ZnL64FhQ04cS4VyZ+4o6e+qJHk0Xe+rusa95
	 iqXQjmasB/vC+UQN6yFASXZ4XsoUrcJZSu+IAIMBYvxChrAvXss6eJA1Ffo1OoLgCqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUDjOEFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CEF606A321;
	Wed, 25 Nov 2026 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUDjOEFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CBF1F000C0;
	Wed, 25 Nov 2026 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626020;
	bh=KFoqkv76TU11qKnOqbH3qQD5GlIXRVfrnKXOOVh0daA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUDjOEFFZlVz4eyTK/8cnZAnYYNcUsmpU17pvrIQmiJ/+AN30Yx2gI4meyx7VX17h
	 luTSkMQH2zktvby0nB+FHxG/hD2x4bHh+GjfbIt6/KMOEPUx2vkOeedKhtwfxFbGF1
	 Xtr0GCNaMOF00Nnq7Vopusf/oZy8wfQTUurSd30c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 660/816] wifi: cfg80211: release rejected nontransmitted BSS reference
Date: Wed, 25 Nov 2026 15:36:48 +0100
Message-ID: <20261125143904.456568760@linuxfoundation.org>
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

commit f3c45d5b741a7d7586e639c2f55d2557029f2e1a upstream.

Repeated MBSSID reports without an SSID can leak BSS entries outside the
scan cache, where the BSS entry limit cannot account for them.

__cfg80211_bss_update() returns a referenced BSS. If adding it to the
transmitting BSS list fails, unlinking drops the cache reference, but the
caller reference is lost when res is cleared.

Release the caller reference before discarding the unlinked BSS.

LLM assistance was used to find the bug and review.

Fixes: 0b7808818cb9 ("wifi: cfg80211: fix BSS refcounting bugs")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028141731.6185-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2354,6 +2354,7 @@ cfg80211_inform_single_bss_data(struct w
 		if (cfg80211_add_nontrans_list(data->source_bss, &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				bss_ref_put(rdev, res);
 				res = NULL;
 			}
 		}


