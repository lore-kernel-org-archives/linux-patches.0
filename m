Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A93929A1;
	Tue, 17 Feb 2026 20:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361189; cv=none; b=hyZGwkTosUZQl1PGkNJV8ZdP7Wkklan2BBiP3/XW/xPGDuW396ZWq4QbeSCm/g+sE7+iHYNIwn61eaeK9jAErwxWc9rp999xXhaf0Otw2GzC9veTtrBAhN7Qb2OglS//bIfu44bCUHMvbFZ1nwWKh4wPmsDOay3SnE2LkPEUXws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361189; c=relaxed/simple;
	bh=WbPBKDKpU5KfDleKmVfH1j31oNANrddv6I+1W4o/r34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEIzLWfbdoaBo6ernSakdUTkn0MCNnRCynAu37JIe5iX00sYUpZLOn++phURfipoJMc9GpjdrKJJcfgJ0qsa9w029ATETKNQh6Ug2OKYb6mH27/XtkjzT/m/nS8e61QGl+EpAq9ewgm3fpc17qFKkcqpfuISow8Ww1SnMIIa23Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9gw/HnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9gw/HnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA59C4CEF7;
	Tue, 17 Feb 2026 20:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361189;
	bh=WbPBKDKpU5KfDleKmVfH1j31oNANrddv6I+1W4o/r34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9gw/HnN0opdU8JPGEwLeBwg9+77Ec6/wB7QYivuChiRosOJpFWxEaf8AMIct5QgI
	 GDLVoqYfIewE000WgHPGyoIxKVFfJjeVFCrSB9RxAi0IABHYn8YQwTYfQUlrtZ42P3
	 /qLNvEXm6uNo7vicDTxGR5iHVC93fUJztHa/FeC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 03/64] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
Date: Tue, 17 Feb 2026 21:30:59 +0100
Message-ID: <20260217200007.637508319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 77ffbcac4e569566d0092d5f22627dfc0896b553 upstream.

On kthread_run() failure in ksmbd_tcp_new_connection(), the transport is
freed via free_transport(), which does not decrement active_num_conn,
leaking this counter.

Replace free_transport() with ksmbd_tcp_disconnect().

Fixes: 0d0d4680db22e ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -41,6 +41,7 @@ static struct ksmbd_transport_ops ksmbd_
 
 static void tcp_stop_kthread(struct task_struct *kthread);
 static struct interface *alloc_iface(char *ifname);
+static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
 #define KSMBD_TRANS(t)	(&(t)->transport)
 #define TCP_TRANS(t)	((struct tcp_transport *)container_of(t, \
@@ -215,7 +216,7 @@ static int ksmbd_tcp_new_connection(stru
 	if (IS_ERR(handler)) {
 		pr_err("cannot start conn thread\n");
 		rc = PTR_ERR(handler);
-		free_transport(t);
+		ksmbd_tcp_disconnect(KSMBD_TRANS(t));
 	}
 	return rc;
 


