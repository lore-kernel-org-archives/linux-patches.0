Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C7917B421;
	Wed, 23 Apr 2025 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420371; cv=none; b=pQHZkkM6kqrctwps1g2lfq+7iz1ZYJeDlilZue/VBVtTj8w3dNgky9pY/o7/090h32ETktyqg6ZVbqAAXUopAe0RyNWaaIj2b8c7DpGg/132pJwvs4Kz37f/Q+C0iaE2HfJiM4d029EcaIH6QFfFxmCPBYdJmqJmw2lJ5AUFEuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420371; c=relaxed/simple;
	bh=RKNq6EOjSx3hkYWVDPrFsuDWWRkThrOQgtHW74NgEc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0Fsa4dgTTQ1I6noSpANoazsy5dkNWrxfJFr38hWF7QazkAdDHLGftiIZyIzNhOtgoO36CpSSeu4Fmt1Q68yNdYBVVvFj9utAKQdxAOR6IqUXif9eVS1H6DdycIm6LWHFOvwX0gp5QTzzCi5N/TYmOsYQSbNm412+WwbrDfZhj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy02rAJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy02rAJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A4DC4CEE2;
	Wed, 23 Apr 2025 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420371;
	bh=RKNq6EOjSx3hkYWVDPrFsuDWWRkThrOQgtHW74NgEc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fy02rAJ4QZ0BGPplNJOlh/CG+faiSK2tiMTpgoKaPHFaXGKcko52A/hDEMoYqqlcB
	 sdceWrnzb0s0mXgC/u9nJQ/vJmb8FTd6gUVSd1UkXXf5FwzGcDbv7i8JhXrrMXE9Se
	 JrSbi49v6D5I9oHAzQ0LwCP8W4t39clY2+0pwPEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 126/223] Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"
Date: Wed, 23 Apr 2025 16:43:18 +0200
Message-ID: <20250423142622.232460003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3142,12 +3141,8 @@ generic_ip_connect(struct TCP_Server_Inf
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
 
@@ -3163,8 +3158,10 @@ generic_ip_connect(struct TCP_Server_Inf
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0)
+	if (rc < 0) {
+		put_net(cifs_net_ns(server));
 		return rc;
+	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3210,6 +3207,9 @@ generic_ip_connect(struct TCP_Server_Inf
 	if (sport == htons(RFC1001_PORT))
 		rc = ip_rfc1001_connect(server);
 
+	if (rc < 0)
+		put_net(cifs_net_ns(server));
+
 	return rc;
 }
 


