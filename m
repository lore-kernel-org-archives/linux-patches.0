Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1162F260C;
	Sat, 12 Sep 2026 19:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241240; cv=none; b=h5VcVgCGrOsDOWMCQffYh1Keg2JUZvAKe8TmfpO9c0FcyDnOyPozhbGR0pW14lltixNSOcPEDS+UTY2dmz4trnSRyfbXtrRpM8Pn4QqtaAp9nN+qUkM4VXgvaOKgEoanfjjxq0/w3ZNwkSxa/Ezz0Q8OPDJYzVf8BcZmTAbFT9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241240; c=relaxed/simple;
	bh=lrT0U3RCycp/1o1WnY+wTsGFvMBLLKyovoTPBixR+yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCyeG3KUZZ9Fcp4s/8rLx6bb6hs8m7K+/RTZTzgaliphVhIPnwa6/ZHy0rvA+r6xEHyWpbIN5DRs2ZOcDTfjgSfS1xwB3APVq/+CXfJxfo4VQBnEiHyAkemVYGs3b5tHnCEvCjLW5/qGV2paNS0h8wP+Xscr0R4AW0FSxnr3f/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nmy5pZYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nmy5pZYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AD81F000FF;
	Sat, 12 Sep 2026 19:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241239;
	bh=5MhC/llfWrSve4xMZmuktJbp7Xdd9JNXNQgZ9MhmUZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nmy5pZYR44WlByHMzoa99bNNhym2GGEiueokwIsFSVTgkrL4v5nLyllg6+ruDo59w
	 xrNoU0oHRHrrr5FSdbH8+LrSODMPkRtwWAm9dox+xNsFDcQtgTLCMyEYzzoExb/6jv
	 e8mEKSv/PfwuxEcUuPPatpE53/f4G6yyraiGEju8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Varu <harshitvaru666@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 094/798] mptcp: fix uninitialized local_id in syncookie MP_JOIN reconstruction
Date: Sat, 12 Sep 2026 08:55:22 +0200
Message-ID: <20260912065519.110812443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Varu <harshitvaru666@gmail.com>

commit b878dfdd12d7a5b8722a78d35e313506140ca3d9 upstream.

mptcp_token_join_cookie_init_state() restores remote_nonce, local_nonce,
backup, join_id, token and msk from the saved cookie entry when rebuilding
the request socket for a MP_JOIN 4th-ACK handled under SYN cookies, but it
does not restore local_id, even though the SYN path saved it.
subflow_ulp_clone() then reads that uninitialized field and stores it as
the joined subflow's address-ID. Because the request-sock slab is
SLAB_TYPESAFE_BY_RCU and not zeroed on allocation, the value is the stale
byte of a previously freed request socket, which an off-path peer can
influence by sending concurrent MP_JOIN SYNs. This corrupts the path
manager's id-based subflow bookkeeping for the connection.

Restore subflow_req->local_id from the cookie entry, as done for the other
fields.

Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Cc: stable@vger.kernel.org
Signed-off-by: Harshit Varu <harshitvaru666@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260815115205.197151-1-harshitvaru666@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/syncookies.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/syncookies.c
+++ b/net/mptcp/syncookies.c
@@ -118,6 +118,7 @@ bool mptcp_token_join_cookie_init_state(
 	subflow_req->local_nonce = e->local_nonce;
 	subflow_req->backup = e->backup;
 	subflow_req->remote_id = e->join_id;
+	subflow_req->local_id = e->local_id;
 	subflow_req->token = e->token;
 	subflow_req->msk = msk;
 	spin_unlock_bh(&join_entry_locks[i]);


