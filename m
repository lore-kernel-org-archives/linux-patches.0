Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C03241665;
	Fri, 13 Feb 2026 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990828; cv=none; b=exrhmsvxUomiKSTNhewFUPPYSm44pcxfxSCr8ToIfZx48qeC9hm3hIB1hK+/SOwY/fSAa2P0D9euRDKRldUly7/156JDc1FAgZHzAubkqxMFwtgdmLpxxLh0DkpfPCsDIY8NhCqkRg64tzcniWVovvTxwMTahUJOxt3Q2Li+SaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990828; c=relaxed/simple;
	bh=wgnJDBw5BBaYviCdKNa7hvfpjGghuRzp67B6arEAqqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O63U/HWCASU9IdNWVYyboyZlWyHRkYzRV9qSFwqFx8jGddTMqW6ALjbQ3u7km/IH1Fm9v/vqyzQWlMrkBt+agAceGDNfje6IhSE7F3ND6+QtC29xOJ0+gR8G3UGNnyi47cvgzlRAuhup7vN2OJQwdOUu0NRDr3UPmRi5QcNgonA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfxYGli4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfxYGli4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C654C116C6;
	Fri, 13 Feb 2026 13:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990828;
	bh=wgnJDBw5BBaYviCdKNa7hvfpjGghuRzp67B6arEAqqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfxYGli4ACVUptVwNmPjokKdrRd1l2wBkmR+MoBRlGEUTFjJCAXzw+AxhtMj2TGZe
	 tvl8Ao4FPUX9dhCSqdKAveiQQXKTedCiNaH1dUVcs13FJ+1hByNZznHoMcf8mczsR5
	 KyVQEVF1FNlaX7C4w+QFIIrqplVaRZNKwAYENS04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 06/49] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
Date: Fri, 13 Feb 2026 14:47:50 +0100
Message-ID: <20260213134709.119232139@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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
@@ -41,6 +41,7 @@ static const struct ksmbd_transport_ops
 
 static void tcp_stop_kthread(struct task_struct *kthread);
 static struct interface *alloc_iface(char *ifname);
+static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
 #define KSMBD_TRANS(t)	(&(t)->transport)
 #define TCP_TRANS(t)	((struct tcp_transport *)container_of(t, \
@@ -216,7 +217,7 @@ static int ksmbd_tcp_new_connection(stru
 	if (IS_ERR(handler)) {
 		pr_err("cannot start conn thread\n");
 		rc = PTR_ERR(handler);
-		free_transport(t);
+		ksmbd_tcp_disconnect(KSMBD_TRANS(t));
 	}
 	return rc;
 }


