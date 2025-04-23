Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD50B29A3D1;
	Wed, 23 Apr 2025 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422451; cv=none; b=g0tIk3MK5k6VGjdsXLGQKOio66yilzPaZopn9O4PWsz1J157Jgk48k+S0QCsVHk0QRHu4X5qyXNr+alLUsoTIgnVKnTRAXzEpT6YAlYem1FFNbhR3C0UGCxitl+EshbjCV9aRsrxq4iIE/uqwj0vaCfXD5QZrBrEC2m649fowEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422451; c=relaxed/simple;
	bh=vCvuENb1ko4Poz1+WRo6EEqm4WcbUq0+vCxijuW2F2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfTv9C4XYuXYJbAiAEvCxCXQiQMpbKHIO2Ebr8ZAVDEkYrc2Xk/ZaeyJrX6e/8C/0xUAMhy4JQIuMv9EqsUev/2xglDcDEDB2/0l0FsGr+trtA5cb4lvZ08sj6kiBJdge6e+AvRRq5tyZOaW6jq0kZ+kDjocxiBPY6olKBRosz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4WMRErj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4WMRErj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409D2C4CEE3;
	Wed, 23 Apr 2025 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422451;
	bh=vCvuENb1ko4Poz1+WRo6EEqm4WcbUq0+vCxijuW2F2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4WMRErjC3fe+goRy16sE4AafCUqG66KRQjMktNn+LqQ4tN1oAOOuv7c2v4wyrCVu
	 XsNuc1wN6IOLGJtHdDX6FzNc4fjHxgBfoybz5d7NohUgLsBvktP9dwiTw2l6aM27BF
	 p1zq6lM4ensECG6bgt3yeFMMGFzD0t3Di90hO02s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 328/393] Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"
Date: Wed, 23 Apr 2025 16:43:44 +0200
Message-ID: <20250423142656.883584756@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit c707193a17128fae2802d10cbad7239cc57f0c95 upstream.

This reverts commit 4e7f1644f2ac6d01dc584f6301c3b1d5aac4eaef.

The commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
rmmod") is not only a bogus fix for LOCKDEP null-ptr-deref but also
introduces a real issue, TCP sockets leak, which will be explained in
detail in the next revert.

Also, CNA assigned CVE-2024-54680 to it but is rejecting it. [0]

Thus, we are reverting the commit and its follow-up commit 4e7f1644f2ac
("smb: client: Fix netns refcount imbalance causing leaks and
use-after-free").

Link: https://lore.kernel.org/all/2025040248-tummy-smilingly-4240@gregkh/ #[0]
Fixes: 4e7f1644f2ac ("smb: client: Fix netns refcount imbalance causing leaks and use-after-free")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -316,7 +316,6 @@ cifs_abort_connection(struct TCP_Server_
 			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-		put_net(cifs_net_ns(server));
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
@@ -3150,12 +3149,8 @@ generic_ip_connect(struct TCP_Server_Inf
 		/*
 		 * Grab netns reference for the socket.
 		 *
-		 * This reference will be released in several situations:
-		 * - In the failure path before the cifsd thread is started.
-		 * - In the all place where server->socket is released, it is
-		 *   also set to NULL.
-		 * - Ultimately in clean_demultiplex_info(), during the final
-		 *   teardown.
+		 * It'll be released here, on error, or in clean_demultiplex_info() upon server
+		 * teardown.
 		 */
 		get_net(net);
 
@@ -3171,8 +3166,10 @@ generic_ip_connect(struct TCP_Server_Inf
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0)
+	if (rc < 0) {
+		put_net(cifs_net_ns(server));
 		return rc;
+	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3218,6 +3215,9 @@ generic_ip_connect(struct TCP_Server_Inf
 	if (sport == htons(RFC1001_PORT))
 		rc = ip_rfc1001_connect(server);
 
+	if (rc < 0)
+		put_net(cifs_net_ns(server));
+
 	return rc;
 }
 


