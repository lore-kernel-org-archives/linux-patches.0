Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DD31E0DD8;
	Wed, 30 Sep 2026 16:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785880; cv=none; b=B1bzr5sJJ53xlQ1YQbBlxrMrNZg0RFvjDPnKhlQOQji0JMnOUcsecA2v3CezEazsbyvrlXRJpU99sZcFEzJz3U+ac/7baUGQhfH+MlgxTEAyVeLJcZLUFa24BJCY5rCRzSbGlj8Qlswn4Z+9OaRBz6N7dgL9BDpoJ/3PAT9jY70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785880; c=relaxed/simple;
	bh=nhOMMbOGHXIVRyf6nEdhfBY0YAAKRzWlS0ynfMDgYtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYRLhz6sjgqq4p+r8t9bVDr/YQCxNkj4fcdE/YPVqpl74sygYabrltb2mzmlqe80oRCy/iV1J/Gd9pLm7uRQUUPwCCbrJti9MULWlcAbmsab2u49oqV/VCD6N6ubrxrXXwETk6ZM7RgDkwZua+q8z+EQOrWmAwaIZkdNRv10Pgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aN6UcMEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aN6UcMEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AA01F000FF;
	Wed, 30 Sep 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785878;
	bh=haLWPJb+M60cfzW996n9j9DzDBoISwqR8I4cO48J12A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aN6UcMEP5rEd8Es+dg/MZNhTEbZYEo6LiWth6fMHG202x7XcX9YwLA2rmhMl0s21r
	 EK2SBQ50lBtfvMSxsikQYUIIFhgdV9wrDOWhhfYBWjr/NKYXSSCxF1qInazJjHcSfv
	 qFDOFBt20LK8ZJKBmQpV+c69bUTlCKHrjxWbsKC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 664/982] btrfs: tree-checker: print dev extent offset in error message
Date: Wed, 30 Sep 2026 17:23:20 +0200
Message-ID: <20260930152431.026377064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a1167d9420474ab9ed9efca99d86aeb6217c0265 ]

If a dev extent's offset is not sector size aligned, the error message is
printing the dev extent's objectid instead of the offset. This is a copy
paste error, as before this check we check the objectid field.

Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 8e9139dc4bbe2..b55eb223b58bd 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1729,7 +1729,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 				 sectorsize))) {
 		generic_err(leaf, slot,
 			    "invalid dev extent chunk offset, has %llu not aligned to %u",
-			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    btrfs_dev_extent_chunk_offset(leaf, de),
 			    sectorsize);
 		return -EUCLEAN;
 	}
-- 
2.53.0



