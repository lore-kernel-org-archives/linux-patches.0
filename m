Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215520;
	b=gLqufk4PC/2hhH7sOwrfIpnI8i31YBZOCuK80H12KnQsEMMfEbH77zx2Fa5ryizEwN/d
	 Qe6mQRsMb1uGp7vz1b/6dhaZOVksA8DXOi5TUAPROxLAdMiczZ6syKpC8Wqlqb3Tb07oE
	 9HrepTHsr89uqMQTvSOj1EA/qu41TKgmltfP30a8Ho7/ltGZBRxCAtYgZkQfyKvwDjAkZ
	 2ZFcwhqrZhw+PK8KpmbNc8ARhyIsvKYPcJGq3RfrOZy/4SkWLJrcluFK3eMZMGZzmh4Mn
	 HJQzr2gps8oBNf+NkaFTS51PUonXVuPDm4+eyfQOo/IQD51LsFZAtEynWGadc5UiPpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4HV1cfgefdXAYPo7bVu2sLWrT3L4d4eXXityHNFGYE=;
	b=KaeTv2r5rxWN8KwobuFjGkzs9yIRuGLzkZE6kFWoxows/HKGpjypPlmRpies3aBfB78d
	 X6czclWLuuz8VyFprEGUrAsCtDGwk2Bwt++BAXwBbRjLwwWEhbwOKWIbm4+ixqFU1ANYC
	 6tCZzveu+UDRLXr0SKBqrXzFnxW5r7tCZTz4yX4YORJhHOvEOEHzu1OFE7H/TCUG39hqQ
	 mwKD2CNDnlnyO35KeQG4iR1suCH1UznOxjkrmhDh9K0rqB4nMyDjjUQkuKCtIE90FLS8N
	 v1dP+P829I1mqeFgo85IpGnw5Ou6BZlNxODXs2mAnac6KC9oSfaTqFvjFfXhmWqN4Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSMRftw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97837606A321;
	Wed, 28 Oct 2026 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSMRftw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97E11F01825;
	Wed, 28 Oct 2026 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215520;
	bh=M4HV1cfgefdXAYPo7bVu2sLWrT3L4d4eXXityHNFGYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSMRftw0gcVfbe2dByCydbJm0Mb3HyqoAPCxncyNier2EpEwPzgnsbLugZdWnR01V
	 OlnjD8CUExQb5PvI9BidIrizso/9wOlB74pXat378ChrzmFjevbX/3KwvZ1sdhRmlq
	 CA4tUv1rcNnCaG3zJE8r77CDw09fSRXM4oJaTlVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1240/1887] md/raid10: fix writes_pending and barrier reference leaks on discard failures
Date: Wed, 28 Oct 2026 17:55:36 +0100
Message-ID: <20261028170527.640929219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 393d687131d8aa8c7e4de2cb494438e145d20fc2 ]

raid10_make_request() acquires a writes_pending reference with
md_write_start() before calling raid10_handle_discard(). Several failure
paths in raid10_handle_discard() complete the bio and return without
releasing the corresponding reference, causing md_write_end() to be
skipped.

Call md_write_end() before returning from these failure paths to keep
writes_pending accounting balanced.

Additionally, discard split allocation failures can occur after
wait_barrier() succeeds. Those paths return without calling
allow_barrier(), leaking the associated barrier reference.

Release the barrier before returning from those paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Fixes: 4cf58d952909 ("md/raid10: Handle bio_split() errors")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260613182810.1317258-4-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 82562c49a14e2..df93471de1e97 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1678,6 +1678,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
+		md_write_end(mddev);
 		return 0;
 	}
 
-- 
2.53.0



