Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F58C32E144;
	Fri, 17 Oct 2025 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715076; cv=none; b=mujuDYRXIgjtX6bqn0KFS/LPSyevCk4Ih9+Y1zlZjZyCh4j5pv0wOjUIsnV8s1Nej+gOd7D8oMr4wJXiLck1/pS48KukIExSlXFN8Regg6D+cyNCliNYJwQ3OlCnoJASOhaQwc/mqBCHZFd+/WPDwcPXncaPg4TS7R32QpX1Gk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715076; c=relaxed/simple;
	bh=h3MM86bhAY6ETnw1nEVUtcQGqmEhQxSRwnIIfEjhsek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNfowAMXqyFWusuVHgQ4BQdf9Q+M6bUsUA7fxgrAvdzh6wGp/25glGgIH4Bru1mZgdhvCkd9OEEMDi6IrHpPSBClX4yziWtAX7P/Q7jJNTNav8zLZYTL82l5xSSZ2FybojucWn4CzjutteQQ2YU9E+oaXraPaQIFpdrUk1ao9F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6QOkAkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6QOkAkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9284CC116C6;
	Fri, 17 Oct 2025 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715075;
	bh=h3MM86bhAY6ETnw1nEVUtcQGqmEhQxSRwnIIfEjhsek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6QOkAkcuuIy/r4InlNDt64MmKprqv7klxXloN6IeICHrFGEjFD8etRC/DTm6Lluy
	 wnPYi2XXe2++Ssa+QY7LbMND7D2k2tbKNa+nY4a7Ndv58OvdtaWIcxjFGJtFFtLZNn
	 5o571urMnzd3a1osoiQ/ur4OBdoy84HMWZOATaRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 088/371] net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()
Date: Fri, 17 Oct 2025 16:51:03 +0200
Message-ID: <20251017145205.122549800@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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
index a0524ba8d7878..93cac73472c79 100644
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



