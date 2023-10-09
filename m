Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D023398C
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaWCSjFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCC2C433C8;
	Mon,  9 Oct 2023 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858493;
	bh=L5fmVLqaKT9YPjq1vUzROWP4gFnrmQXKt7tiWIc9hTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaWCSjFJYIoNVMf+ywo+icVSPe9KhdLvxLonl8qhffnWJyYZtdrP6nXxgk5napDBM
	 uyfLxRkk6zSEQ3aeNAvX78SvZKdKl6v65RPlnuKoVCY60C3Ia0HRStABBHcdnqE+rc
	 OoERRwnrUekf/rxBNHiyPyP6BTGKUZobIvoGkf5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 130/131] NFS: Fix a race in __nfs_list_for_each_server()
Date: Mon,  9 Oct 2023 15:02:50 +0200
Message-ID: <20231009130120.395908438@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 9c07b75b80eeff714420fb6a4c880b284e529d0f upstream.

The struct nfs_server gets put on the cl_superblocks list before
the server->super field has been initialised, in which case the
call to nfs_sb_active() will Oops. Add a check to ensure that
we skip such a list entry.

Fixes: 3c9e502b59fb ("NFS: Add a helper nfs_client_for_each_server()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -445,7 +445,7 @@ static int __nfs_list_for_each_server(st
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(server, head, client_link) {
-		if (!nfs_sb_active(server->super))
+		if (!(server->super && nfs_sb_active(server->super)))
 			continue;
 		rcu_read_unlock();
 		if (last)


