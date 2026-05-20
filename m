Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E285332EBD;
	Wed, 20 May 2026 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301587; cv=none; b=TiOAK56pLtdk7E9y8iefdlRYIF68hlZ0MunOkjST7djdd5ecGS73JqDYNyih99My3v87c0DM+v+UJE/Nvim/JTdU3vmBFpEaoTmi/5EF8kzXc5rjcFwVhxMc79rNlUGJyEO5pptQe7rrzJyaA5JKLqMwx17B5MQmx79geHjBSDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301587; c=relaxed/simple;
	bh=K20viUbBKYd862XGCRFxkmgprOSrEuPHMqvxzNGwvS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ooeo6YhU+7g3sFySAh59cHaKUi0F5x8vTmy7qvAKu5hNkrj34StWJdAFHq2cqZNveoUd/u/p0gxsI1FNaUMv126JZ4uNed0uznJjC3i+4CZzqHm2BQvwCEHIfe9KUQcAviJdt6luzVaj89UGp3Uw2cu7FmQqxCg2tI/BEYkqkFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYcDGHoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYcDGHoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C275F1F000E9;
	Wed, 20 May 2026 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301586;
	bh=8vx0EpiQuP26oPF+xg+l0WlVS+GErXoFp5ZgAfaNU88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYcDGHoLHm9lh2nC+GRxuhml0VzuLqXfwgszIPBwyrd1fq/oRoLhzBpRSzNRIiHBa
	 YCIciI0ASOvBEgObjUT/2jYNTF/TxUo0yfP7HqUgNi6l9/gvaSF6dCA78f6IpY5wSm
	 A3w0AW0J9T8rWpryx8TvyiRa3r0lk6MNajXzfGcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 570/666] sctp: discard stale INIT after handshake completion
Date: Wed, 20 May 2026 18:23:01 +0200
Message-ID: <20260520162123.623777454@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8a92cb475ca90d84db769e4d4383e631ace0d6e5 ]

After an association reaches ESTABLISHED, the peer’s init_tag is already
known from the handshake. Any subsequent INIT with the same init_tag is
not a valid restart, but a delayed or duplicate INIT.

Drop such INIT chunks in sctp_sf_do_unexpected_init() instead of
processing them as new association attempts.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/5788c76c1ee122a3ed00189e88dcf9df1fba226c.1777214801.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 966bd6a44594a..376d4ce5ebb3c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1556,6 +1556,12 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	/* Tag the variable length parameters.  */
 	chunk->param_hdr.v = skb_pull(chunk->skb, sizeof(struct sctp_inithdr));
 
+	if (asoc->state >= SCTP_STATE_ESTABLISHED) {
+		/* Discard INIT matching peer vtag after handshake completion (stale INIT). */
+		if (ntohl(chunk->subh.init_hdr->init_tag) == asoc->peer.i.init_tag)
+			return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+
 	/* Verify the INIT chunk before processing it. */
 	err_chunk = NULL;
 	if (!sctp_verify_init(net, ep, asoc, chunk->chunk_hdr->type,
-- 
2.53.0



