Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218882EDD62;
	Mon, 27 Oct 2025 19:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593332; cv=none; b=U81UBnh99M0KP4uPGmKQo8jHin5Q8seOL3XJpXFCEtCZvsnIujjiFbwNbRR4gbwJZvrBkmUEwkbUFIsIrXaa770nUleibHrKkfZ5uYKIIwUoSQ5wCBBIZu5RVF/4CSaa68EOF0p59WGP+xBBlnhFRoJWQW6peXI8kkfCdSd1hGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593332; c=relaxed/simple;
	bh=fxzkH+q6gPNqJ2PO2Oe53YF4gbmQvMmRugNTNjnqjb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dena4bsgyv1rE+Gbw2SRBblP9j23M5DiKV27JSDhyfIXBhBGN9L2AiNk1zyCCzF2zkXyPg9vynljnOtazUQzLaNZNSiPUTMW4/6xEiAQPr82XNGA6gaJeElTKT53K1ivaN2xKsclXwxtA7sRVb13MF8lsuJLFQj2lsNnyVl8Gxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afNZzWP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afNZzWP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95067C4CEFD;
	Mon, 27 Oct 2025 19:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593332;
	bh=fxzkH+q6gPNqJ2PO2Oe53YF4gbmQvMmRugNTNjnqjb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afNZzWP5FuniXR7qluVpC5asOgf7GDIfBS5xprtPHljK9SLPA8/37edTjzZZsflsd
	 rOm7vn39VkjVS0B0zAf9fN6UCnwevS6U1zAN1jR8+mSGd4AxPfjx4UGO8Lv3VUur6+
	 eQJrsamA7i4vzmv2tMu8oT5MF3k6+1NPgoJlZfXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amit Dhingra <mechanicalamit@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 073/184] btrfs: ref-verify: fix IS_ERR() vs NULL check in btrfs_build_ref_tree()
Date: Mon, 27 Oct 2025 19:35:55 +0100
Message-ID: <20251027183516.861551799@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Dhingra <mechanicalamit@gmail.com>

commit ada7d45b568abe4f1fd9c53d66e05fbea300674b upstream.

btrfs_extent_root()/btrfs_global_root() does not return error pointers,
it returns NULL on error.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/all/aNJfvxj0anEnk9Dm@stanley.mountain/
Fixes : ed4e6b5d644c ("btrfs: ref-verify: handle damaged extent root tree")
CC: stable@vger.kernel.org # 6.17+
Signed-off-by: Amit Dhingra <mechanicalamit@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ref-verify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index de4cb0f3fbd0..e9224145d754 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -982,7 +982,7 @@ int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
 
 	extent_root = btrfs_extent_root(fs_info, 0);
 	/* If the extent tree is damaged we cannot ignore it (IGNOREBADROOTS). */
-	if (IS_ERR(extent_root)) {
+	if (!extent_root) {
 		btrfs_warn(fs_info, "ref-verify: extent tree not available, disabling");
 		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
 		return 0;
-- 
2.51.1



