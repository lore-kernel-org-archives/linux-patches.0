Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB055293B5C;
	Wed, 23 Apr 2025 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421223; cv=none; b=nl0jKNbr2Garq2Xaa54pqp5kkCl06ycSKqNtSITDfjCZTVAHMwJluPDWyf+Xiioi6oU/UUNL7C2KV/y5oinAqs/N7HgtjYSw8cXYeyXhLmmrzYT/JOrYXq3eiWG72Hsl4rOdYYXrEu8zycUHH+UMI4xI4WWbe7dmgrWLJhnFtpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421223; c=relaxed/simple;
	bh=3CBQ3O+6UACtDgt8hpfx0NYvvVhYd+l/vkRZBXEWzJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h21Z5e/7WvuR+f4vy1cfts2dXpgGb5wPOgzkytJipE7/MQB72IYW0NrCrqZBspuNQD0F23vRB7pOmhy2NLbABxWW+gKb4LPhNogo8QQv4ofH82QafMo7a4L4kiUXffTEFpIC0us1rKCvej81Cz+r/xsbgKoir2AkUXXzNaMuESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGSQ16Wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGSQ16Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795C0C4CEE3;
	Wed, 23 Apr 2025 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421222;
	bh=3CBQ3O+6UACtDgt8hpfx0NYvvVhYd+l/vkRZBXEWzJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGSQ16Wy/9G+ARB3tjQgsEl0GzfdgCY28k0BQPDhQcIrpZvB7pEEIMNhJ1D9Gmxjm
	 gwAfi6ZVPYweFExFdbR9bQElp22l8SBgWYMJu9Sjq9n1+BKEyWXWKKssUbAeKDxSTY
	 d2+TQ38HCG+OPDOCaGosBUb8thwur/bWM1xZNJAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 148/241] Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"
Date: Wed, 23 Apr 2025 16:43:32 +0200
Message-ID: <20250423142626.596435848@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -300,7 +300,6 @@ cifs_abort_connection(struct TCP_Server_
 			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-		put_net(cifs_net_ns(server));
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
@@ -3127,12 +3126,8 @@ generic_ip_connect(struct TCP_Server_Inf
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
 
@@ -3148,8 +3143,10 @@ generic_ip_connect(struct TCP_Server_Inf
 	}
 
 	rc = bind_socket(server);
-	if (rc < 0)
+	if (rc < 0) {
+		put_net(cifs_net_ns(server));
 		return rc;
+	}
 
 	/*
 	 * Eventually check for other socket options to change from
@@ -3195,6 +3192,9 @@ generic_ip_connect(struct TCP_Server_Inf
 	if (sport == htons(RFC1001_PORT))
 		rc = ip_rfc1001_connect(server);
 
+	if (rc < 0)
+		put_net(cifs_net_ns(server));
+
 	return rc;
 }
 


