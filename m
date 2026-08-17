Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ED73AAF76;
	Mon, 17 Aug 2026 14:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975594; cv=none; b=hgOAiSn4ifsf3GrZgFGNy73f1XGAZ1ToA1bMWf9Rh1YsSVHwhmKCmbN4VvqJ3HGZRFWAzAUl0ks3MKCDea3/i6Mp4dbx2PYyq/TetJSzHBwozuDKrsk71OVF25nDZXRwI3ovQXiziyWGVIVczfRUDlCYfwTwXM3ELSrkY1+k5l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975594; c=relaxed/simple;
	bh=h3ECMU0PS0p31wPCGnEApxOB5sTheghW8pfeD/mKWDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGW/vYoPRhba+yM2sMACByPNfASSpQaydvbCUvRSWnMrH7dYDyGBUaa7pVu7PpV4urnty3m/VW0lIxr1uyLqsgD4L1DgbxLqAiMzoloHaLs5pNsxL/X6JSS7cUWs+zYSWRjxM39BKybiKmhjJt563a6geSGQxET3RN56FKnU6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kH7ECgcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kH7ECgcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7CF1F000E9;
	Mon, 17 Aug 2026 14:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975593;
	bh=wYUwjesUqBvMBfNU5cA2sC34XHpNuap3XLxxqKMEg1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kH7ECgcjeTlliWDXXHo3AjE+iab0e9GdCvqtbA1hqwZOFtLgKUgxVyG2L6aY9T0uV
	 ifxKePupMJhMwbI8mIaYgGzep5PU0MJ598WHOR/zLXl3oRBV9Sr/c+JS1339dlto9o
	 BlyZbzcFazabbswqrecD+5DvViwhuIahKMIl91OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/389] sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid
Date: Mon, 17 Aug 2026 15:28:41 +0200
Message-ID: <20260817132542.304418976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



