Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C523624B0;
	Wed,  8 Apr 2026 18:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673668; cv=none; b=Q8Rso3g1JngO5elMxPAmOg4ndEoTM3RjoAz4h2n8UuNvqE/qbz4FruhMPpMfHSFWBJLQDxteYvj3FFVH/vQMEe95ym+kqUOwKuIiK4HBdJcxGGRZ1bxPCTe2dtKbjF0erzekh2rOQ6y3svbiob1gi548v5g2ICzUA7VaMFTUYR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673668; c=relaxed/simple;
	bh=RkEOaf7FDxqrhmQj2IgMTk+pt4mE0XbKnlKAAGypJ3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmMExm3kes8pM5EgJytU3nAaX1DVvr6JZ9XVMf4jtccpkLuBNc4Fu5ajJ+rA+ZCs6XYxCFxJSVxPtPRZtRao3dgHcxoXfgHBHsgzyjtyWkh84VcAlxrypEoTH5kJMUE6d4pG8n6IrTkj10HWEqkint9PuWbq2SJcZMrk3wBteuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXrdfQDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXrdfQDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E448EC19421;
	Wed,  8 Apr 2026 18:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673668;
	bh=RkEOaf7FDxqrhmQj2IgMTk+pt4mE0XbKnlKAAGypJ3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXrdfQDlnGDu5E35Q0DmQD1JBcpY3syHy64EPuxk2Dyq5LCbHjoSPoq5u/TdMVfhg
	 Oas/GPSmlxhFZ0Mt6WbFfvP68SHFUatqKA0BH5EhOENOxC+924pTa/8j4JPmn47wDt
	 BF84g0VBGEkZsinJtypjsagkDUQTvr49UtXBgzx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/242] crypto: af-alg - fix NULL pointer dereference in scatterwalk
Date: Wed,  8 Apr 2026 20:01:24 +0200
Message-ID: <20260408175928.721237316@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 62397b493e14107ae82d8b80938f293d95425bcb ]

The AF_ALG interface fails to unmark the end of a Scatter/Gather List (SGL)
when chaining a new af_alg_tsgl structure. If a sendmsg() fills an SGL
exactly to MAX_SGL_ENTS, the last entry is marked as the end. A subsequent
sendmsg() allocates a new SGL and chains it, but fails to clear the end
marker on the previous SGL's last data entry.

This causes the crypto scatterwalk to hit a premature end, returning NULL
on sg_next() and leading to a kernel panic during dereference.

Fix this by explicitly unmarking the end of the previous SGL when
performing sg_chain() in af_alg_alloc_tsgl().

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for skcipher operations")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6c271e55f44d9..78e995dddf879 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -623,8 +623,10 @@ static int af_alg_alloc_tsgl(struct sock *sk)
 		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
 		sgl->cur = 0;
 
-		if (sg)
+		if (sg) {
+			sg_unmark_end(sg + MAX_SGL_ENTS - 1);
 			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
+		}
 
 		list_add_tail(&sgl->list, &ctx->tsgl_list);
 	}
-- 
2.53.0



