Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F3D28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00639C433EF;
	Mon, 30 Jan 2023 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087457;
	bh=py5Id8UF3tih0zkrTCVFvCxcpXEDE+FhXYVN0vEAASc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ful1tj+TcZDgxT2ftpFUlpcxSpIkv366yeQI56yu88Sy4e+3o5qYOVpkxdwaxWhDg
	 67pULYz+1YOun7KwNqXM0CgzajP1pyIoAPKKwh02uzQcdG72MRGRobwjboHyxgfV3G
	 uxrurgZS52+G4g+VWSZPp6JbgR1EwwlI7C/1v3nA=
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
Subject: [PATCH 6.1 215/313] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
Date: Mon, 30 Jan 2023 14:50:50 +0100
Message-Id: <20230130134346.713955296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
@@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
+	server->smbd_conn = NULL;
 }
 
 /*


