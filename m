Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659FF3370FA;
	Fri, 17 Oct 2025 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713551; cv=none; b=ehmeadCqURv9s1+/kyBSfbmXQGGwjccFHI+90PdzBpcWcwStYU8Q/IqRqQp50kPvnGqsVe8r2caOCEFbS/dnguYiJn6GAevwd95jcHkDgKa+1jDUDaRKv7Fp+SHGPwFpEa8J84+BatA7SYAd2zTNiRGQD6XIm5FVuODNQD0Q8v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713551; c=relaxed/simple;
	bh=HAI53zNoauSK+A7Ksj8f4xci7hjOrPVa1limhPQYn6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1A/0MWBzWahnR9PnfzEtRorjYQghvRElN4iVKOOoeZmeWBbFm3AlM+1wEIu+j3ADOe39ur4hSDdvLAawcyUuGg74tj4sQ+gY8fLYP4/ZgNHFXnBNszq9PXSr591sh4C83fXclVQ29SLD07ghODw2QanaN7a6hftR6VTsVOFJxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViBkbGvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViBkbGvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD466C4CEE7;
	Fri, 17 Oct 2025 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713551;
	bh=HAI53zNoauSK+A7Ksj8f4xci7hjOrPVa1limhPQYn6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViBkbGvM9ucSu2odQVe00veMCYmszwdk1DWDU/9Ypw4pobvloMj6AvcTqiANso5AC
	 VbPdPFVy8dTVApUuWKV3LE8kbJO6W6rnG/TyDuf4uT62DXYHq4Ch85vDe+wLFFQJk8
	 J49JuqremVBxG/EtDqEKCCCn5YFydH4iNK0HJEQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/201] net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()
Date: Fri, 17 Oct 2025 16:51:37 +0200
Message-ID: <20251017145136.070047258@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 808863e047e0c..2d88654e8d8e7 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -884,7 +884,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
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



