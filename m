Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043842;
	b=kbC+8QAWu7zzzm03S5Y6LqF6xDHhBJf9CVSmOLq22YftIjLquyastm81Qkhhze30uLEn
	 ei+z5y93t1pNgakjK/4MTRrq0xpC2h9bDSumdsvSk6MyXyyy3tx5tSYBAzyc+BvkHkt3b
	 M4fk/sBVD2KqufNNnOu7RYNL7yLoekfXRbJO3gHUixX5+eTq09gubi6FHUDR4oa2V7aXY
	 2zvENYKWUkke5ZAcVv+kVgjkXPhFe595FEsPBPaS8wRlT1tMZG8iCWggmh5gah7BpU4/F
	 GoA9/hdkDtNp2UYwEybJRzZYQCjv2wWgrf9q9dY9uyGjXpDxZwB9m3M00X4Y+D367hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jdmhEnTpx1HLc1At/zROftLBERRpkiMvWQJH0TIXwCQ=;
	b=jmAdLAPyKbWoWfdbhaORDQ/LfRyIPW4PsiR+ctxOyn+onhZvaRF5U4tpvejz94KD/9ng
	 BVTDmMFgQC4V+EzNqk1VCpvuQr8M4lAncdID9T5e4huB7ReFknbmaey2BNRL6sWqHM2zE
	 8CUX13eOC5UIaTZZFpFm+EnwUvnmNfVET01DTdN3BLnJY/55bRggblyHxMDisZavScB6T
	 Ow8SirELMNJTmQbzLy67O0wHAliudWVUwU5yUJunDNZMsaObg+8yXlYBhHntjBqnJkOp4
	 QuLufz0e+94S0Cnkxthq8WGbXIz54BbOI1ASRWL0ikFeFEA7cIAXTpprE1Jqku8FBnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MAK/zBit";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD05E606A336;
	Wed, 18 Nov 2026 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAK/zBit
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E95E1F000C8;
	Wed, 18 Nov 2026 23:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043842;
	bh=jdmhEnTpx1HLc1At/zROftLBERRpkiMvWQJH0TIXwCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAK/zBit8PcEx0Xsq5UvdnpWefIKNLKvhJ0HuclHt2bzpg+DRivMQMogNBIpTmcxN
	 JzkkBfHo/U8stjCsRohAIvcFFSyHEWXfXWq9kqOmrQsSQiWG3hgF3A9sJ/Ws58g0XK
	 rIHkclZfS9yQKQtNk6gyE/F15gNMqQmoEXdID16A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0354/2857] nfsd: use test_and_clear_bit for somebody_reclaimed to prevent lost update
Date: Wed, 18 Nov 2026 15:23:08 +0100
Message-ID: <20261118150214.181811412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 0a5a548861ab09e79a6b3062ac17e410323af3cd ]

clients_still_reclaiming() uses separate test_bit() and clear_bit()
calls on NFSD_NET_SOMEBODY_RECLAIMED. A concurrent set_bit() from
the OPEN or LOCK reclaim path arriving between the test and clear
is silently lost, causing the next laundromat tick to end grace
prematurely.

Replace with test_and_clear_bit() to make the read-and-clear atomic.

Fixes: 8c67a210c90c ("nfsd: convert nfsd_net boolean flags to unsigned long flags word")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-13-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 24bc61f743429..158a8ab9c83a0 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6058,9 +6058,8 @@ static bool clients_still_reclaiming(struct nfsd_net *nn)
 		if (atomic_read(&nn->nr_reclaim_complete) == size)
 			return false;
 	}
-	if (!test_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
+	if (!test_and_clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
 		return false;
-	clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags);
 	/*
 	 * If we've given them *two* lease times to reclaim, and they're
 	 * still not done, give up:
-- 
2.53.0



