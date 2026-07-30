Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E43A402444;
	Thu, 30 Jul 2026 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421929; cv=none; b=ePEam0EOBlWZ+xK5uNrOgGvWy2fVCNsrXliIOp6FOtmP63Vd1gIBUXMIOpiukb4ptllDfc57eSy8WepZwqskFBaOlVzPBXh/QpgE9D0E90f5Q6xyxLe/JL+aEdKqnoEEnFOYqIoG2zDflB1utAC8Bl1uRhFNGToEiq9v0KjhNIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421929; c=relaxed/simple;
	bh=ROyKaJfcXdr4DNTXmSjXbGSB8+J+kOsSjH950Cg5K6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnCzk0bNu1iq0gpbNdOx50PQB3xEvBdHJWKI023BHMxu771MTn5aEMUDscBzQylJl2rU7vP01vIUt/FGMlJydhc3H5Mt/shkybqKkZqVGMahrUNWET0PM7/PS6hOW02DU9xKRd4vXHBdMNJbvugv5RzeI37jgm0yMOV+oaOhOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZxjZHg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZxjZHg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E8C1F000E9;
	Thu, 30 Jul 2026 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421928;
	bh=z0fpKVrA2eYOyeEKGhTV7gFjQWg8G8tx+kzvWH7Pxkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZxjZHg//HiBh8qv8YN71B1NboCAx4vM9vfTYaVECk1qYKl2W/YBbyGfXJJ848V0p
	 /8bDhMe+2o6BpRoIcVhVc+KHmnyzenbephvBrDx/YfGzqHspAGQ2o7FvCHar5PFLm+
	 tAH/cPHZvnYBA4evShSeFSUnKhqaQsbvWohgw/vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 265/744] sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid
Date: Thu, 30 Jul 2026 16:08:58 +0200
Message-ID: <20260730141449.926943199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index be9782760f5093..c901d373af803c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -672,7 +672,7 @@ int sctp_auth_ep_add_chunkid(struct sctp_endpoint *ep, __u8 chunk_id)
 	/* Check if we can add this chunk to the array */
 	param_len = ntohs(p->param_hdr.length);
 	nchunks = param_len - sizeof(struct sctp_paramhdr);
-	if (nchunks == SCTP_NUM_CHUNK_TYPES)
+	if (nchunks == SCTP_AUTH_MAX_CHUNKS)
 		return -EINVAL;
 
 	p->chunks[nchunks] = chunk_id;
-- 
2.53.0



