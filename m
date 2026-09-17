Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BB74F4D01;
	Thu, 17 Sep 2026 17:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666543; cv=none; b=jFD8eyQ79xHhOnvDUMaWx/SWlFzN+3RP8k8nhuhzdYaiQBgeRSE+X0sBojAYgUEG0EV7uys6wGHTQM91HFoJfwaTunM5za3UV3HO3C8EVYIZ7pRZYQ31tcCnTCMp/5cjdyERDWaCwmhorYkZn3PveDtBRk4+2eO0y+0k9nxYv7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666543; c=relaxed/simple;
	bh=ES5iv+RDGIRe25Nz2LzU2GVCV5SleMlzw3rOkQZMdro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfowwO0dtRssLJVYc6YvbIRWX3vzZurKO1X3X6lOX7lO2d+Gpt/U0VmIZVhfRSTIoL2bKgmdvZLGYjFoUsHf2aJHpjh5N+W9AICl9nxHshRQ/aJzLxQEMmzLk5cKMcVaTr6jNuFrRw1m5MYA3b8yLSSbSOkGOlEHjyAqTAk9Wyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jt6Y6G8R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jt6Y6G8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA55B1F000FF;
	Thu, 17 Sep 2026 17:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666542;
	bh=TncbrQCN8EPNZRjh38q0m7QeHOPL4RF29644VW0YRWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jt6Y6G8Rzrvt2BsI/ZZ8Pgi1ERxfrEX4o/uXlrwK9cecraYGaBnWQVEQQyS+PI/sn
	 bVxFF78jOg8V0R4mnUQ2C+EGcj/ik1iNEHz6eQ+QlqkDJ4h7tWopZULhG5MAya2Gb5
	 SpMpsXLxiRdyqxVpNtWELZbQgYh+NaGEAQ/GYvW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1073/1250] mptcp: subflow: no need to copy thmac during ulp_clone
Date: Thu, 17 Sep 2026 16:14:28 +0100
Message-ID: <20260917151621.221043053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2065,7 +2065,6 @@ static void subflow_ulp_clone(const stru
 		new_ctx->request_bkup = subflow_req->request_bkup;
 		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
-		new_ctx->thmac = subflow_req->thmac;
 
 		/* the subflow req id is valid, fetched via subflow_check_req()
 		 * and subflow_token_join_request()


