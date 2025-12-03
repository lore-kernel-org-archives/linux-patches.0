Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF340349AF4;
	Wed,  3 Dec 2025 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780612; cv=none; b=IbUuesl84DOCtBH74hh4MdZ1N9PWSPjTQwhiaj8Z7ibeud4Yk79QVmAU/dNcwby3YF7xDfS35Wjq2FHRhdQkrcfRU/csgi0N6lV89AnTjyT6HNBILMTTLF9n6/W8Qyp8xR4/2KCrzqInmPAECON8xLKjngvf1WceZ5BEU8Ue4pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780612; c=relaxed/simple;
	bh=LECsBgpNOEeRzBCDIE4vPprxjNuaMfKAZ7yB4rX3dqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHvZcL8udkSP83u1O5LmaXZ33Ma4cQbcSMp+UyKCiai2oSNIHbmC2s9gg1ebqryD4IBzlnYohjh8oMo3y6PDP0ihNSZvLr6Y2pk0eNmHtl8v0fYZw2RT9OrTERFWLztyhoBaH6n3QXUBn8ItYXwZL8cTfORvIiyftH8KEDSzAiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqO0r+E2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqO0r+E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A14C116C6;
	Wed,  3 Dec 2025 16:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780611;
	bh=LECsBgpNOEeRzBCDIE4vPprxjNuaMfKAZ7yB4rX3dqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqO0r+E2qRlG3mdD86XJ+/SJD/ROTLzwfyqNpTgS1QHgosdMe+RO76L9/SoO3FRvA
	 rb/Il8dMFVuVQQLJNnSYI2BTVYHG7WBF2xVfWPy9Ff25NGOchQjl5p5OzNH6mP6zgS
	 XzRG7dAs1i/9G6bZ1TcVgd3rLco3TCrPqX4upK+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/132] fs/namespace: fix reference leak in grab_requested_mnt_ns
Date: Wed,  3 Dec 2025 16:28:37 +0100
Message-ID: <20251203152344.706936158@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Andrei Vagin <avagin@google.com>

[ Upstream commit 7b6dcd9bfd869eee7693e45b1817dac8c56e5f86 ]

lookup_mnt_ns() already takes a reference on mnt_ns.
grab_requested_mnt_ns() doesn't need to take an extra reference.

Fixes: 78f0e33cd6c93 ("fs/namespace: correctly handle errors returned by grab_requested_mnt_ns")
Signed-off-by: Andrei Vagin <avagin@google.com>
Link: https://patch.msgid.link/20251122071953.3053755-1-avagin@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 035d6f1f0b6ef..c3702f3303a89 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5345,6 +5345,8 @@ static struct mnt_namespace *grab_requested_mnt_ns(const struct mnt_id_req *kreq
 
 	if (kreq->mnt_ns_id) {
 		mnt_ns = lookup_mnt_ns(kreq->mnt_ns_id);
+		if (!mnt_ns)
+			return ERR_PTR(-ENOENT);
 	} else if (kreq->mnt_ns_fd) {
 		struct ns_common *ns;
 
@@ -5360,13 +5362,12 @@ static struct mnt_namespace *grab_requested_mnt_ns(const struct mnt_id_req *kreq
 			return ERR_PTR(-EINVAL);
 
 		mnt_ns = to_mnt_ns(ns);
+		refcount_inc(&mnt_ns->passive);
 	} else {
 		mnt_ns = current->nsproxy->mnt_ns;
+		refcount_inc(&mnt_ns->passive);
 	}
-	if (!mnt_ns)
-		return ERR_PTR(-ENOENT);
 
-	refcount_inc(&mnt_ns->passive);
 	return mnt_ns;
 }
 
-- 
2.51.0



