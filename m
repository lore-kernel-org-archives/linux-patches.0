Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B326BB5B;
	Tue, 12 Aug 2025 18:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024109; cv=none; b=FGhngAT4burF2s3wL0uLcfmXVSdCg2DxOzw8nkX6vL97VMKyaB68Tgwklp8XgwICuNHn4dHMuIROynRGkwlQxrA52y/Satu6QUeBcCXN79kARB+16f1q2wTtQQGdBR01eAnwu62IzKqQFF49quhdHdHUoGwPTrunZv8aPo9LHP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024109; c=relaxed/simple;
	bh=YQ3r019YSfUbeaDBtC0FRpRf1G2UdVFzuzt5TwYkClw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmqAj9LC4wpcJ7x7u2yYyf9YdX8B2Dwp/7xMpsKi7e23cclMMirjG5gT552TBzFNChN7PgB+gZs2CHJXe9GEHnIlHdEl7PT2QZzWoGuys8US8gzIU+Acc3SnOtlj4xggTODiV4uNU98Mbh4b64K7PFD236QzFeZWfvOWCKNVwno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dN1TxjcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dN1TxjcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D240C4CEF0;
	Tue, 12 Aug 2025 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024109;
	bh=YQ3r019YSfUbeaDBtC0FRpRf1G2UdVFzuzt5TwYkClw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dN1TxjcAxsd2IipKpzxJulGCHKgY7LB/v4u85GCwBYHMMYyRoIpQ6KXqRRGrF9qKE
	 SfmtHvkbdTrGyolg83NNzlI7uES6olilFBos4bHvgjHqp0LlUC5R6nD2xJHTv7XIGi
	 vsjRQV666VZR/8Y94H3SgXKzvBgIiBO6J6VRGCOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 244/627] wifi: mac80211: Write cnt before copying in ieee80211_copy_rnr_beacon()
Date: Tue, 12 Aug 2025 19:28:59 +0200
Message-ID: <20250812173428.580829524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit a37192c432adaec9e8ef29e4ddb319ea2f443aa6 ]

While I caught the need for setting cnt early in nl80211_parse_rnr_elems()
in the original annotation of struct cfg80211_rnr_elems with __counted_by,
I missed a similar pattern in ieee80211_copy_rnr_beacon(). Fix this by
moving the cnt assignment to before the loop.

Fixes: 7b6d7087031b ("wifi: cfg80211: Annotate struct cfg80211_rnr_elems with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20250721182521.work.540-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18ad7ab1bb8c..7b17591a8610 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1122,13 +1122,13 @@ ieee80211_copy_rnr_beacon(u8 *pos, struct cfg80211_rnr_elems *dst,
 {
 	int i, offset = 0;
 
+	dst->cnt = src->cnt;
 	for (i = 0; i < src->cnt; i++) {
 		memcpy(pos + offset, src->elem[i].data, src->elem[i].len);
 		dst->elem[i].len = src->elem[i].len;
 		dst->elem[i].data = pos + offset;
 		offset += dst->elem[i].len;
 	}
-	dst->cnt = src->cnt;
 
 	return offset;
 }
-- 
2.39.5



