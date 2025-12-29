Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5321C3328EE;
	Mon, 29 Dec 2025 16:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025871; cv=none; b=kHanz9H1vVR4aXAC3D1Lgsj/ElLkomjn4iWuyBQtZl879eLuZ6pKSj4h9r30tv2iDyQ1rgWfOeKd1DSaccp4nRlyEQtIXPoeoBqUjUMImkAp/3QLKMNUQxdPCvXk5ztc54zEjlXSTDQHsX+2JRunD+bB9xOjupQFpg3d07nghv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025871; c=relaxed/simple;
	bh=klyAlUq4GGa80t4zKC3Jwjb3nEIjIpmKSeQaCVP9uv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/2L64YYf4H4Bqp5Ss03WH7xxN/cXlBKs7DRVMMvimE5Owa6rSQwKqLCEcbCrnB0suYdn5uwmMt/1HSDwu9EAC6mx7V6wfh/5H9K4fpzs0/zAWFXCqMv1uCAq/stxcnsWUFD0FPqie78cF3P0hhKiP4sgnMBt1jBBBosMQHC+hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2nYYQSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2nYYQSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D3AC4CEF7;
	Mon, 29 Dec 2025 16:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025871;
	bh=klyAlUq4GGa80t4zKC3Jwjb3nEIjIpmKSeQaCVP9uv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2nYYQSRq3o/fZErg4V10/v8RM/L1Rjwy9OoMFFijaDZ5s1McmCTJEjQ4jcpm9Iht
	 xFcT9hOq5xcsttMgI341PTDHvW2hMacFUJimriVb0b0EAonhby5dc9mbet6KOZuJe9
	 NGoPv+9X9Kdyei0d9GJZh0XPREE1O8oFhGoH4egQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	caoping <caoping@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 366/430] net/handshake: restore destructor on submit failure
Date: Mon, 29 Dec 2025 17:12:48 +0100
Message-ID: <20251229160737.795909503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: caoping <caoping@cmss.chinamobile.com>

commit 6af2a01d65f89e73c1cbb9267f8880d83a88cee4 upstream.

handshake_req_submit() replaces sk->sk_destruct but never restores it when
submission fails before the request is hashed. handshake_sk_destruct() then
returns early and the original destructor never runs, leaking the socket.
Restore sk_destruct on the error path.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: caoping <caoping@cmss.chinamobile.com>
Link: https://patch.msgid.link/20251204091058.1545151-1-caoping@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/handshake/request.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -276,6 +276,8 @@ int handshake_req_submit(struct socket *
 out_unlock:
 	spin_unlock(&hn->hn_lock);
 out_err:
+	/* Restore original destructor so socket teardown still runs on failure */
+	req->hr_sk->sk_destruct = req->hr_odestruct;
 	trace_handshake_submit_err(net, req, req->hr_sk, ret);
 	handshake_req_destroy(req);
 	return ret;


