Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A22FA658;
	Tue, 17 Jun 2025 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179127; cv=none; b=kosN4TlXS90nZTEganvRoICPvqvXPP575/cbiH77lxuni3jdO7P32uu6wZrnCcmgM8aspCPBV0ILNlx1iwfDUrAKkHcPYA0qWwuIRHuTG7FS/NC5NIYsrYRPJkmKKs0GXdkmq6vUFNhFCu7+ZYGu9yIkiZ/qJciJcp73PoT4nGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179127; c=relaxed/simple;
	bh=sdBTy9L5FNK+bTk1eSFKGy8L8IaY7/a859hPAgJfRZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la9bqf4MB6M5gQXznVfgohaQ7Xh2JG1ZNBqPyL2xQqP8VnGdai83j6FCgU5cyDt5VpwRuiV7M/OtVLCaTSBQAHsBvssXUlX6RmfXomgeVSqYjyYi6newoKO1t3x1vgsDvm83qeesgQ0qFkUJAo0Wk3xi5LhSgajq67ufWATgSTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oe0W1yxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oe0W1yxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C341DC4CEE3;
	Tue, 17 Jun 2025 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179127;
	bh=sdBTy9L5FNK+bTk1eSFKGy8L8IaY7/a859hPAgJfRZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oe0W1yxnHl/Flm2Rgn2j7bvFZhcWTwDrq77usgOy+u/WO+uBftWB0qteaytZkCchl
	 WXl7LL1nM6lNXaifSv9maiHouQ6/mxYeCFAhEOBETKRMwfVDK0eIOtVsiHZ/3Vxper
	 RBi5C7Ray8th+biOAZmjvCcAPmXQUIKoWl/GN0ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 656/780] do_change_type(): refuse to operate on unmounted/not ours mounts
Date: Tue, 17 Jun 2025 17:26:04 +0200
Message-ID: <20250617152518.184646494@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 163ffdc042284..2de4b7ad1dc5d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2958,6 +2958,10 @@ static int do_change_type(struct path *path, int ms_flags)
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



