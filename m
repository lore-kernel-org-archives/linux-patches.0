Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623292;
	b=HCHRr12G0HnYPJy29gpgWVoLhsSHoj3KU76/S/HcM240MY4P8xuiwf1kL2AHWWsNuLX7
	 yk/9sri/qI5GJHn6iSJEidQ+sSQhk7bUcGteobEuJBJPbc3ZS2ejpIkbrD9RoFVmKdMR2
	 eOcVQ1PTvEVpQg43DGakD1wboz9TL+uhs94MJtq3Hfadsu33DkWOtpkh4It0vXIT6xphy
	 atHTTLK0Bpu8UO+Qp9gryHgZfckXzYZ1cqZITupGll5ubBhVEszIsxnIK/nK5r0c9M0dG
	 +fJl5Waj7nm2w1Adj2DQ0NwT/9cVKqXSIx5WhpfqkSbg77D+WOGOYhAQ8vkWcwV0Msw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/ry2dwZKszdhIV00nuoB8T5uDAQJ5sfzCFlQPPhcQM=;
	b=cNWdTN5uiOF64wz2t8QdDJ3XwOypcrQpYjsnfv34lT2PwmWzdk3l+gdljNEso+p2UZKF
	 2Y45Q+YqGg/MgV+IoQgMPfa16X5C8F6UbOrBttule8o4zE0dBEPGAYRQqJ0K7383jPNpf
	 zsyK3Ly11V6UO98PBxomR1dzRv9hL72PNh7QcQUBFqUCjYGdalkDOJn9ZIhktQG9TouDI
	 P4qIW709x1vg/79MyyONRf+dlPeiSUyIgW6yBkSEukBi3BrZXBVa5U/SapVBKiwRkMAcU
	 CV5md2sSVqJvSncPmAEmQ3m5pXsFDwIM9AKHNCB7AuH4ALlwZFKT70MXXx+rJAezgyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkK68mGX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE198606A31E;
	Wed, 25 Nov 2026 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkK68mGX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C651F000C6;
	Wed, 25 Nov 2026 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623291;
	bh=Q/ry2dwZKszdhIV00nuoB8T5uDAQJ5sfzCFlQPPhcQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkK68mGXGwX8H801SPkuTs7zw1/SzMbf8HXKWUQMmSje0gLlX4yRiw4/R4Ry0DK49
	 WkVD9QtJf5gk3L9UukPvzTHuSUfBJ0neBDkde+Jiw3rltfFpIwA7fPA8NMiHhWgmuT
	 ujc+tX6DbhgTYosS6Qzu1o0YKy75g49UrqIUJ7jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 811/990] wifi: cfg80211: release rejected nontransmitted BSS reference
Date: Wed, 25 Nov 2026 15:36:18 +0100
Message-ID: <20261125143841.041738232@linuxfoundation.org>
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
@@ -2437,6 +2437,7 @@ cfg80211_inform_single_bss_data(struct w
 		if (cfg80211_add_nontrans_list(data->source_bss, &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				bss_ref_put(rdev, res);
 				res = NULL;
 			}
 		}


