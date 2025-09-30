Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E91E2236EB;
	Tue, 30 Sep 2025 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244892; cv=none; b=N69mLDIsMbuPXf7bu+07E6ojNZWrOIe1NIrF3NkRE+UATSsJYmmskmoe4ul6KZSbCiPRd+2vR0TmdbRJbHFlApENW4mMvWeVif3lTrQ+roEC7SSPFrYjRWu0pv83LY6fkfgq2v42sB3QxBQLWszkRyiSDB0TOXQ4CWMHuckRMzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244892; c=relaxed/simple;
	bh=Vc6s+KKVWqeBuwoVbwJJU0dgyp5cLoB+DdGQCoHlHPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7LMdopU4Sur7M6PwDv/ZNwAwjUZmaNnAKxx39CppsM3bU6CprVpkR5+26N1aPEvfonI9L+2fWGlF9IlMdlNp0qlpuxmJPOLn1a0Trv95bcmMgYkDms9zzdYs71OcK99VecG401PBVk67m8YoTvzm0DoMbmoxdTDuGDCIxziNps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vCeggaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vCeggaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DC4C4CEF0;
	Tue, 30 Sep 2025 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244892;
	bh=Vc6s+KKVWqeBuwoVbwJJU0dgyp5cLoB+DdGQCoHlHPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vCeggaYEZyyf6XsxMnpg1ySBU0/Vw6SX6sHl3/vrBqfxncs+4ZzCkEYHVUsHifoF
	 4s8NK6sbqQHmnhgesmCgi/99sjWOIcnDHseNmZ7dQu2v8YLxzQ/c3k9BfhV7wC+l1V
	 OibHLUsS5TPiI14TE8FTYzNqz+K/vtTpuWlhSAXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.16 125/143] afs: Fix potential null pointer dereference in afs_put_server
Date: Tue, 30 Sep 2025 16:47:29 +0200
Message-ID: <20250930143836.213012160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -331,13 +331,14 @@ struct afs_server *afs_use_server(struct
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


