Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7F43314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301188; cv=none; b=fydd62aR1iYSd82Vlj2eDNakkSOjw1w+SIwy1DGwLCyBi1jN07CsnHbcAKhSbkf0wxBYXHx5mZYpAlMctHlcXTWMemYdwedU5LsspHnX43tlxf8kKYjRIfE8c13IuqVLL43t079+f78lvcL+OxbT/g+0vS+rbWW+QtRgHsRt4zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301188; c=relaxed/simple;
	bh=Vy2zAHmwceG868f1GeLWzAE3aLF2YjwYMpHEyEKuWcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT9zOT2idkrE7zAGm2n8JjkxoQTZTEiO5KZBXDN31j2rACg9oJRYWIQjFZt4ovOlK8pDKl1yTIkys4XMQyJVy8QXeHCkJIFaxnXR0srLWQ0EhK3Z1BsBqMkrcWm05dHDUb2DwOtgVjGsjVa3M1EB1bceUqD3l1KaDVqGrbrAmmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZo6jC3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZo6jC3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A91C116D0;
	Sat, 28 Feb 2026 17:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301188;
	bh=Vy2zAHmwceG868f1GeLWzAE3aLF2YjwYMpHEyEKuWcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZo6jC3Ud89QtqFKeCo2gZJO+uJ53KYUc0AW+fn5aN3+aq9KUzhuPRVlDdf1mUIiO
	 9K4tq6Z8VzTW3HAIUAvpGMYqiqYM21qYZNpkzzC+f6HJVQkpRtyxV+jTNV6N8/jrnK
	 8YOMWznpL1QygqkaqxCvG5cQQ7IA18PO//f6Io3yIkFA7Gb0Y4DJjmkNQ8Jao17tnX
	 aIwECyZM20BsUVxsbdFG5oPZueqJborLjWGVPBeXhKfvnbF3ouXeU7rEvlHFTWWrSw
	 0xxGjC2Xv8EaVtXlmuA7gpLQSJItjd+vMENPLK9fHk1GofzHtDBC0a4YuZmn+gJR79
	 qkm/Ap5XCSrNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jaehun Gou <p22gone@gmail.com>,
	Seunghun Han <kkamagui@gmail.com>,
	Jihoon Kwon <kjh010315@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/752] fs: ntfs3: check return value of indx_find to avoid infinite loop
Date: Sat, 28 Feb 2026 12:41:09 -0500
Message-ID: <20260228174750.1542406-358-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jaehun Gou <p22gone@gmail.com>

[ Upstream commit 1732053c8a6b360e2d5afb1b34fe9779398b072c ]

We found an infinite loop bug in the ntfs3 file system that can lead to a
Denial-of-Service (DoS) condition.

A malformed dentry in the ntfs3 filesystem can cause the kernel to hang
during the lookup operations. By setting the HAS_SUB_NODE flag in an
INDEX_ENTRY within a directory's INDEX_ALLOCATION block and manipulating the
VCN pointer, an attacker can cause the indx_find() function to repeatedly
read the same block, allocating 4 KB of memory each time. The kernel lacks
VCN loop detection and depth limits, causing memory exhaustion and an OOM
crash.

This patch adds a return value check for fnd_push() to prevent a memory
exhaustion vulnerability caused by infinite loops. When the index exceeds the
size of the fnd->nodes array, fnd_push() returns -EINVAL. The indx_find()
function checks this return value and stops processing, preventing further
memory allocation.

Co-developed-by: Seunghun Han <kkamagui@gmail.com>
Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Co-developed-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jaehun Gou <p22gone@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 6d1bf890929d9..050b3709e0204 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1190,7 +1190,12 @@ int indx_find(struct ntfs_index *indx, struct ntfs_inode *ni,
 			return -EINVAL;
 		}
 
-		fnd_push(fnd, node, e);
+		err = fnd_push(fnd, node, e);
+
+		if (err) {
+			put_indx_node(node);
+			return err;
+		}
 	}
 
 	*entry = e;
-- 
2.51.0

