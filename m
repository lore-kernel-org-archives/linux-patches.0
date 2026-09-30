Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA453CBE6E;
	Wed, 30 Sep 2026 19:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795877; cv=none; b=uac9rPUVEWCoBya4gQsWa8d5wEHYZs8aIKjVwE7jjCTms3XqIhKzPIsYtBnLM0uK7xUpBsexx04XyzQkC65v0hLCM85BOys38zbKRE6oaF4bBx3COnMJwmyi4v0aJXV7lyXyuYWVIdVA6bVYCyBNNlb6jA11uypVKQRF5iT4stk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795877; c=relaxed/simple;
	bh=pArNHCd3RmzlQc45NPqkHIODDhswcQ8nOWKAGAIoJ4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3Ki7otgrVRwquKrXmiUj9oXb3jlbTiGXYTGqByrCTF7ZwR9nKw6S/pI5UvwOSRtMq0+tWkpCMUPHp5+jbg+4G1xZ3Fqi+Xjc10kZ14RsOTsm80txfbWmXrX7ApZy7fxLETOft9tHxF/YPz9YCp+2Dkq7dCCsUOPNvj5Ara+7KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxIrUiy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxIrUiy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA7B1F000FF;
	Wed, 30 Sep 2026 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795876;
	bh=Y5fXTH8KAfdVuW4G0Zf6BPrZydbDdiH61cs0zvT7Xzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxIrUiy7rdoCmy3Qe9+P22252kO84WqgRv97xupKzNF/waWBIpMQSuc7iAGSoEwRI
	 xQH6HMfUaTTvAQHCkf2Dqp4JTT9zn++t4zPHDzqepb0d33liNZ3MkOvvPktng2Z1sJ
	 03BXt8hpu1mvb0DU3Rr+Cmrt9gxSCqsQMpEVTLBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0660/1193] mptcp: subflow: no need to copy thmac during ulp_clone
Date: Wed, 30 Sep 2026 17:22:24 +0200
Message-ID: <20260930152448.902309665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -2011,7 +2011,6 @@ static void subflow_ulp_clone(const stru
 		new_ctx->request_bkup = subflow_req->request_bkup;
 		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
-		new_ctx->thmac = subflow_req->thmac;
 
 		/* the subflow req id is valid, fetched via subflow_check_req()
 		 * and subflow_token_join_request()


