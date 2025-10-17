Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300083370F6;
	Fri, 17 Oct 2025 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713060; cv=none; b=KWWXs+r2IBCj4am3WHZ3ro0re+ARi9nRyrtc7iL/S/l3vCL1LmbnaPA3GfOU3SNLl60O2or30CARbUEew9Zpt0U3Px3VlvfWwQwO7GU9UmgRbGuv1zGx48WlPcNNDg/gF/y982TsV+NLYuRf8b1gKZppvzLNUp4vIMJ2dYKy66s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713060; c=relaxed/simple;
	bh=JjFHKBFZsL8GeFDqFGQsHrR3jOLon2bLHa9eSmcOpaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbTi95hQ4E1EAgLIVdaxV1Vk+uMDfopKycbm56S+GZyreVujh4ZOO3HvFFy5QzjFDmsasDT8sTOrZ32r2kT3dlZSJuvld/dq/k0EihPM+KCTg84jNkuVfWJuLPKCvory5/9/8OfkHLodDssv/FVr8gR7sT7DB7Xd5xGADFWyUFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mMndS0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mMndS0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA2CC4CEE7;
	Fri, 17 Oct 2025 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713060;
	bh=JjFHKBFZsL8GeFDqFGQsHrR3jOLon2bLHa9eSmcOpaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mMndS0Qia37SjPLS7Hbcp045YzJm1qZ+pTG98sv7Fr5GoTaPBt92Gc0S0XhaqSY5
	 Kv/ubwUyuhgwBSFrwtcUQsRfrA2HV/pBl5l9SoMgw6V7R18eap/FmSu3dn4WomMWG7
	 nvGVHK7RaLuWWKWoHAmebT7m1UF/1zEYQcLDpno0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/168] net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()
Date: Fri, 17 Oct 2025 16:51:53 +0200
Message-ID: <20251017145130.275696519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

From: Alexandr Sapozhnikov <alsp705@gmail.com>

[ Upstream commit 2f3119686ef50319490ccaec81a575973da98815 ]

If new_asoc->peer.adaptation_ind=0 and sctp_ulpevent_make_authkey=0
and sctp_ulpevent_make_authkey() returns 0, then the variable
ai_ev remains zero and the zero will be dereferenced
in the sctp_ulpevent_free() function.

Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Fixes: 30f6ebf65bc4 ("sctp: add SCTP_AUTH_NO_AUTH type for AUTHENTICATION_EVENT")
Link: https://patch.msgid.link/20251002091448.11-1-alsp705@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 4848d5d50a5f5..1ca9073c95835 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -885,7 +885,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	return SCTP_DISPOSITION_CONSUME;
 
 nomem_authev:
-	sctp_ulpevent_free(ai_ev);
+	if (ai_ev)
+		sctp_ulpevent_free(ai_ev);
 nomem_aiev:
 	sctp_ulpevent_free(ev);
 nomem_ev:
-- 
2.51.0



