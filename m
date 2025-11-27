Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4DB20FAAB;
	Thu, 27 Nov 2025 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255699; cv=none; b=aqcuZI4fQxA6IC6H7rWl7whPSstnkDegnALuHe0FltGV7F6RMPZW2PUfTWJD1CF00cC27q8W4FoHbteXmdqOjdsDC09t/uldrVxkvhT1Oa08DsgEyXPhhzjpKRLTKYd5E42NTWI6kiKRYK80xYquqpuw5/X8caq5DKnUbfnAg2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255699; c=relaxed/simple;
	bh=6A21bHkri4tYu26U3R/duX10obNh2/2DFrFAYkG61Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG88lTvJ99wEpVJFs9P3gGc4bpgypu+DnBGRdnuxe3GX0TCw6GXRyo3nYmopJfArDlkGK7NS3T3W9V+SRA3QDQHnNWgurmDsvWvaK0B3WEsGkQkU0mcQDkqQSmhoclB0njuc2r4xFMa4cFxO8ToR7xXM1agB0zwcNjWZ6cowlr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYaKPwnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYaKPwnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD5FC4CEF8;
	Thu, 27 Nov 2025 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255698;
	bh=6A21bHkri4tYu26U3R/duX10obNh2/2DFrFAYkG61Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYaKPwnC4fRBzK48gX2mbx3GwecY4uTikMIom8JpBOvKZrErRzeRX6ERe+aaFK0NH
	 XCN79Y2mTld0HrfR8rN2akg0YAK1FawxdQ1AFIGmG81h86lNv1h2Ctij72OdpvVI9u
	 294guk2q5NhoQEck7zB0aYTI5iAlzMc/NT9S3z+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 083/175] xfrm: set err and extack on failure to create pcpu SA
Date: Thu, 27 Nov 2025 15:45:36 +0100
Message-ID: <20251127144045.996337881@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 1dcf617bec5cb85f68ca19969e7537ef6f6931d3 ]

xfrm_state_construct can fail without setting an error if the
requested pcpu_num value is too big. Set err and add an extack message
to avoid confusing userspace.

Fixes: 1ddf9916ac09 ("xfrm: Add support for per cpu xfrm state handling.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 684239018bec4..977a03291f6a5 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -947,8 +947,11 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	if (attrs[XFRMA_SA_PCPU]) {
 		x->pcpu_num = nla_get_u32(attrs[XFRMA_SA_PCPU]);
-		if (x->pcpu_num >= num_possible_cpus())
+		if (x->pcpu_num >= num_possible_cpus()) {
+			err = -ERANGE;
+			NL_SET_ERR_MSG(extack, "pCPU number too big");
 			goto error;
+		}
 	}
 
 	err = __xfrm_init_state(x, extack);
-- 
2.51.0



