Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D82276046;
	Tue, 30 Sep 2025 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246190; cv=none; b=gfq6VCB5EHMOs13v6G03CA/aov2wPUNFDVbcFNgrlFEGqrwqqgE9fnuI87yyC8VcZTekO6lAH9LYnhO4MmoXUk9oTJmjHFShEZM8p7beUHSxPoXsHBP10iAQVDV/n5GOMLCtd8xmHmC6bOIp7E8QE6c1E/EFYW0xbK6Td2nVpvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246190; c=relaxed/simple;
	bh=30yukShz67Y/BIlcx9uUTLxEFZHQqhuQhXwQgdjZv5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rfsz1zzB2Ud0Sarpp27TE7mBCHqh+nQb4VKqhsDzfAn5f74SDqsBckxvEch+3l+kDHjhzAj2xAIZEH3T1+8oyoThIO3bISpa5u9VKbpRl2ToiuM1qvgWqGhA4BOBtI0B88ffcgR1XtnlMJm8+zcVAdof0eXOMDAuE6V//7qf/+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDcOc5LO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDcOc5LO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF31C4CEF0;
	Tue, 30 Sep 2025 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246190;
	bh=30yukShz67Y/BIlcx9uUTLxEFZHQqhuQhXwQgdjZv5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDcOc5LOg1nd0SMJ058kauEgLYGwOuEbv/lRPdMCa8dy7ukeg6n5IMNyfZXIk+cym
	 6lj5ta2tcm8iByP4aJVT5czu1Y1qT+ASxJoJKYz30X7roZ4k1ob2T/uALyQ1oji1ZT
	 pT1tYbWJ5Qcy2kcrxlS1N6qN4Ti7KqD0KDDS5XQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 81/89] afs: Fix potential null pointer dereference in afs_put_server
Date: Tue, 30 Sep 2025 16:48:35 +0200
Message-ID: <20250930143825.246931403@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -394,13 +394,14 @@ struct afs_server *afs_use_server(struct
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


