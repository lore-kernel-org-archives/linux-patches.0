Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208616;
	b=oAQQe7ktQahl3F5qVEJ4Ebg0mfwXxsXVs5ZxQgcML0gKfymdW21Qvp1hfg9QGGkPBUSm
	 COuLnj1iiu3uJQevKXz2DiD3thz0HsFkCz87H9YLk/aR1ugyPB8Py7r9wA43Wy3ZYfikp
	 j17dmSt1Xq9GzL2MMq4T8yzCSB2AJr3hVfy9qHZpB9Xvtu3Vz+r8CTN9k3nxWlk40Zt9I
	 kXoBZBka+4VcpezJWGEUXwy0/Li3y3zvAg6CDi3/RCoToyr22OmvHgqEjM5bt0Ko8ojuh
	 BzAG8cGLLvfZCfS+WPNzqf3+Eji1LF/d6QOLRwqo3bN6QfNXhPLFd5yKyLD8FXObk5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3sXVpIj00dbN3amM8zQ9hBZeDTREVNbGL+9mFdmRaPw=;
	b=WL3BLI6TkvJDjU2SYETWNcd9FyV9yFBfQFq02DEKX5zltvotqImVClMQ2AcfNwavu62H
	 b52DZaGHE//1qaY0oyOoNqm/djlFJSbOh3Dlxmp1yT8Seg6oekSiVmVtOt4XauWV5oymO
	 4IONEI9Vuw2tuixWzlTBAorTT5IxI3bUboxpVjmYmbUS0LW5cdrnGXScc/RMvMhFQ3CZA
	 7r4pv7TUBR1e6H59SYDfWeMVDjI+ILWq9knuKmZjd2BcGHQwlJKnaebyvI+QuSA+MphuM
	 hjxMltZC17qojTazLRZxpeNX82JFUNAwaMgArQx8vBLpnuBvU8VPbuPRKu1WUp3+zFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DdJM8mCW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560DB606A327;
	Wed, 28 Oct 2026 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DdJM8mCW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57721F031E0;
	Wed, 28 Oct 2026 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208616;
	bh=3sXVpIj00dbN3amM8zQ9hBZeDTREVNbGL+9mFdmRaPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdJM8mCWlhlHeFv45DRy3DG97qKU+rMtzb6otKyWlUh4rrgoUj9TXkzAjxRPB+qiL
	 PilQLtEiCVlXGBsy81jzEbTRrqcW162oCaI6hFi0dJpBqmauNuh1OuZ1rfOVczJQ/A
	 2cH7UitfDK0gvZKiGeRm6ryPdRE4VntfP5Trf8WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/516] wifi: cfg80211: avoid double free if updating BSS fails
Date: Wed, 28 Oct 2026 17:54:57 +0100
Message-ID: <20261028170006.943703394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit acc44cbd7727115f9381c35c2898b1b5af665ec8 ]

cfg80211_update_known_bss will always consume the passed IEs. As such,
cfg80211_update_assoc_bss_entry also needs to always set the pointers to
NULL so that no double free can occur.

Note that hitting this would probably require being connected to a
hidden BSS which is then doing a channel switch while also switching to
be not hidden anymore at the same time.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231220133549.8891edb28d51.Id09c5145363e990ff5237decd58296302e2d53c8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 058f3c1f87914..7e6e72ae6d5a9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2751,10 +2751,9 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 
 	if (new) {
 		/* to save time, update IEs for transmitting bss only */
-		if (cfg80211_update_known_bss(rdev, cbss, new, false)) {
-			new->pub.proberesp_ies = NULL;
-			new->pub.beacon_ies = NULL;
-		}
+		cfg80211_update_known_bss(rdev, cbss, new, false);
+		new->pub.proberesp_ies = NULL;
+		new->pub.beacon_ies = NULL;
 
 		list_for_each_entry_safe(nontrans_bss, tmp,
 					 &new->pub.nontrans_list,
-- 
2.53.0



