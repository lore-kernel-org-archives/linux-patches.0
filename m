Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0CC175D53;
	Fri, 13 Feb 2026 13:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990638; cv=none; b=buGoa0PwzWJ/n66Lv7Bw3cbapgpc72+YvorpT6RiYkubkgUaJB+vMdDtaulPLNXXW+rXAxrFxr9wm6hWbgJ1wllt7w7HMV6grJOHRKzrOTb2iay0k+lDGc6EFrlMNp9e5pN5+8LAoqTGiwKRZdVAIkqRMOV6vKb5iP9Pqdkux3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990638; c=relaxed/simple;
	bh=yr0g/3rZP8HLMCmy16q+UPE7zyc1ciOXrRMmalSwLjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWfESVHqS01wGS4i4wQTKcEbcSyQv6YkvCfQJrlhidi5h1dG8rouSWLrSqGzLItHugdd8o+QO3H7FRMy1Dg5XWy2OOxTwI727X2EJDQ8k0b8GQlW9M1OeNds6NrXs0YaymXyKeVxK6g7yX09NaFaThz1lKqg7TrW2JsYmeRrLRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb5ezU2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb5ezU2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583E8C116C6;
	Fri, 13 Feb 2026 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990637;
	bh=yr0g/3rZP8HLMCmy16q+UPE7zyc1ciOXrRMmalSwLjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb5ezU2GAsnA8se5alXO+rR3GPWK0g+ArLX4f/IB1I7hWOQAqGN+9dB/d6y69IXWW
	 uSCK5Fwugxq8yrY0yxX6LgwxnvGWcROoacsiyg93ucGOBd9PF+GIf7MOh/VNr3YqWn
	 4o0PlGGLSRFnKdESR2fo/OyVWghBXMApbj4nXcRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 06/49] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
Date: Fri, 13 Feb 2026 14:47:25 +0100
Message-ID: <20260213134708.959096579@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -40,6 +40,7 @@ static const struct ksmbd_transport_ops
 
 static void tcp_stop_kthread(struct task_struct *kthread);
 static struct interface *alloc_iface(char *ifname);
+static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
 
 #define KSMBD_TRANS(t)	(&(t)->transport)
 #define TCP_TRANS(t)	((struct tcp_transport *)container_of(t, \
@@ -202,7 +203,7 @@ static int ksmbd_tcp_new_connection(stru
 	if (IS_ERR(handler)) {
 		pr_err("cannot start conn thread\n");
 		rc = PTR_ERR(handler);
-		free_transport(t);
+		ksmbd_tcp_disconnect(KSMBD_TRANS(t));
 	}
 	return rc;
 }


