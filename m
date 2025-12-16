Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F6935F8A3;
	Tue, 16 Dec 2025 12:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887331; cv=none; b=ReXOBrkwN/MkyEoQ1w8l6kXzgY0s31IvEz8vTRj769LbFMFMpaA4Ct1fa2wveyZXPuPfCnLyJ7qB0ZTlqsqHGU0k2ElK1ZXV2lyBLSojrGusSj0jmgiOq3RXnz+Q6ZqW+si0mOe9cOg8Ewf7X0FlhCceDthiqXFdj1vaxN/dguo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887331; c=relaxed/simple;
	bh=WTkHMGCouxfVCFy/tTV7PQRWhjJAQqaaIinBf7KrM9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+501pTUP4C4lrBKer8n2TQk6PZGUkM4rIUXRO8NWku+4ZwBECWobjN536/KuNhWhaUJPrJtAdIVoL53RTYdYcqFH1gJSjYodMrzSHr3BYrS0pjwAxAnxx3AiMexsXG5M8ku6mrPK/h00sVzKNNWrgAs25xIgOetB4t46SJsWMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT7QcEA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT7QcEA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB53AC4CEF5;
	Tue, 16 Dec 2025 12:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887331;
	bh=WTkHMGCouxfVCFy/tTV7PQRWhjJAQqaaIinBf7KrM9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT7QcEA+Tyd+pC91NwYbcE3yujnKE9sQLTXpVfjKAYXJy3I3Vdr9mQJEhkglS26HP
	 tIu9gvzBUmWhFUjdG/TFZWUY79B2tDjkirz79NjGwvaYGna1u4gzN+OgkjR1bcrwhO
	 PFTIw5oEREmNxktRgcK+oHhEjUDtEcA/FGfgWe0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/614] cgroup: add cgroup namespace to tree after owner is set
Date: Tue, 16 Dec 2025 12:08:57 +0100
Message-ID: <20251216111407.508992138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 768b1565d9d1e1eebf7567f477f7f46c05a98a4d ]

Otherwise we trip VFS_WARN_ON_ONC() in __ns_tree_add_raw().

Link: https://patch.msgid.link/20251029-work-namespace-nstree-listns-v4-6-2e6f823ebdc0@kernel.org
Fixes: 7c6059398533 ("cgroup: support ns lookup")
Tested-by: syzbot@syzkaller.appspotmail.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
index fdbe57578e688..db9617556dd70 100644
--- a/kernel/cgroup/namespace.c
+++ b/kernel/cgroup/namespace.c
@@ -30,7 +30,6 @@ static struct cgroup_namespace *alloc_cgroup_ns(void)
 	ret = ns_common_init(new_ns);
 	if (ret)
 		return ERR_PTR(ret);
-	ns_tree_add(new_ns);
 	return no_free_ptr(new_ns);
 }
 
@@ -86,6 +85,7 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
 	new_ns->ucounts = ucounts;
 	new_ns->root_cset = cset;
 
+	ns_tree_add(new_ns);
 	return new_ns;
 }
 
-- 
2.51.0



