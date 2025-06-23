Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7AB4409;
	Mon, 23 Jun 2025 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714704; cv=none; b=TdX0jU3XCgP0R5I3Hy4AlEAuNAp9vDWhla4yPp8FR/tr6bteuU1FzkTxA2zJpqfpRh4lJMGGWKPWND6oriXLrIb9Ha79gT0bDr5FsxlJZLKd5Uv6muRtNh0WwMxumtAAuc+kfj8O3iiX/KboV9y76PgbKyvZ5Ama96y6DI308Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714704; c=relaxed/simple;
	bh=iJgMYC1kQboYugp4QPKRWJMT54LbS11hqVXYjtLJMcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gb4U5QGbYR2Kdu41DTcEjzgPw/8eT3up8gwd44PxPQPxoHYKPJApmdR5KhamUxYE9cUqZbpkAc3J6Ye9TYFgfz8jl1PMVYq2LikpqLiELVb15GusECeovQoqkGJ3GdETIzcWEfSReMFXw/1v6r5wet7BcV6uFIMOwkS9tC36TZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6BTyNK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6BTyNK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A73C4CEEA;
	Mon, 23 Jun 2025 21:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714703;
	bh=iJgMYC1kQboYugp4QPKRWJMT54LbS11hqVXYjtLJMcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6BTyNK8Lw9o79AA8ZGyvIG++ouBEDCWANcmNIESnPs3bLM3dfhdZO7A/scDgsyw3
	 0GzwsJtYAQFoWps1m9QyjIDw1vEWB6GlDisqDNdpjA/6oSjTS43Lb/ZY+l472JlPGP
	 jK36iz0D6o6EhpIiUnbHge9msPUUJV3sPVQKIKlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/508] do_change_type(): refuse to operate on unmounted/not ours mounts
Date: Mon, 23 Jun 2025 15:03:55 +0200
Message-ID: <20250623130649.946796214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 65aa3495db6a1..aae1a77ac2d3f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2371,6 +2371,10 @@ static int do_change_type(struct path *path, int ms_flags)
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



