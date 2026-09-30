Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B518950EC01;
	Wed, 30 Sep 2026 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785585; cv=none; b=swSiLsWDurLg/XHk8pbXl/qTA4IeZK2H37A3e6sjnjPea7+7kK/K5R0LP+WaxEOs72VQlI0DRn/AB9308bugQ2KreK2xF+yI5IFm//tazaLhGey2dHLOqtQHaImfBmWMJXeiUbfGRO1pfsLfiyNn4wTTCo3fhNL4GA454Ys31TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785585; c=relaxed/simple;
	bh=0XPUpxBtEPWXnbRZ/mHb6vyZkXGEJ58WcALvzaqxa/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCprz8oLO9YMDj9HHcb/iklBlpWvO6kc2W5UApMBo2E6it6H9lpao9EEzRIUAYcx88mFxDfNP5szwtOaLv+3SQemSIUuCowev3j78rTAH4iWIXftr/4ItysxdvDey1gJMUy50lIacWgnEQ5Nudy5gJ4xey/LHsnHg3dDF6I6QjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgIGK7bk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgIGK7bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707F41F000FF;
	Wed, 30 Sep 2026 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785580;
	bh=6voTUayYWzRcLrZ7Yz70NwcB7mi5vGLifCDxMRCovE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgIGK7bkUQfjnKw3Hzez3JQkON9zUm4mV/fpIKtw1szrvu+SnPxe1lvco3Hj6PxZ/
	 42gt+NMuoXGNnQobYkJ7q5xwLDN9VJw8F4wmss3cxtF52jtrfrdR1IjVPaCmErozAP
	 vftA2T+Gp8OBO7dJXG18psSE37l58pBTKbkpXotQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 542/982] mptcp: subflow: no need to copy thmac during ulp_clone
Date: Wed, 30 Sep 2026 17:21:18 +0200
Message-ID: <20260930152428.412554435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
@@ -1910,7 +1910,6 @@ static void subflow_ulp_clone(const stru
 		new_ctx->request_bkup = subflow_req->request_bkup;
 		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
-		new_ctx->thmac = subflow_req->thmac;
 
 		/* the subflow req id is valid, fetched via subflow_check_req()
 		 * and subflow_token_join_request()


