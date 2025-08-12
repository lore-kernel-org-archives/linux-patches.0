Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0F3260583;
	Tue, 12 Aug 2025 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026069; cv=none; b=ifiN+Dw/cr0/VvD2Zs1roo4Dydgq2NhZZJQIfhU7ejv1+8aUyWiJexufw4FILj2xlEABZPAPxhfh11uYwt1LWHzEqPEI2LZ5VJOKpryGf5X8RIhMJ3rrPSC2gI4muCatGy2WekPA4HG/gttMYnzgLq1namnFAVxeyhwYtn7N3tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026069; c=relaxed/simple;
	bh=YaFo1cWZmKA3HXJiLjQ1Qu8iPJ2eXuCo78m5pC5TETk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdmI0HMNeCaZbqGuomtesDcUzuQAZduRcnPHTccndgq8KgpKk+4cZt/f1BbhsLMDRhUvXUs/TfydoOsXBqaaxX7Bw6yrTWPbXG5jYDJcZA1WjFFoGZYiRI29mhcm3/bmy6nr/K05b1Us9DXNdMJRGpa1AJbMad/NYrwnjaX9F9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuzR5Ctm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuzR5Ctm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0228CC4CEF0;
	Tue, 12 Aug 2025 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026069;
	bh=YaFo1cWZmKA3HXJiLjQ1Qu8iPJ2eXuCo78m5pC5TETk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuzR5Ctm0Kh3B39/QAP+stR83eEiHvRYWJg28txiCp2+Kt0hdVGPJDSFxT6R2Gqp8
	 X4aLmY/prsqWE2+XZs6vecG7GRJuSs5efD1J+VhuvIyTeqZISlEkIKXnQ485GRAasr
	 hVLLf5fUt4g/pg2Ce0Ae7Gtr/Q9JrasGji8Gx6OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 184/480] wifi: mac80211: Write cnt before copying in ieee80211_copy_rnr_beacon()
Date: Tue, 12 Aug 2025 19:46:32 +0200
Message-ID: <20250812174405.106143931@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4a8d9c3ea480..d9f96a962fa6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1109,13 +1109,13 @@ ieee80211_copy_rnr_beacon(u8 *pos, struct cfg80211_rnr_elems *dst,
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



