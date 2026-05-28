Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A12339866;
	Thu, 28 May 2026 20:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000583; cv=none; b=fu++fUDfnNq+E7pzmL1B87s8u8Tn347ndpQHKG1jOUVQs+VQ7ObWt4LDD7y1+FIIyykW+WULMqvYpdmetlvna4GEWugEO2jl9ZZtBYbTVaEjwxpvycrQO6OD/FX7J0K/nLfqvupKFjhtnWAKgdkZ7SMekOse6iIa3npfk/xVpAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000583; c=relaxed/simple;
	bh=ZAzKe5IftU4JGfhH/l+vc8SM6kfN/hZNYDGDC9IKBL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOMg4mf+GIluvuyxWqZQ50q/iel4BespzXO/s6LDNvZyjn7ZmsaheqzN37iwtGFdVW4FqhkCBRXM2F6b7f3/Uu8DDYKfHO4JCLmKQvbA8ui/mhNgmWVPQWmdhsY20JItyzwy0iGnZgGHg0iHjuLTu9m63qg+4ZqQ92F4uZNhii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGb3Uf/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGb3Uf/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1169F1F000E9;
	Thu, 28 May 2026 20:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000582;
	bh=EohF4MSGGjY6jaxao7xAkKdM1W3bNtLjX5pM9MJaQwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGb3Uf/6LZh5qEgDv7y2eHeOI3wWiWHtTsiqA/yiJ5o9hoVOif8kUqZiWY0p/vezb
	 EzJg/P59Gpopk6xfJ1+8u2DK2inPIJLGdcRwCFDz+JMpVa4EIVrXZ1GV28URfHUtyE
	 Daw9iQzPQZ/rcHE/VV8Cogp4uwqCo4jGN6PNa4JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 097/272] wifi: mac80211: consume only present negotiated TTLM maps
Date: Thu, 28 May 2026 21:47:51 +0200
Message-ID: <20260528194632.095433601@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7290,6 +7290,7 @@ ieee80211_parse_neg_ttlm(struct ieee8021
 					 "No active links for TID %d", tid);
 				return -EINVAL;
 			}
+			pos += map_size;
 		} else {
 			map = 0;
 		}
@@ -7308,7 +7309,6 @@ ieee80211_parse_neg_ttlm(struct ieee8021
 		default:
 			return -EINVAL;
 		}
-		pos += map_size;
 	}
 	return 0;
 }


