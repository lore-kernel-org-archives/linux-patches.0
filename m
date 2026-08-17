Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03872EFD9B;
	Mon, 17 Aug 2026 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979177; cv=none; b=YI3ULbklBmIkghbDKSzWxqOM1nKQdMCN0STfiKAS8nn4vyexYogZwg1pe9gzj7Yp1eXT4udYHPR5jDQRnt7w2T4Pbnk1MEp4rWqwLX4PAYfECksP4jFHPOFJJC4EJPYtUkl1r93EO9phYGB/exdl7Xu46f4eHJ9VqIqHKcWvJrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979177; c=relaxed/simple;
	bh=cs3TLjUsYA5ChdZ52bpPt1F2VpNSR4+wbh9m3z0bmpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujf0VrzKeyf6Qu+t5ea0veoX6BPfYNCsWqUFDELkrt3CEW2LDQwlcCjQTpV1CKZUpPSlsnyoXsblhJ0y2S9b8afbA4qFsSpCRp3nUQZrfhSyb/SHEPENBheCyADulwyydw9Pm9L7tEUUOY2tiHc5UJos4bITTZTyeYMZ6CRembw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sm0yZO24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sm0yZO24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488A21F000E9;
	Mon, 17 Aug 2026 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979175;
	bh=ea1Cp3Z8gHvKgAXRcu7eX2MON0bcvszlmVJbV+FcTAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sm0yZO24ceofMnjOBPSkpLMBIQ+fS9t+ADL/bJ0A7WuehurjXApq2TreC7XiRCXvk
	 Y+QiBNgMEGS4oo7RHRq7vieHVK5ME9fTAE/TG0CvqgtTsesZWy6YSWy0QUjqHpoboc
	 2Ls7M6ukWfXgnoowu5U19Kpo5m3L7WYCa2TSQmaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/609] sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid
Date: Mon, 17 Aug 2026 15:27:11 +0200
Message-ID: <20260817132548.469451891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



