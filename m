Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D40282F17;
	Thu, 28 May 2026 20:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999544; cv=none; b=a9yFpjZqFXnmJEiR30Q0nCYlq3w/ZTDKW38qHkaksHo0LNsVEVjjlOavsSl64JAdWOF1+nIqnNVPVTayM69s4gSPxJarFC0ZQelWxabTYcQ/8UWnNa4u08pHaQ6r++grkk5YilvOr3voi6tVb/OS6U27gADt5SZz1BeZoLnY2Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999544; c=relaxed/simple;
	bh=uW/bMhEEP3G//qFST54oPxItvuCuQNBc768AaiWzR9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjN9bxQCrYRzk1Ml1ZpVMUYGWIh64UknldQppkqiRjF9U1n1VbF46AmvZWhRN2MqWSQDHamIDAnvYfkPfA5dYa7Nws8/KjkKOGQoIioILoDgOG9bfPv1un2eQPkLF+XhkNC6wFy7YUrS6Ei9ro6029gwq3sA/OFbF95JsStbidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOzrwOTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOzrwOTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1DD1F000E9;
	Thu, 28 May 2026 20:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999543;
	bh=n0zWOPOge6O/Lmeo5FAGCOE08w3sx0QzFylUy40ViBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOzrwOTp8dGT4+kjcax1QEtJoO/JySlWO8W14dpm8m9nYx2tFZlD6KE9jPCi7CXc0
	 /O87EgOIYoJr/eU8XODfAgjZe1obi8p5bxs0zUPEiSTMI7dQJ23CPL6eiFf1P/vm3p
	 Qtta3Y27u6Q/8LprOJDibfaRIL0BOULHb8Ea7p2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 103/377] wifi: mac80211: consume only present negotiated TTLM maps
Date: Thu, 28 May 2026 21:45:41 +0200
Message-ID: <20260528194641.329589493@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit a6e6ccd5bd07155c2add6c74ce1a5e68ad3b95ea upstream.

ieee80211_tid_to_link_map_size_ok() validates negotiated TTLM elements
against the number of link-map entries indicated by link_map_presence.
ieee80211_parse_neg_ttlm() must consume the same layout.

The parser advanced its cursor for every TID, including TIDs whose
presence bit is clear and therefore have no map bytes in the element.
A sparse map can then make a later present TID read past the validated
element.

The bad bytes land in neg_ttlm->{up,down}link[tid] but are gated by
valid_links before being applied to driver state, so a peer cannot
turn the read into a policy change.  Under KUnit + KASAN with an
exact-sized element allocation the OOB read is reported as a
slab-out-of-bounds; whether the same trigger fires under the
production RX path depends on surrounding allocator state.

Advance the cursor only when the current TID has a map present.

Fixes: 8f500fbc6c65 ("wifi: mac80211: process and save negotiated TID to Link mapping request")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260515151719.1317659-2-michael.bommarito@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7959,6 +7959,7 @@ ieee80211_parse_neg_ttlm(struct ieee8021
 					 "No active links for TID %d", tid);
 				return -EINVAL;
 			}
+			pos += map_size;
 		} else {
 			map = 0;
 		}
@@ -7977,7 +7978,6 @@ ieee80211_parse_neg_ttlm(struct ieee8021
 		default:
 			return -EINVAL;
 		}
-		pos += map_size;
 	}
 	return 0;
 }


