Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2F33AEF58;
	Mon, 23 Mar 2026 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277551; cv=none; b=GVZa8CAtgxPet4vtAbp3gzIP2XnpUhUr9vkF40OcJlC/rUuhrz+Iyx8XEh8medOZZcd9hpWTJaS+sK86UyALcJ1WEh6+WDHk+3+d2KAs2aDs39ympxsCXfwGWSqlStx3lkApY/IOdKbgFiWRwON5zvJv2ojNpCn0xp0XMJsPoI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277551; c=relaxed/simple;
	bh=hekTqL57bMBM9q7cu0Ka0+7jBSHF1Ws4mqEgu/Uk+ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tM4BRucYShV1OffW615ZeHgySzw52ADz3rqibSt/rPhiCqH4pcz3jlS9BleO/L+hKvwDXchEPGsuZmMRFoU8YbRPuGHn5yjZI0+AKWrXNu0+cUj+WqlBXw8flxujnfZJvvvPd5u7+6JcetpI1C+fZcxBhYt2On7/x/XybNlx9Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3RAM7+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3RAM7+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADF3C4CEF7;
	Mon, 23 Mar 2026 14:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277551;
	bh=hekTqL57bMBM9q7cu0Ka0+7jBSHF1Ws4mqEgu/Uk+ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3RAM7+dzMaTvkIpF46exCQNGU8F5eR3yniNoEKtE0D2++Rl3Edl6GK9k+wvHjU+/
	 NEJvLhdMYZtFkdEECpEUJxrIg6WZY08HSPFNjZ5kaytrtPgL1bMv6Zqq81EjOQoX7P
	 Ko8lIVHcq537faYSyRGWmuevS+2FE7mJPIJaZBsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/567] btrfs: fix incorrect key offset in error message in check_dev_extent_item()
Date: Mon, 23 Mar 2026 14:39:01 +0100
Message-ID: <20260323134534.292592383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 511dc8912ae3e929c1a182f5e6b2326516fd42a0 ]

Fix the error message in check_dev_extent_item(), when an overlapping
stripe is encountered. For dev extents, objectid is the disk number and
offset the physical address, so prev_key->objectid should actually be
prev_key->offset.

(I can't take any credit for this one - this was discovered by Chris and
his friend Claude.)

Reported-by: Chris Mason <clm@fb.com>
Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0d93368c1691a..bca5ec4c26630 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1802,7 +1802,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 		if (unlikely(prev_key->offset + prev_len > key->offset)) {
 			generic_err(leaf, slot,
 		"dev extent overlap, prev offset %llu len %llu current offset %llu",
-				    prev_key->objectid, prev_len, key->offset);
+				    prev_key->offset, prev_len, key->offset);
 			return -EUCLEAN;
 		}
 	}
-- 
2.51.0



