Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E707482;
	Mon, 23 Jun 2025 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713648; cv=none; b=n+NrvHB3gkgpOIsx1OeLL39nPVd4YK/gc0xTzdCZ66KTCoVfEuPjjqQuqRJd/vvEU1lsa8eaeZdrtaiMk+U6sIB0zYDTgBXqmT8KUyIOx/t0+hbmLGRCTKdjvS4OUoxF7RxUTdgJdSyp0CHGZjkHB6lCVakpFHnR5FlM21BDO3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713648; c=relaxed/simple;
	bh=JI7W7p+MK82w5uXN08HMKFHd3WeiBPueeglXISHw2q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEaIShx/wU7TA/yVXy0PoJJVdDaFn6rm2IrhteS8CdHZjBJ0icsGXOFP5El9JXPh4EiNB3WqFq/OGbarT8+XcvXawf9Iq6345EYGeuH7MdyBqZLFtLZjp03rigZ4Vhj8ZU/eRsxNgGboV2mx9p7GGPXRu0L2uOnam2jhLTUgp0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWd98uBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWd98uBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E014DC4CEEA;
	Mon, 23 Jun 2025 21:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713648;
	bh=JI7W7p+MK82w5uXN08HMKFHd3WeiBPueeglXISHw2q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWd98uBWU6rE7nNHc/JkgLE/iLp72hygzBuSmp1FvUku8zuRQTOx7ucwN5KMumZzp
	 s9SgFtd8ZkHJbm0AWURZw1R4eAM4VW4VVJCnmX8JZKdcwPORNqjTqzwOVzVtTxJ4LV
	 zd9cA+dJzw1BhjN7gmuJSbrkrQgN/jd1WZqrcgJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/411] do_change_type(): refuse to operate on unmounted/not ours mounts
Date: Mon, 23 Jun 2025 15:04:33 +0200
Message-ID: <20250623130636.814326218@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 12f147ddd6de7382dad54812e65f3f08d05809fc ]

Ensure that propagation settings can only be changed for mounts located
in the caller's mount namespace. This change aligns permission checking
with the rest of mount(2).

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 07b20889e305 ("beginning of the shared-subtree proper")
Reported-by: "Orlando, Noah" <Noah.Orlando@deshaw.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 76a1cf75457be..900738eab33ff 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2327,6 +2327,10 @@ static int do_change_type(struct path *path, int ms_flags)
 		return -EINVAL;
 
 	namespace_lock();
+	if (!check_mnt(mnt)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
-- 
2.39.5



