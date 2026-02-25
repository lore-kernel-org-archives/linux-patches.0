Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062B518DB2A;
	Wed, 25 Feb 2026 01:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983171; cv=none; b=i6mrCZ2w9mO9VTe8+FX/CuEulVob7t2hFVQjNkCc33fc9mnG/3DJiGk/yc1+NMSuMfbkZoInlT2cscPiBzJsKyRLats+90Cr8mQpugvaCiwOs738kSICEQ3OS3Rmjcf74fe+ZJnob7Vh0hsqP4dC3oEEyFb2Nt8Rh/AR5U2P/5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983171; c=relaxed/simple;
	bh=0fbi8Q6r1bZHmPbrqz9AbHnZI4a7D0L/9L0JjrpbpRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ew+/UOmSP3SaVhecSZOKFYas1mEZOY72ccKvBxEGBsfRljlLmqGBB6pQWgYNyf/QvOv1ylhWTWHEjBOeIrqnKYc/9fFfh9QskAhIlYZg2u1qCKbHea023l07Ld61Ei+pHk5HWDfNByDkD3DOTCdgYLsrGZig2DIfTImdmmrMv9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8gbkcsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8gbkcsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FB2C116D0;
	Wed, 25 Feb 2026 01:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983170;
	bh=0fbi8Q6r1bZHmPbrqz9AbHnZI4a7D0L/9L0JjrpbpRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8gbkcsrPp3EcgGkEdW9364X1LXHtUNV8oZ3rrz8HPII4e1uhjksHOp3Bk5DsGP5N
	 QWn2eNpWQT6/U95QoCu98iSX5S8uewDcrDSxiZUgPudqZYg7+j6LElQXiCSH+Z3CsX
	 M0ZCWKMJVIHHFxDpZ5F6OIg8lGNPgnKAkRl14ypw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Chenming <chenming.huang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 323/781] wifi: cfg80211: Fix use_for flag update on BSS refresh
Date: Tue, 24 Feb 2026 17:17:12 -0800
Message-ID: <20260225012407.625552045@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Chenming <chenming.huang@oss.qualcomm.com>

[ Upstream commit 4073ea516106e5f98ed0476f89cdede8baa98d37 ]

Userspace may fail to connect to certain BSS that were initially
marked as unusable due to regulatory restrictions (use_for = 0,
e.g., 6 GHz power type mismatch). Even after these restrictions
are removed and the BSS becomes usable, connection attempts still
fail.

The issue occurs in cfg80211_update_known_bss() where the use_for
flag is updated using bitwise AND (&=) instead of direct assignment.
Once a BSS is marked with use_for = 0, the AND operation masks out
any subsequent non-zero values, permanently keeping the flag at 0.
This causes __cfg80211_get_bss(), invoked by nl80211_assoc_bss(), to
fail the check "(bss->pub.use_for & use_for) != use_for", thereby
blocking association.

Replace the bitwise AND operation with direct assignment so the use_for
flag accurately reflects the current BSS state.

Fixes: d02a12b8e4bb ("wifi: cfg80211: add BSS usage reporting")
Signed-off-by: Huang Chenming <chenming.huang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251209025733.2098456-1-chenming.huang@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7546647752fd8..eb0e77813d466 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1959,7 +1959,7 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 	ether_addr_copy(known->parent_bssid, new->parent_bssid);
 	known->pub.max_bssid_indicator = new->pub.max_bssid_indicator;
 	known->pub.bssid_index = new->pub.bssid_index;
-	known->pub.use_for &= new->pub.use_for;
+	known->pub.use_for = new->pub.use_for;
 	known->pub.cannot_use_reasons = new->pub.cannot_use_reasons;
 	known->bss_source = new->bss_source;
 
-- 
2.51.0



