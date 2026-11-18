Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044055;
	b=UijE604RJoqxKOnoE7rMs/wtQCp8KiBInny3WhpN0yyJWKoo7b8H2uve09rwD83Dy0zu
	 EXDJBNk5NNJ4jJvtpsVr5LW6Z2qQqsDPSE+IuPnYE/yn0RTuKoIZHgst4tWv8Jzhq/xJy
	 Dmp+iFVUK7JGX8ivz2gfPHWf/85quB4y42jiu01m8F2MaC6ZvDD+AOllNh4BKmWzTWn/7
	 tu9M4KN7czzVj+aOw6acN9NZSMWELzDKiZQGt67eB+dvR9BsPfcEjCFuQk1LGhJmuy6sC
	 Tm4nlKxu4A9gKl3vkIBjUmaZdcVcffft3dt5fgPQz8Vf71ffp2l+Hss5inpohm6Vxgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6IF12l551nPEFokPXeAMxC+CM20LfaKhViDBV3s7FM=;
	b=zZJTpC5KVaBUPTSmV559LVaZVWndY0sUZ6Iernoa2+6EgWvPyQqNLwmS2HFcPQcbBbSA
	 u2i90uOP/LzyDc6xaMvZgH8hlG+StdQsWlGaHFLd7YNoJhrczjtMfX95lpDwLiAXS1bcG
	 mS5+rVLqKLbQhdBUjGheibTMIzrEXkw05EEixLJeCIgh2ciyhrK8UsJD11slpD0Viq10e
	 Xau9UhAWcbGkZEAOv5tR/0reaSrhqRP1ewMIfk48xVw6+0cg+8DozJkvwfP7R+d5FocFo
	 AsSi/aHFRpNMXJNdeetrr1fMMBE2mLoXURLzoyOib947MDLBXzbTK3PPQbfBHXO8dug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vM/Bjd+k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5F0606A325;
	Wed, 18 Nov 2026 23:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vM/Bjd+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122451F000C4;
	Wed, 18 Nov 2026 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044055;
	bh=K6IF12l551nPEFokPXeAMxC+CM20LfaKhViDBV3s7FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vM/Bjd+kHPRob7GZhjXbO8ldcTdwGtQYKF5NFG7Gmq+ee+gTXdZ9CYlVMDGzZDDfl
	 l9IAcUXr9Vd/+GprOAkVwi3BtnB926kBR3xFajAEKqVj8tjBRCvwLl92O20x16A9Bm
	 qvUu7mLqkxE598g3yEZ4tu/9gxWwVsbNwQoAKU+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0431/2857] smb: client: fix rlist race and missing initialization
Date: Wed, 18 Nov 2026 15:24:25 +0100
Message-ID: <20261118150216.902215351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 5f270f091256da1338c3631083e15d7f83cc05e1 ]

TCP_Server_Info.rlist is allocated via kzalloc which zeros both ->next
and ->prev to NULL instead of pointing to itself, making list_empty()
always return false and list_add() dereference a NULL ->prev pointer.

Also, cifs_signal_cifsd_for_reconnect() can be called concurrently
from multiple cifsd threads, allowing the same server's rlist node to
be added twice into the local list, corrupting it.

Closes: https://sashiko.dev/#/patchset/20260911204446.1719356-1-pc%40manguebit.org
Fixes: df0e03a4fb94 ("smb: client: fix potential deadlock when reconnecting channels")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 6d3f11372440e..157d947846d9b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -195,6 +195,8 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				nserver = ses->chans[i].server;
 				if (!nserver)
 					continue;
+				if (!list_empty(&nserver->rlist))
+					continue;
 				nserver->srv_count++;
 				list_add(&nserver->rlist, &reco);
 			}
@@ -203,11 +205,15 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 		}
 	}
 
+	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(server, nserver, &reco, rlist) {
 		list_del_init(&server->rlist);
 		set_need_reco(server);
+		spin_unlock(&cifs_tcp_ses_lock);
 		cifs_put_tcp_session(server, 0);
+		spin_lock(&cifs_tcp_ses_lock);
 	}
+	spin_unlock(&cifs_tcp_ses_lock);
 }
 
 /*
@@ -1762,6 +1768,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	spin_lock_init(&tcp_ses->mid_lock);
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
+	INIT_LIST_HEAD(&tcp_ses->rlist);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
-- 
2.53.0



