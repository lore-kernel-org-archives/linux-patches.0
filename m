Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8029233120C;
	Thu, 28 May 2026 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998206; cv=none; b=LKnh4rdHcef4kx5xwEQuM51KfeASjLTbxgxqo8eYr0X9SlV0ShWnBOHnpr4SzGerW2harz2j6rxJ3zSyC7jvN2UHhHIA075cTBXa8d+NEcoe3frRw4FHQ64BVjCOWzJ6gYfkYHPVKC+JqDWQUFqp0zS4PgR2D/fvJwpV5cmcjgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998206; c=relaxed/simple;
	bh=4f7qVbNgjLIJ+rFnCVknHwKxk4CPmqSd6TWFNi2LwnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rei5mtOHMW8WBzgzdcXooDNF8NIMQKQbUZPnfDR3zuzGNNmu3LV4veCXnIN7VtKLFB/qrHsIjim1sfgzHNv9A5prXcdUSO3Mbd+R6EQ/ns555Ls7KviWZUfjx9NvdPUUeBtsMv9guAuAjY1FUlwzOkPArnMDQiRXv98kNO1Vq7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXtTzQ0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXtTzQ0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE94D1F000E9;
	Thu, 28 May 2026 19:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998205;
	bh=VUDqmI0KI7mfhZuvAAfPkdM+uAFKQlNRAwvMp6/s7NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXtTzQ0uUhLrtZAEbQKU8Ml0XswrcGKSQfHgMG8M3+x14M22aZ5z+GHcSQFJUJ2HZ
	 dre4XydJ5Wgjeg4Cy+FuOwqvMeOimhQkNs37kkg8TpaZEC1d+9yOAXclQiD+Jy0ARS
	 uc7K8Hr7Zt4nfOGdgAbfXMExHyzJ5AY5mMH7lj5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Walker <johnwalker0@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 092/461] wifi: cfg80211: advance loop vars in cfg80211_merge_profile()
Date: Thu, 28 May 2026 21:43:41 +0200
Message-ID: <20260528194649.596612035@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Walker <johnwalker0@gmail.com>

commit 7666dbb1bacc4ba522b96740cba7283d243d16e1 upstream.

cfg80211_merge_profile() reassembles a Multi-BSSID non-transmitted BSS
profile that has been split across multiple consecutive MBSSID elements.
Its while-loop calls

	cfg80211_get_profile_continuation(ie, ielen, mbssid_elem, sub_elem)

but never advances mbssid_elem or sub_elem inside the body.  Each
iteration therefore searches for a continuation that follows the same
fixed pair; the helper returns the same next_mbssid; and the same
next_sub bytes are memcpy()'d into merged_ie at a growing offset until
the buffer fills.

Advance both mbssid_elem and sub_elem to the just-consumed continuation
so the next call to cfg80211_get_profile_continuation() searches for a
further continuation beyond it (or returns NULL when none exists).

A specially-crafted malicious beacon can take advantage of this bug
to cause the kernel to spend an excessive amount of time in
cfg80211_merge_profile (up to as much as 2ms per beacon received),
which could theoretically be abused in some way.

Cc: stable@vger.kernel.org
Fixes: fe806e4992c9 ("cfg80211: support profile split between elements")
Signed-off-by: John Walker <johnwalker0@gmail.com>
Link: https://patch.msgid.link/20260507230720.64783-1-johnwalker0@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2462,6 +2462,9 @@ size_t cfg80211_merge_profile(const u8 *
 		memcpy(merged_ie + copied_len, next_sub->data,
 		       next_sub->datalen);
 		copied_len += next_sub->datalen;
+
+		mbssid_elem = next_mbssid;
+		sub_elem = next_sub;
 	}
 
 	return copied_len;


