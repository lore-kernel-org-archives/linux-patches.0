Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5208D4F3904;
	Thu, 17 Sep 2026 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660508; cv=none; b=XYPpHnDr1ZZBlVKG4IpIpxnjd4K4b2nWQ0Yfovd3rHkW5/qVbB5zRxg3bnBk0eBJWy1MLOouXpPDqB6WgUyXocILCSCNz2ECxAT2R9hIj55QENYeeEe2/kDWuyD642ulX0lTmhUCgUrA5lHUxQ6q/5+OzxJ8OJOE4TrIDpHv8aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660508; c=relaxed/simple;
	bh=9buJ+X/ulBmFTrq3rYHLeCtXvy9SCbyebmSmRbhJwAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRLp15cH2nIBUNePjCksl1ZEWngB9aY1y4yClfB/9ZGut15Sgszq56jnKNobrvUAETgZpiiw6OuJba3uNkWix3b4qJoKzag0jA1vNZkQhSFkWlu0l2lyi1fFlDl+q9gKf19fE48N6uRFcN9+OrbstLOtrxpzPuzf1X/l4k+2DsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wssXkR5r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wssXkR5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553B31F000FF;
	Thu, 17 Sep 2026 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660506;
	bh=mvJejESYK3V5u5QMlYvMDs/rLelmJZqRtoQw8VPO8Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wssXkR5rqh3cdGo8xiOrJwgzawIZmRsl1AGGn4Xl5HSJ+p74JFGiKZk1HUsib3idC
	 iFZIcQwCoGLGndVc5aMw2GfN2oVS4SekPoHbU53I2gI2kKy6vN7WC8zUFpXXSeYKwx
	 pwnXHDX1h+DEFBwZFx7cKMCf/u/G43VUUkamLHUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 614/733] mptcp: subflow: no need to copy thmac during ulp_clone
Date: Thu, 17 Sep 2026 16:15:22 +0100
Message-ID: <20260917151407.805706061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 29f641951be0d91036d77edf677807f1447dbe65 upstream.

'thmac' is not used after that point.

Indeed, subflow_ulp_clone() is called when the request on the passive
side is over, so when the truncated HMAC is no longer needed.

Note that in case of SYN cookies, thmac will not be initialised. So
better to remove it to avoid a warning from debug tools like KMSAN for
reading uninitialised data.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-2-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -2074,7 +2074,6 @@ static void subflow_ulp_clone(const stru
 		new_ctx->request_bkup = subflow_req->request_bkup;
 		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
-		new_ctx->thmac = subflow_req->thmac;
 
 		/* the subflow req id is valid, fetched via subflow_check_req()
 		 * and subflow_token_join_request()


