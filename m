Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A5C3AFD16;
	Mon, 17 Aug 2026 14:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976803; cv=none; b=ou//0qYy/6Wpv5PbYLNa7acmWRt/asCxQXRfeZYM3dqDIG6+g/QWQvktRG6oITRJKQ6Ra8aSuoLZZvZGeK0RR3B5QhFGmR/MXqc9IPwBOu3Zdoe+/+e6GpTIKdx6N4S77RAFx//jYu7JV/DS9A9GYWqMbWGdWLVy9wWeZCBfWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976803; c=relaxed/simple;
	bh=W1dLcaF/G+xvu3cJN6y7Jrox4OJHTd7OPGR1fBqUhe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2guhot9ssRkrPl/xFi6tbia+s6Ie0txi/LxJtacfeLNYvHS7De/m8NwMW+L+PUQCM3bZloEcHKy212DU0OigPOHXf7afCnzBxC1o71ta4P8KTHOSIDmAlh7eM4vDMTkCAB8bHlhp9FtVG8tRlIIaBncxWszDjF4ha3yE2noum8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRRQdNdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRRQdNdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51961F000E9;
	Mon, 17 Aug 2026 14:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976802;
	bh=rhXBgDxss20MOlMw5W9KKJCUdvCtBJyWkE84+wuxwaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRRQdNdzvVf1+jqK3Y64rxsTa3oGsNvsJ3hj8IMdatQktmOufeS7b12gVc18Bpa4H
	 WnOhYESEBUXXXSsTiQWR2B8NTxtA1xDXrtHGFa8PP2wBzyR91yqxiK7t63gKttBnvA
	 4gqiziv5SMXvrH8OBznTTS2PZRGNoe2xp2VrGeow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/456] sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid
Date: Mon, 17 Aug 2026 15:28:20 +0200
Message-ID: <20260817132544.390943715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: HanQuan <eilaimemedsnaimel@gmail.com>

[ Upstream commit ff04b26794a16a8a879eb4fd2c02c2d6b03850e9 ]

sctp_auth_ep_add_chunkid() uses SCTP_NUM_CHUNK_TYPES (20) as the
capacity limit for ep->auth_chunk_list, allowing it to hold up to
20 chunk entries (param_hdr.length up to 24). However, the copy
destination asoc->c.auth_chunks in struct sctp_cookie is only
SCTP_AUTH_MAX_CHUNKS (16) entries (20 bytes). When more than 16
chunks are added, sctp_association_init() memcpy overflows the
destination by up to 4 bytes.

Fix by using SCTP_AUTH_MAX_CHUNKS as the capacity limit, matching
the destination capacity.

Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260713032021.3491702-1-zhoujian.zja@antgroup.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 34964145514e6d..a983f96bb0c395 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -766,7 +766,7 @@ int sctp_auth_ep_add_chunkid(struct sctp_endpoint *ep, __u8 chunk_id)
 	/* Check if we can add this chunk to the array */
 	param_len = ntohs(p->param_hdr.length);
 	nchunks = param_len - sizeof(struct sctp_paramhdr);
-	if (nchunks == SCTP_NUM_CHUNK_TYPES)
+	if (nchunks == SCTP_AUTH_MAX_CHUNKS)
 		return -EINVAL;
 
 	p->chunks[nchunks] = chunk_id;
-- 
2.53.0



