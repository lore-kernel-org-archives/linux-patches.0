Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B41173;
	Tue, 30 Sep 2025 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245557; cv=none; b=rLCR1xHKhDW4rPbismc+xVT7kjCMuF+iRfJgrlj47b6HeEpXAz4jrSDuO14uG0z9ug15krDRUSAq21yEhYjLlS/fOfGedAjn5mQFcyDn+piyePXoiCR8dx6JDvBo0Fvn+gb/HhwGm6kREZriKdtyAB8CmR5WEWusBYVWSGFq0yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245557; c=relaxed/simple;
	bh=2MDL3/VA/L/B6yJ1HBODPZRZLds2B6m9OQKNfuhHpRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9dUMCogglqBIrDuiOzZ0Ljma6rkjEM3MuIhcMQItwWNPczVJMNXYOg1+NsD4e7Tk/vHMu0LTfVK0uvy3vdY1dEt8js+wvUv0hdoKqJR/iDWFAjMmRwywyhx3HBK+1W/L1mQEQn/SjgvVEuBINyXrA+RwmdNi7PYL/39g3hQ2W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGODR+SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGODR+SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DA8C4CEF0;
	Tue, 30 Sep 2025 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245557;
	bh=2MDL3/VA/L/B6yJ1HBODPZRZLds2B6m9OQKNfuhHpRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGODR+SI45tIVlJh0V3LzvKHmHyV93cNAp/oElox684di0SAjZjm782mvSbAo2Fx8
	 n/X+YFGtGFq/R27CMZoSHRneVrRb9wzXLG50xYjpNrOc2ihm9T7r3Z7TgNKXC6VYQw
	 haZ8P2HB2eKqwaSxgISYMtrRqz1fQkSxWWVrIykk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 53/73] afs: Fix potential null pointer dereference in afs_put_server
Date: Tue, 30 Sep 2025 16:47:57 +0200
Message-ID: <20250930143822.844722836@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

commit 9158c6bb245113d4966df9b2ba602197a379412e upstream.

afs_put_server() accessed server->debug_id before the NULL check, which
could lead to a null pointer dereference. Move the debug_id assignment,
ensuring we never dereference a NULL server pointer.

Fixes: 2757a4dc1849 ("afs: Fix access after dec in put functions")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Acked-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/server.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -401,13 +401,14 @@ struct afs_server *afs_use_server(struct
 void afs_put_server(struct afs_net *net, struct afs_server *server,
 		    enum afs_server_trace reason)
 {
-	unsigned int a, debug_id = server->debug_id;
+	unsigned int a, debug_id;
 	bool zero;
 	int r;
 
 	if (!server)
 		return;
 
+	debug_id = server->debug_id;
 	a = atomic_read(&server->active);
 	zero = __refcount_dec_and_test(&server->ref, &r);
 	trace_afs_server(debug_id, r - 1, a, reason);


