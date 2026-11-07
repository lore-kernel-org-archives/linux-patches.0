Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062329;
	b=XSxeygsI9I99wAafOMwVLqmrljcoG6My1qC1rnrsWcXg7G82WDz/w61Xc8610nNp9vI0
	 p3Z8lw1/CuIf9jvqgGT/B2JxkXpiRH5Kqi9wAM8mpMZciEaMTg6WQ6yKBSrhggC8D0BAM
	 hGRvngeCi69QQaW+o0UluO2FHRxSQ0rMrZUHmyqn5ohyQK10vTA39G43aJKzODs33xK/J
	 mVkHg40RhF25oS9IUtg4BjIwneTIHbnghO2Y9DWNJzL/++apyh+Rnd5Tnkw3kLch57rMW
	 sVtRIf8LVkK/Di9boj75NViTQ59Vh1Qg/uBoL2x+vIvJwiPHICAO2kfISVU1poEkP4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MgyhiW4Brlp6P/IaoG3NC7h4QAk96m+a2dQh3nroZTA=;
	b=kV5xxcfQ04NlIqW+UzfMhxYXVFmQRbkXoBhvvWiy+RATq1GurhXxomKmy/Z4b3R5DjbU
	 ORJh0N6UHuDbH9ntkcRwB3OOG1Lvr8Xz972ggNYo6rqGwJsYTydRH2U3mStbap9IizT8Z
	 SFCdEET6vfrus7kR3db/heMSuIcYntB8uJmHMFtFYB7TK1btHj5gO+5gV1YJxsl1N3Oiw
	 w6ewopusZGu8xPautIjR2W0ZbucAk3exnFgATHJfSme+vWE9cCViQTh9mXOgMGQR+5fZZ
	 4RrDhcWwinr6OTCHTJK/39oyJ2IW9+cC7n1L0kefEN3zvEmfI/W95iVRSiQ3qBt5EEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKaQBn3e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EAD606A660;
	Sat,  7 Nov 2026 14:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKaQBn3e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5DE1F0089F;
	Sat,  7 Nov 2026 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062328;
	bh=MgyhiW4Brlp6P/IaoG3NC7h4QAk96m+a2dQh3nroZTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKaQBn3eCGHXOvTpF6yMZymxp8vWt6zGrA8r17b54uLWdujiJrOpG0VB8V4n5BFfc
	 nARZUE9X0ofHkG04vJiYFDYs3KKtJjzWwydmwrRPJIicJHpQu4ltQQasJ4bSj1tmGd
	 /8ZkrUf1veKVR0E4BhiAdTjTrepllsmnDfP19VzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1260/1536] dm-bufio: fix a race leading to an unsigned integer underflow
Date: Sat,  7 Nov 2026 08:54:36 -0500
Message-ID: <20261107135033.157446540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 005d2ec5723cd4ac740de678274623f1fadd6a6e ]

The function __scan tests "count - freed <= retain_target" and then sets
"atomic_long_set(&c->need_shrink, 0);" It exits with the condition "if
(!atomic_long_read(&c->need_shrink)) break;" It may be possible that
between these two statements, another thread sets &c->need_shrink to a
non-zero value. In this case, the function __scan continues and it may
possibly the "freed" variable is larger than the "count" variable. The
expression "count - freed" underflows and the function __scan will
continue to free all the buffers, even those that are below
retain_target.

Fix this bug by immediatelly exiting if we set
"atomic_long_set(&c->need_shrink, 0)"; and don't attempt to re-read
c->need_shrink afterwards.

Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index be83be5081526..601c3e3fe56bb 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2405,8 +2405,10 @@ static void __scan(struct dm_bufio_client *c)
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		while (true) {
-			if (count - freed <= retain_target)
+			if (count - freed <= retain_target) {
 				atomic_long_set(&c->need_shrink, 0);
+				break;
+			}
 			if (!atomic_long_read(&c->need_shrink))
 				break;
 
-- 
2.53.0



