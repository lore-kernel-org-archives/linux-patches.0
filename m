Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210661;
	b=ycn6qx2iT8TGsnRLp36iErievW1FuJA2OLyRZA8MNQ72yf3laMM4J/F9ZWkoCZ313yiv
	 6zlgEoTxilbMYYMPjAPIiRUXdp2LaKpXEsej8xz6rroaceuTEHE+PHgYZHB5Vkj6O7Ipw
	 YAMwhAzdmoQIlPljtcEgYgZNr5zlAe6+SrFWnIQbHkb+rC52bsO23pSbC1Lank05spQSR
	 WyhdV0qFFsIhz6onT5RWYgSD8z9m2q68V5jcnYxH9kgoZ9HAJEZ1yDLNlQh8al7OKCYxG
	 warUkbIyM13eYb8g0xYXJ6JJB39pBgMkLt7M4g8dEsVFC5bJ94JCVP7ZOO73Mtb6ZdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=13AFdaBu4dm01pYUbfIMEOmTPtcFUtEg+Iv6Sj6ODqU=;
	b=uQqv4Uxcj/W4LO8HaaSc6rcbZyxtAbwySuLbU7QxW5edmHLXmBL8BaDuAJctxw3hcktt
	 06lEMMfQ7Pg1Ld4UT25llxkiCddcmIW7/e8a0jxF+MLOmvMH0/zq1d/QMP2xYfBjbt9/l
	 lLvteHsXcZstVtIH66wlhq93pMNO+v9IATX7LrMdbiRrNfLSvT0xG2yr+nCS/Ztr9D95T
	 Ct+rOR+kHPfP1pg+FZIuZ3A2nMqOYoso9lCaBKEk2sS0ItEZntRBBOK8HsyD76f6hxRUW
	 zy6RUdurWcpmRedYufbHIM4eA25wtlOLTRqAH1XP1YamQLhmJGZhW5r/rjyMRozmgdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=noLHDI3q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F00606A334;
	Wed, 28 Oct 2026 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=noLHDI3q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B15F1F01828;
	Wed, 28 Oct 2026 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210660;
	bh=13AFdaBu4dm01pYUbfIMEOmTPtcFUtEg+Iv6Sj6ODqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noLHDI3qLvXrEz3UZ2YhsKG9OBIUUzIIgP5K3U3JoPpNEmm3UkVAy4UjKKGG2Z/f3
	 wZ9jSBXFc0anFBpyzOCcYv5bOdcVIw1piohHKw3WJgUD7X015MICc3qA6LP+bvXeXY
	 /+wyB3JLU75zjnAykSXw9p4l2NycVe057zJHsjkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/571] smb: client: fix smbd_connection leak on cifs_get_tcp_session() error
Date: Wed, 28 Oct 2026 17:54:11 +0100
Message-ID: <20261028170010.488256996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit e75c96157d45e498970158c8f7373d90102e33b9 ]

When an RDMA connection is successfully established via
smbd_get_connection() but cifs_get_tcp_session() later fails (e.g.
kthread_create() returns an error), the error path frees tcp_ses
without first destroying the smbd_connection.

Fix this by calling smbd_destroy() in the out_err cleanup path before
kfree(tcp_ses).  smbd_destroy() safely handles the case where
smbd_conn is NULL, so it can be called unconditionally.

Closes: https://sashiko.dev/#/patchset/20260912165503.521597-1-pc%40manguebit.org
Fixes: 2f8946464b11 ("CIFS: SMBD: Upper layer connects to SMBDirect session")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d35474b836007..a91d3f6ae5be6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1574,6 +1574,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
 		kfree(tcp_ses->hostname);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
+		smbd_destroy(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);
-- 
2.53.0



