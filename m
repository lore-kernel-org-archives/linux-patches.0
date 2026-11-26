Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704787;
	b=NZATs95ScftOIB7ME9hrLwkyM6Hg/pJG9Oet4EFZR8HWAQOqt0aoXLBrBAgy3JufT23T
	 vtZqQBq0Oww81gSLZK0BjEJxDullX9trt9jj0W5TJg+chDgsK+hPcb5UMVoieZ7O5koUS
	 aHF1bm2dQUK3jCRsitJcar8PecX7ri9pA2r5ccl8iCZPz2PfdI8hMGZBbc+j6u4FUXROy
	 fhmol/u20HEtnHKoWqUlMvRSIw4Jac0U3CkYsvY3i6INdr7rmkjQfY8tKgqflbEULt1Rm
	 GlsdTdjKFWt8yhefxrBVq3SwlPQXYzKmPBwKlQ6iJ1qntXLlqGZ3UStFL9zfskfljIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T6JCWqvQXcw+uL6dSzt9iC26QGint5c3nH70vXxumOU=;
	b=R2EgTb5yLxqs3Ex2Tkilki3x5qVMdn3Hx2h+L8KgLZDJrE0FBr9Bi+pIFaA0ThEdgdho
	 2yCpnhtAR6+ySwwDz5OvIqK1gjDXDsOa3KLxSHMnQPMqJOgAJxMHBiFUT6UDQYNw4Zdr6
	 V8SZJiT5bEcXBd/jccYWIzacR/I29PyMonHN+zuuAz4UogrxLyquE8XAVNeG0IXMkWfnf
	 rgn0/tBVqWCgkwSl942zmFg2olSms5cAwIdrcJEQStUxiTSA3OAiX5C4EUaqL5V+KGUfF
	 vhqRCNdq04JtOzJ7Z+p3U6plBrJCMzcpw+rDS2gIAsL3Xh1vCmP0G5xZgCpONXQ4XqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+ODnmkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0B3606A69E;
	Thu, 26 Nov 2026 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+ODnmkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03C51F000CA;
	Thu, 26 Nov 2026 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704787;
	bh=T6JCWqvQXcw+uL6dSzt9iC26QGint5c3nH70vXxumOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+ODnmkcHJ/TUyQir+wzCFbuNaGK/UT20V3cQyT74+fzIeFhJWmd8TCihs4DTaCoC
	 zkv6wTTNadgVZW82PCBSKmQghJNghwo+cXoZ30uwRmHbjMdffkA6hA4C1LT+U+L7x0
	 VE5Q9uYZttK2fMe/SWcS8z6I9jmBFDpj2XClccfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 189/265] wifi: cfg80211: release rejected nontransmitted BSS reference
Date: Thu, 26 Nov 2026 15:38:39 +0100
Message-ID: <20261126143618.415190150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2104,6 +2104,7 @@ cfg80211_inform_single_bss_data(struct w
 					       &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				bss_ref_put(rdev, res);
 				res = NULL;
 			}
 		}


