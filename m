Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A6330F93B;
	Fri, 21 Nov 2025 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731304; cv=none; b=RG+kdrAuZnVvEUEq6zIFzOOhozXpYnXJDvDMnXqZ0KXvhMJERrKl8aul9msbzaT8oJJ/fVfJ7yRgdT56Yzt2qhJfXgtFu7LzFCxoQg/Ga1r3x97xyqAfEBWJCWmFfhmHkudk5P4W8DUae1lUU64mwLnkGeWKfRssRCuXkOUZv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731304; c=relaxed/simple;
	bh=GYEGcx16RY4jxIViPCeyRiMosG5tmMX/F4OczQxx7mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz04vY5c+6/uvzdZUtUWqtQSMiL6BugMG0DMa8N8PNhqG4YES+6Pf6tnO0TlFzg6YPu/1/xdGbBkwvp3Vult5ba+qvG7a1a7jGWM1L+M1Nc5LW1oBi5VOZOZulz8nrbOnw9Xr7IXcUgWzE83E65WLn9TfrCcIHcQtoSf2H6eG2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYK5eWra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYK5eWra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F7FC116C6;
	Fri, 21 Nov 2025 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731304;
	bh=GYEGcx16RY4jxIViPCeyRiMosG5tmMX/F4OczQxx7mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYK5eWrahxTwQmVQR9b0ch/KfsDZ8qADxozwE6XupAM13ENWZ58BoJpxlY+OBrFuK
	 BgLTx876tA58lPVzoJqhXTy7EWpBW2/dUFdCMia+ETvLFHQF/XkoeqG4nP5aOwNFlP
	 JZZv8auRkv3qNnFY7sU2qtnTPa2tVMdiVwCtCuYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 162/247] ksmbd: close accepted socket when per-IP limit rejects connection
Date: Fri, 21 Nov 2025 14:11:49 +0100
Message-ID: <20251121130200.536251000@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 98a5fd31cbf72d46bf18e50b3ab0ce86d5f319a9 upstream.

When the per-IP connection limit is exceeded in ksmbd_kthread_fn(),
the code sets ret = -EAGAIN and continues the accept loop without
closing the just-accepted socket. That leaks one socket per rejected
attempt from a single IP and enables a trivial remote DoS.

Release client_sk before continuing.

This bug was found with ZeroPath.

Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -284,8 +284,11 @@ static int ksmbd_kthread_fn(void *p)
 			}
 		}
 		up_read(&conn_list_lock);
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN) {
+			/* Per-IP limit hit: release the just-accepted socket. */
+			sock_release(client_sk);
 			continue;
+		}
 
 skip_max_ip_conns_limit:
 		if (server_conf.max_connections &&


