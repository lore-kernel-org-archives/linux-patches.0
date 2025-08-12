Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143E42F8BE7;
	Tue, 12 Aug 2025 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021416; cv=none; b=Jg+rMhRxibZX+Pe8AaN2nytuDuuegaWxMJuB/b/HRIUINrx2JmaIx3mzq3+5RWzIKux/4WFp0XKV8EGDFZDXzdr52XGb5YPNxjlcgoabUV9pft20o7TFYru7BYy+gd4TAHoC6/tUSzXMt8246GYq+L2Ztjr3LFcOx8zbar1uWfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021416; c=relaxed/simple;
	bh=+1DQFgswVuHo5NbejPa62AzXZmOyKCOdXNUyR7C72lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUMkALBbppllOdiTVYlNk9eaQrtWvyNpi7RjbKRvc7VRwgGZ0w6M4VwCtqyn1jZlpmgLEWD3yEKjAG8AsuVAz7HfnkNd/IDK8nisKdjX1dWNRBVB+vkFPMrDH6DWcdlor+idZiN1oDUSM/5nHhYiyTmhqFAGSe9IA/DQuKNfR9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2NV6aM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2NV6aM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7399DC4CEF0;
	Tue, 12 Aug 2025 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021415;
	bh=+1DQFgswVuHo5NbejPa62AzXZmOyKCOdXNUyR7C72lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2NV6aM/skB88L73exKlxOQxkHKfw4Sb17zkjmewYl0VzOf9b1FKTeXRkF0hZIU2N
	 fHNXpmkiTJjYqtOmJS6pu5haFBQg4Kz6qUrIT8CdnmyE0WILfM9zsbmvux15hP4cJH
	 w1EtTnmD3VGZ1T9Eh0lEbJRR1BpK1YxPiJKXRPr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/262] wifi: mac80211: Write cnt before copying in ieee80211_copy_rnr_beacon()
Date: Tue, 12 Aug 2025 19:27:58 +0200
Message-ID: <20250812172956.895068724@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a3c5d4d995db..3ff7f38394a6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1099,13 +1099,13 @@ ieee80211_copy_rnr_beacon(u8 *pos, struct cfg80211_rnr_elems *dst,
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



