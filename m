Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22F23A255A;
	Wed, 23 Sep 2026 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174029; cv=none; b=M8VPCi5smaISoliM/fFZ+ho5k6uHE3LDHrXfT8fIdAeZfs9US9bFZibO/fzPOk5IAw5ADtAzuP5qaEhg/4mecbsc4YyZXRUVKrh5vc7mbkCu8Lg55NIbhW21GaAJp9YNeM+JhzzGh8kX7GCqPNyxixLbZoiIGN7Yt2bE6Ra46NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174029; c=relaxed/simple;
	bh=3iVFF26OftExikvzTC7W2OGMBG+SWZoMMTcN/F4PrJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQTyrGwP442fDwon7Nm8UYBcPywhJb4ryd90Yxo/eLlSyeDcgoIIPBTrGTJzC/uWzj5BZfGyEAHmeQ7O9aQEJvsyG9ivGyCt4p+zw3/XVF+Oyo+JRSBYKImO5TR25grwwrxGuRKySC/MlfWppZ5gWhcR/7mQdMOWn2hjtR4ebsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2Ae4U+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2Ae4U+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEF41F000FF;
	Wed, 23 Sep 2026 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174028;
	bh=1dr4nkh2IUXT7ZLRynxykIoVEel+RpEztXxcsA/aEeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2Ae4U+P1RXIDNB5sSplxu1UC0SHVRuVX/JU0d52FNiEJafw/Fm/wnpYv4bf2OapQ
	 0kdO9SEh3813dz4wFP3LDLcRM1xwJg7KcrYTcnnLT7I6N/sVew5IcS3bCodxBUyWh0
	 JkhZ9hRrdJOotqBiRo2OwUbs4+mKHfzJx7+ezcuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5003556314abc915a71f@syzkaller.appspotmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 413/438] smb: client: cancel reconnect work in clean_demultiplex_info()
Date: Wed, 23 Sep 2026 16:07:14 +0200
Message-ID: <20260923140655.613635401@linuxfoundation.org>
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

commit c65eae6f61d1778ff7a82e4aae4080e26f486af1 upstream.

clean_demultiplex_info() cancels server->echo delayed work but not
server->reconnect, which can cause a use-after-free when the
demultiplex thread exits while a reconnect work is still queued:

  cifs_demultiplex_thread()
    cifs_readv_from_socket()
      cifs_reconnect()
        __cifs_reconnect()
          cifs_queue_server_reconn()
            mod_delayed_work(cifsiod_wq, &server->reconnect, 0)
    clean_demultiplex_info()
      cancel_delayed_work_sync(&server->echo)   // echo canceled
                                                 // reconnect NOT canceled
      kfree_sensitive(server)                    // server freed

  ...later, on cifsiod_wq:

  smb2_reconnect_server()
    server->srv_count  // UAF read of freed server

Fix this by canceling server->reconnect delayed work in
clean_demultiplex_info() before the server is freed, the same way
cifs_put_tcp_session() already does.

Reported-by: syzbot+5003556314abc915a71f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6aa4a12d.f81106d8.2ab401.0023.GAE@google.com
Fixes: 53e0e11efe92 ("CIFS: Fix a possible memory corruption during reconnect")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1067,6 +1067,7 @@ clean_demultiplex_info(struct TCP_Server
 	spin_unlock(&server->srv_lock);
 
 	cancel_delayed_work_sync(&server->echo);
+	cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;


