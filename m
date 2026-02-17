Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED093378821;
	Tue, 17 Feb 2026 20:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361045; cv=none; b=eBY3XclLpS0kq3TvT2itNgUYVbJj32bRQ7CXcoOALULtl8+hsc/EiyHKxV2rB9PLcaVoI9ay2IyyqfVWhPD6Djo7/n+T1lK51CIcKlFC/NkJJ5SHdn4ialTyNIzk25/BtGSAZfAoBrPDAgoJA4w5m3R57mq+S6fz4vrn/PBRBuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361045; c=relaxed/simple;
	bh=FnP3Jf+0GQvq1MYbk09xUozouieg3HeBVfjX2wfnwTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6ryvnsa7aagldGdsAKnyp8+POxsc61cE2xAI4gBZP1u7Uuh+fD1x7xUu5vLUK+qOUtzcs3wYcTup5/GuTUEKY4ZqCYtrpXpTFHPkuo26EH3L4kmLLXA4GYBBsSTI7nSOTVQhs+nNiJky7IYazQVO9J5ljO7xjxubTV4YlMoujw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFkgsYyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFkgsYyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE8AC4CEF7;
	Tue, 17 Feb 2026 20:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361044;
	bh=FnP3Jf+0GQvq1MYbk09xUozouieg3HeBVfjX2wfnwTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFkgsYyz5DquXitegVEw8qiSsv9F6fBsuUaY3D6rFKOEC5yRkFrs2xarGH9O96t0v
	 kuzLcn7cWjBrvdM5DxRmUCYd2uhcAF9vAHrGl6cF41cIMhlAH6LhGo/7+UD9Li05kE
	 vwDvKJz+XgCN7ZHy2n1FzWQJ+26XQgVqVHoWotbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/39] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
Date: Tue, 17 Feb 2026 21:31:33 +0100
Message-ID: <20260217200003.862311717@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 77ffbcac4e569566d0092d5f22627dfc0896b553 ]

On kthread_run() failure in ksmbd_tcp_new_connection(), the transport is
freed via free_transport(), which does not decrement active_num_conn,
leaking this counter.

Replace free_transport() with ksmbd_tcp_disconnect().

Fixes: 0d0d4680db22e ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -41,6 +41,7 @@ static struct ksmbd_transport_ops ksmbd_
 
 static void tcp_stop_kthread(struct task_struct *kthread);
 static struct interface *alloc_iface(char *ifname);
+static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
 #define KSMBD_TRANS(t)	(&(t)->transport)
 #define TCP_TRANS(t)	((struct tcp_transport *)container_of(t, \
@@ -207,7 +208,7 @@ static int ksmbd_tcp_new_connection(stru
 	if (IS_ERR(handler)) {
 		pr_err("cannot start conn thread\n");
 		rc = PTR_ERR(handler);
-		free_transport(t);
+		ksmbd_tcp_disconnect(KSMBD_TRANS(t));
 	}
 	return rc;
 


