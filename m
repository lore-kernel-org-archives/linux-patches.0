Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C0115705C;
	Mon, 29 Jan 2024 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548580; cv=none; b=QiVgDeM5IwSj4XZ6fr0TeoeSeoNat4+9G8EVxSWG/KRTMMTMOFbBqvHz7okfC7z5B1CNrEFeY3NF33mU8DMIHuys2H6OE/OyVjyf1ZfDRe3C3TmBq7MHAzIHQVjgfQKuUAAo0IlEpfgkxB6CrbNYiFdDVvdpC31bQ7SKrc+Z8J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548580; c=relaxed/simple;
	bh=+4+6nDRG5c/iFepHS/WoUWNmGk72wASXQCCxVpseHvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qcwic69/zOoxiObJWnZlClU3P/1XjwSpvfCvgKTaYncqkAikTC7lnQRfyXLkS0Eo+xo33tt8hHhVJ73iURhpAvec4E6cHY2ruC/QDIR0ZbZKqRi6+qn0qJkneStV9bgzO/8THfDufxEEMZgm8yJAq1e4vWSBSUBV5hsmALCf9s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXP+wEmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXP+wEmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC74CC433C7;
	Mon, 29 Jan 2024 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548579;
	bh=+4+6nDRG5c/iFepHS/WoUWNmGk72wASXQCCxVpseHvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXP+wEmfHIpIIOEgtdXUL9CZ/yc4IY61+ZWVKMkH0HQXzjWDrcGbD9h5T32r0pSnn
	 +hlk3+FEANr94RHQ2ErNkVglEQK5jNDvfjRH6LKgSm31Loku0qz0CdkBPzepBa6+wJ
	 tJbrCQxGpz6/fD9VwY7TAneKsw4q683qgaXzoD3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chung-Chiang Cheng <cccheng@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 234/331] btrfs: tree-checker: fix inline ref size in error messages
Date: Mon, 29 Jan 2024 09:04:58 -0800
Message-ID: <20240129170021.721362993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1417,7 +1417,7 @@ static int check_extent_item(struct exte
 		if (unlikely(ptr + btrfs_extent_inline_ref_size(inline_type) > end)) {
 			extent_err(leaf, slot,
 "inline ref item overflows extent item, ptr %lu iref size %u end %lu",
-				   ptr, inline_type, end);
+				   ptr, btrfs_extent_inline_ref_size(inline_type), end);
 			return -EUCLEAN;
 		}
 


