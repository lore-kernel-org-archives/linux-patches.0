Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573772FDC5E;
	Sat, 30 May 2026 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161966; cv=none; b=BRrEi+QYsyxJFAwjt5pZB/wCz949W8Qq0EFrsvB3dTccr+lcJJ17wwhwoxKgCP+Lgs7ABh2Cy3J5T9Ej4+czWxDZoMhWxVsfk8XbgjodifWctwT55fBHKCJSG7fXRJpgWZ0LQdg9ZoiCHtq5X93RphklSO01JHUwPgf5FYMMFzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161966; c=relaxed/simple;
	bh=Yy9LO/AY0WOotlrogN5xfcrR8D0UQFpGjlgGRkpIRgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4ntwdx8WrhyrGD0YYEhsQhvA33xBHBPMIg5YhtWjr4kQRIcudPsS79EF1OTdZDWdmas1rYALib9M5sJcK/8hcgS0u7NAZ4WhTrwWAo7PdDJz8cYDlcDN8dA12fKMnGQs7AM8DtGh5yy2CbjZ+nIA8aXeLck1SKIFBHlzQKQzGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeCTao82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeCTao82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA511F00893;
	Sat, 30 May 2026 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161965;
	bh=aTQD/HUSmPdSR4y72vYxXF3LBklaJ7STwiY6ucfzDfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeCTao82zfhec+CpWumdA9sL4NWKp27HAnyTEGt/ysv+GNHTYGEbArFZp7YMJpy7J
	 JCT/xh0J2Y+Qy8B7284FJGIEcR+Kznm2LBNyQwcg+srTsuiQOsTB55HjCh9EP8bCA+
	 tnsDFIF1dEoTCkqwMHOlD40FTnGjZKwL4K0mb2e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 763/969] sctp: discard stale INIT after handshake completion
Date: Sat, 30 May 2026 18:04:47 +0200
Message-ID: <20260530160321.638832647@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80a6b9fc964e5..1685f73602d5e 100644
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



