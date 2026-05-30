Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E06258EDA;
	Sat, 30 May 2026 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164909; cv=none; b=Z/cQuy1Ali50ETon7PqidgRJXeCIhDRWArJfWniLQMEOnCt6eRX9i8Uybtv3MdTQJNm3iOorJNFU/50W3ej6VjmUa1WiZeG0GlNYsoDqIMmfUr43HmvHIBN3dIwT2VgOPbtVtOxJjnysVQIJ2i3GUAzCwMVo/GIfVh5bw7PgQbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164909; c=relaxed/simple;
	bh=IQk/brV4TYJQ1K/YX00p4nhGuysPkZoXqBGnaVXKAxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRIHZ3WhJCZENuBt31oU9kDRQ5DFe0HWq+mL+Xkxd7CTLkV8yF1A2H2BhDDixUTjsnW8msMFOSV8bZUfQDYHG3N1YMjEFddjgToqmeqj6M0yUN/MIWdVyPiz+5JkMJ3+1R6FjAhDmBXmI1Gz6Z10PW+Iy8Kx6FR9jvTYiQfX0jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlubRIT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlubRIT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9161F00893;
	Sat, 30 May 2026 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164908;
	bh=FKkkbApDOmjoipnu+8JiHnDCVqLN7ecaeO7NX1ia6rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlubRIT1szWHU/WypoiJ8lHTp1o+yzkazKjZ54EN1ZB7cqrAdKXaqac0g+rCLReKE
	 4uRePVNwQ1egDbnO9LXgtYKnQ7rlSScJBZDhq+0sVmIeHLm8WunBxBlmjRtuEFy/Xm
	 7HdeUTkDdfjRsjAF/9YrVoSBkCoyz1pjRe/+RhsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Walker <johnwalker0@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 695/776] wifi: cfg80211: advance loop vars in cfg80211_merge_profile()
Date: Sat, 30 May 2026 18:06:49 +0200
Message-ID: <20260530160257.798109378@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2180,6 +2180,9 @@ size_t cfg80211_merge_profile(const u8 *
 		memcpy(merged_ie + copied_len, next_sub->data,
 		       next_sub->datalen);
 		copied_len += next_sub->datalen;
+
+		mbssid_elem = next_mbssid;
+		sub_elem = next_sub;
 	}
 
 	return copied_len;


