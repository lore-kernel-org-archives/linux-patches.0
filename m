Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3CD3B6C18;
	Thu, 17 Sep 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671281; cv=none; b=csB1HdrvEuD9I+W8W/VysAxvH3Fpl0Oo6O7ljcIyZ2zStyTEHYSpRTdAAOPVd5iYY/OZq6B7CLBDfykPIt1Q6Q/4ZbbbktidOWJcHk9QN7LqbauREEhnQDUOljq5dDF1Dd/mEM8bZ8EX4+0/ZA+GXnc2/3t/Bgv13EhiPK+CMBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671281; c=relaxed/simple;
	bh=yYnaUud+TkqCqU+DNsspIfm+5Nq2UN2K6eKWGoVUzUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIClrR2qM4B1I57ZyNU3/XwaeVLU1uGg9ulv/oquCO2wcsCaQytiOaHC2O6Kt11NfjdO0VDnlFP52cgkgvbWVrCXnmAxQNWx/w60t9xBO8p7jsQg+rcFz9gOmFKX0WfravTWAChTzF4+XpyLeuJ+mvvi2luJHcHA7vNlxJ4YIxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvlyq6Vn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvlyq6Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAB51F000FF;
	Thu, 17 Sep 2026 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671279;
	bh=uepwK2fEX7tWK10mxGwfIPK0gxqpTOZDpu+ti8vlFZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvlyq6VnSQlPvYxAmqS9Eb1yiLrQcGW1BrupcaLsohl3Ae4XQCCtGDp1nkx0ZBXXR
	 ROt15Db4kT3ULGBUn8ru1+rLCXqyBbCs3iwJVbTTSkqR6pBxTOQAcwYfnZ6vl0uebu
	 D58TY7+tG7npelX8bzE1fbAP2z8f0SJwFwZJ8wTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0886/1102] mptcp: subflow: no need to copy thmac during ulp_clone
Date: Thu, 17 Sep 2026 16:13:49 +0100
Message-ID: <20260917151602.819101443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -2066,7 +2066,6 @@ static void subflow_ulp_clone(const stru
 		new_ctx->request_bkup = subflow_req->request_bkup;
 		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
-		new_ctx->thmac = subflow_req->thmac;
 
 		/* the subflow req id is valid, fetched via subflow_check_req()
 		 * and subflow_token_join_request()


