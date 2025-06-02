Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B339322330F;
	Mon,  2 Jun 2025 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875922; cv=none; b=BGPubq5ZsxMYc/MRY3aXcDk+S9n+3D9/LEIdvotwiNMRZwXAt7NzRTAEcAKbUmR483pin1ryGDsbl068tRNuHZTWTxRaUjZyJayNnAPiT4dddmZGUwLweMfakqaWG2obTaSu6bR6WRCdktZppzk2CxX5nzVxeIqltR0cmhXf4ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875922; c=relaxed/simple;
	bh=0Zd9efVg3Iqo6CukTrCBoCidUy7gYCFsrhch41FQUuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOMX47EWoIkub6u6D6+qkA5uEvwi7C33Bt4VeRrSWhtosWcBnUYY/EBXbR6/A4PdvUpSxHqYUJlaVF4dQOii/0INy0GobM9VxtuvGPhzU6KoSl0L3nEnU3f5rZ7qGwcqSpQ/NahvazI2oKf65M9U0rdZ0LjdJ5uCR+gSCRsEO3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+LyvEu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+LyvEu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2402BC4CEEB;
	Mon,  2 Jun 2025 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875922;
	bh=0Zd9efVg3Iqo6CukTrCBoCidUy7gYCFsrhch41FQUuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+LyvEu6XXUIhYE3N4hfGN8sqE/wTIPy/1Rctsml7dkZl0PQCUaZLwgyUSxO6MvMj
	 IglKH7+0fPHxVttpwLCnZeJ8A9SUYIG05d+HADofrAqUH576jpwdofNRADR+JYUHdh
	 2168A9JUcrKOEizBXWsl9/VpTXY+MwtaS21dV4e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/207] SUNRPC: rpc_clnt_set_transport() must not change the autobind setting
Date: Mon,  2 Jun 2025 15:46:28 +0200
Message-ID: <20250602134259.409770155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit bf9be373b830a3e48117da5d89bb6145a575f880 ]

The autobind setting was supposed to be determined in rpc_create(),
since commit c2866763b402 ("SUNRPC: use sockaddr + size when creating
remote transport endpoints").

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 5de2fc7af268a..48ffdd4192538 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -275,9 +275,6 @@ static struct rpc_xprt *rpc_clnt_set_transport(struct rpc_clnt *clnt,
 	old = rcu_dereference_protected(clnt->cl_xprt,
 			lockdep_is_held(&clnt->cl_lock));
 
-	if (!xprt_bound(xprt))
-		clnt->cl_autobind = 1;
-
 	clnt->cl_timeout = timeout;
 	rcu_assign_pointer(clnt->cl_xprt, xprt);
 	spin_unlock(&clnt->cl_lock);
-- 
2.39.5



