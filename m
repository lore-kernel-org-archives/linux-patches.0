Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BB53229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F72C433D2;
	Mon, 30 Jan 2023 14:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088701;
	bh=HLBU4KNqp6IuKVjq9CHxpq8tYamSjs7kHgpVSZy5dvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCEUTngkrJI8wgCEUu9KfU4n0/bZdhENYfPn2S/WiA7paI4eYSRymdLl0u/BOrvSl
	 CYNvkzIHgU6skjhj1BASwl/MngjLnoTBgN3NfHSH5AT/ndXx5gm+vy/AilKlXL0Kq9
	 G0YukTby/TRHsTW539WVF3wamfOV99G0NpAWmPpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Tom Talpey <tom@talpey.com>,
	David Howells <dhowells@redhat.com>,
	Long Li <longli@microsoft.com>,
	Pavel Shilovsky <piastryyy@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 106/143] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
Date: Mon, 30 Jan 2023 14:52:43 +0100
Message-Id: <20230130134311.228076300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

commit b7ab9161cf5ddc42a288edf9d1a61f3bdffe17c7 upstream.

In smbd_destroy(), clear the server->smbd_conn pointer after freeing the
smbd_connection struct that it points to so that reconnection doesn't get
confused.

Fixes: 8ef130f9ec27 ("CIFS: SMBD: Implement function to destroy a SMB Direct connection")
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Long Li <longli@microsoft.com>
Cc: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smbdirect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1394,6 +1394,7 @@ void smbd_destroy(struct TCP_Server_Info
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
+	server->smbd_conn = NULL;
 }
 
 /*


