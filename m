Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E23779F8;
	Wed, 21 Feb 2024 13:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522094; cv=none; b=NFftjgi+QBKoBTPHV6YqS0dGDw92vgGDRqG2YEvJeA6TaFUyMrK/vfQGtP/6swNen2RVc53TNPPTN75sKNF7navNrgmR4it4WNvolxpofMxcJUkdtgQaM0Nc2lQN4EjQg4K30pSmKIIjQrR/RDcHsFy9sW68tbrNRgjkGek6LPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522094; c=relaxed/simple;
	bh=0qhPtGDGndBQdIRPB6T+Z3VaYIAKxdr4PrRn0NMCTn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEgbstJsGhWChXSxbF5uGy1GLhilUmqm+wbiALStP6eGZdDmnOpiUHcRinWeVq65U4X6BrhsruSBcUlr/17qjDfHpS6/doaofrRZp5D78yMqKIDtEnntoeve7WW1LLTDFraDH98YeDb9u+6xfkVH+TMecheW20Tr49fXwLKqeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nm5mKieV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nm5mKieV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD2FC433F1;
	Wed, 21 Feb 2024 13:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522094;
	bh=0qhPtGDGndBQdIRPB6T+Z3VaYIAKxdr4PrRn0NMCTn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nm5mKieV79+QWrKtcF2UZnvtq49efy9GGs1XbPTagvKI2KzrC7a76ZJmOQbtJPJEU
	 7Nx/ZCuj0AKRBl0KhSGgxwoz9KXr1op/CDYbh7jfHXx7giOzt3u+VQz+dyIqJ6P2uA
	 jxtkpMrZQ0G9NUVCyDu6JCE3WYx0ytqjZjd8RBQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chung-Chiang Cheng <cccheng@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 078/476] btrfs: tree-checker: fix inline ref size in error messages
Date: Wed, 21 Feb 2024 14:02:09 +0100
Message-ID: <20240221130010.862559273@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chung-Chiang Cheng <cccheng@synology.com>

commit f398e70dd69e6ceea71463a5380e6118f219197e upstream.

The error message should accurately reflect the size rather than the
type.

Fixes: f82d1c7ca8ae ("btrfs: tree-checker: Add EXTENT_ITEM and METADATA_ITEM check")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1382,7 +1382,7 @@ static int check_extent_item(struct exte
 		if (unlikely(ptr + btrfs_extent_inline_ref_size(inline_type) > end)) {
 			extent_err(leaf, slot,
 "inline ref item overflows extent item, ptr %lu iref size %u end %lu",
-				   ptr, inline_type, end);
+				   ptr, btrfs_extent_inline_ref_size(inline_type), end);
 			return -EUCLEAN;
 		}
 


