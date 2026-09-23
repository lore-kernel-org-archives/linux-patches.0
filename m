Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254243A255A;
	Wed, 23 Sep 2026 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174045; cv=none; b=qEo9xq/VRiCEOysFcoNtbRtLouJ/nV1mMKUUEZmAEX6+3DRaqpbUrJxjP32phnC05WWhitSzONFpkRH1s8JoX3AXtEmoux9ZqhBkUlYKd0CTdYRxqGbJlYyZaRF26oemOQ/ikyWMsHfS/ZD0lsm+UxwQknN4x8MeOwE00Uf5+jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174045; c=relaxed/simple;
	bh=Vq0chztUUNLSqHPS093T0k4uhR41QaMiLzXvZXQic9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFg7mDUGKD+/tn2yyzyYXGnuBnzs0xJFQnrbAHBDZR83UhI7QtBEgQnfW8ksa+Esw/WAWY0U75xn/1XiRhQvawYzl2FzwdcGVc+TwDYAXC7mrEUy0tmRYwALiyq8kbcSk7SWtfUMB6HTFb9tg5rmI/AxaaIp1KyVvRUnOpDZNp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxXaPurH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxXaPurH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CB71F000FF;
	Wed, 23 Sep 2026 14:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174044;
	bh=L2KTgzoGbRlfKCxS1XatJ/Dovyuze+H218WddRSTldY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxXaPurHt5jagXPhZtZ4J8pVOQS1297PnfxExql4u3f6Q2u33cWfVjY9K7++t1sgG
	 /Sf+22EB7gWpHmYBBz8YHx3E6KH8tVGMkeo+Pj5afEKE2nv7sjxrJgfoMSd+clFx8n
	 R5pQVvBGAG72yUyrxoKxWbqxj/NZJ7psE0TTcY9w=
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
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 418/438] smb: client: fix smbd_connection leak on cifs_get_tcp_session() error
Date: Wed, 23 Sep 2026 16:07:19 +0200
Message-ID: <20260923140655.745894618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit e75c96157d45e498970158c8f7373d90102e33b9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1934,6 +1934,7 @@ out_err:
 		kfree(tcp_ses->leaf_fullpath);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
+		smbd_destroy(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);


