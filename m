Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43C3346AFB;
	Fri,  7 Aug 2026 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115212; cv=none; b=P+w1UG88yqrGHsqiFWfMeEMJ6f4YDemPIDi1TUQdHV+5r8PowJEaDRZYCMNZVSoj8P7PfP9IbZmn2QSisgxmr6giA2BhpEFfzRz8n+9pTv+KCbq2dBsdWMa5zRbFOlZqBp8pM/2JYxR6B8WFjHyh/meepgnIxN8jDkeaX3e53tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115212; c=relaxed/simple;
	bh=VwnGGQaNz4/8EAM0gygUYRM/ghT9qLHzX6qOt7ZwrG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9Ojsgt11op3buzvkvM27PcO78V2pWmQ4x+Ou0O2WZhoUFYC/vuZ9E0RbBpt0Tq48xS3+jYU1UyYNWEM6t5Mj1yeJWdeQ1xrbrEOd0Zyx0GGfjBOS8DEft8Q0mnHES8hSfwvC+CS9PreP6ztnF4DL780t5Ilvb9RiBAyh7+lNZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUHP4zPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUHP4zPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234AA1F000E9;
	Fri,  7 Aug 2026 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115211;
	bh=azePOwieJHhluTTH/PMnZECbupnUy6hWY6LzNYBh+4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUHP4zPLTWMdPCYOMowtia8n4Zf4rrfVDyh9GOlDuEUsFtDLBoYB7vzrTQ9LnczxU
	 pLd0gdlPxIwpGwjMHbdilus5Jw7b3LAesRv+HmoS7PVT69QCxTJ2qbhAMmJI0JWOui
	 yygh+Z46r2zx+HyunLtiEvOtEwZGyIKQqqPsKBY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 198/396] afs: Fix afs_fs_fetch_data() to set call->async
Date: Fri,  7 Aug 2026 16:35:58 +0200
Message-ID: <20260807143428.552740560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit d568a43f6dbba3ba006304d95fd09862bd482a2f upstream.

Fix afs_fs_fetch_data() to set call->async on an async operation as does
afs_fs_fetch_data64().

Fixes: eddf51f2bb2c ("afs: Make {Y,}FS.FetchData an asynchronous operation")
Link: https://sashiko.dev/#/patchset/20260702144919.172295-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260723113452.566619-2-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/fsclient.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -477,6 +477,9 @@ void afs_fs_fetch_data(struct afs_operat
 	if (!call)
 		return afs_op_nomem(op);
 
+	if (op->flags & AFS_OPERATION_ASYNC)
+		call->async = true;
+
 	/* marshall the parameters */
 	bp = call->request;
 	bp[0] = htonl(FSFETCHDATA);


