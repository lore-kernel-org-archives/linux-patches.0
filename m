Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD5E23ED5B;
	Fri,  9 Jan 2026 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960646; cv=none; b=tfTtm4+yJ7Ka8Lvtu1Sbk8y07lQqNSWrFHTVBNsp7Nxxa/rFB52Ov/AnxeXBkMv/alcRi3tti9GoEEo+DQjMFA7FleDYqu8q0OBHiWKSIw2rW/E48O/IZR4GU0c6Se+Tuch2UmaHFnLdVfxyycXY2wPGtrMxcaVTmk94Tbk2aPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960646; c=relaxed/simple;
	bh=C7EL+ZDoALN2+fGG+Hh3XT8eQ4+a0CRckdZ/LC35x+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtTMHsrPdCiEJhZ2pjosuwcxNgppQ4hAkp6rjSvzubSV/ImNswSzYycKak1lBcS+M9h9fDvuW1Bn08jtfrE7Qi6JfCgodLpve+fo8ye39Zu/IsUqgGVL+Y5nwQIbA7eXRVprDWFYpzjGLmlVVDO9Y0OgOeRvNnAaYrdIELY5YGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXIQ6Biz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXIQ6Biz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70E6C4CEF1;
	Fri,  9 Jan 2026 12:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960646;
	bh=C7EL+ZDoALN2+fGG+Hh3XT8eQ4+a0CRckdZ/LC35x+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXIQ6Biz0sXNKoO5TI497i+vlC4j9NGJsDl5ljSyLjU6L6flgPhHl56w9/C1c6JZ/
	 aKZOaeQH6DmvZKNFaUwrc4MFjCRKfqjua7xCGHuZrrvG1B1ghk0JWZ/laiolkc+5pz
	 hlJ9MbdNODvOGFA//nlc7LDzy7rNtwIX8M0ZSnEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	caoping <caoping@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 476/737] net/handshake: restore destructor on submit failure
Date: Fri,  9 Jan 2026 12:40:15 +0100
Message-ID: <20260109112151.891685361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -277,6 +277,8 @@ int handshake_req_submit(struct socket *
 out_unlock:
 	spin_unlock(&hn->hn_lock);
 out_err:
+	/* Restore original destructor so socket teardown still runs on failure */
+	req->hr_sk->sk_destruct = req->hr_odestruct;
 	trace_handshake_submit_err(net, req, req->hr_sk, ret);
 	handshake_req_destroy(req);
 	return ret;


