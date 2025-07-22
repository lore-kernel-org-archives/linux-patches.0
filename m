Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC055548EE;
	Tue, 22 Jul 2025 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192916; cv=none; b=QdRXyWhj0vRcgoQdQdgczgG0jHiySIMB1zEeJp+rQ9G3m98ZPn++u56kZLBSZ+RyvnXjjD+SLwTqAK7jv5SkmuLYciF+CTVIW3xUcq8iztb62BoZbZeDtv6k5P5XfzX5d+GAd7Mj0dVA4Hp3Cvkg7WR1R7KxJAmVbgS7SGaUEkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192916; c=relaxed/simple;
	bh=K0vKwt7CJYlcWGHbVHwuLdQTWBYDmRAUZNmTpcTtjRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/SfTVtmwQiWlfHXPMme3JRRCIZBCai1P2f1VlfPt86i3PAF+7iZwyWbrRN1ZrWp0jcJlBdX3rwIFirl3QjgK2DOJoW121F8pUpaU2kVEwTqUKIJLOXPbxhnJ4iam/rhSx9N4dLNYaVj3f1LpN0y+oFkSwZvUUHhS+TxMp1dMHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou0exMab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou0exMab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0C3C4CEEB;
	Tue, 22 Jul 2025 14:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192916;
	bh=K0vKwt7CJYlcWGHbVHwuLdQTWBYDmRAUZNmTpcTtjRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou0exMabGPX2HvqBZPEleAWzOxuGapqT1kGuxEVYRR+n5UOXHWsQyNK5qVEBNjFGJ
	 ZMchlzje4DwqoJidM0JY/egmKGkt0mHLZ3LxdojYUGBBO4S93+Yvg8v1F1xWUgJLLu
	 MgBay/gWLVMiNUg6UbfYXnfUbVwGFYz68TulmSLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/158] fix a leak in fcntl_dirnotify()
Date: Tue, 22 Jul 2025 15:44:39 +0200
Message-ID: <20250722134344.300673703@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fdfe0133473a528e3f5da69c35419ce6711d6b89 ]

[into #fixes, unless somebody objects]

Lifetime of new_dn_mark is controlled by that of its ->fsn_mark,
pointed to by new_fsn_mark.  Unfortunately, a failure exit had
been inserted between the allocation of new_dn_mark and the
call of fsnotify_init_mark(), ending up with a leak.

Fixes: 1934b212615d "file: reclaim 24 bytes from f_owner"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/20250712171843.GB1880847@ZenIV
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/dnotify/dnotify.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index d5dbef7f5c95b..0539c2a328c73 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -309,6 +309,10 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned int arg)
 		goto out_err;
 	}
 
+	error = file_f_owner_allocate(filp);
+	if (error)
+		goto out_err;
+
 	/* new fsnotify mark, we expect most fcntl calls to add a new mark */
 	new_dn_mark = kmem_cache_alloc(dnotify_mark_cache, GFP_KERNEL);
 	if (!new_dn_mark) {
@@ -316,10 +320,6 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned int arg)
 		goto out_err;
 	}
 
-	error = file_f_owner_allocate(filp);
-	if (error)
-		goto out_err;
-
 	/* set up the new_fsn_mark and new_dn_mark */
 	new_fsn_mark = &new_dn_mark->fsn_mark;
 	fsnotify_init_mark(new_fsn_mark, dnotify_group);
-- 
2.39.5



