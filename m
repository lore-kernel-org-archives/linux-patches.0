Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A751288C95;
	Wed, 23 Apr 2025 15:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422344; cv=none; b=hguVoBGP4up+EF1HCxMGBhKvkYDbFC5Dy6jP2Q5mVOVAuQr4Bsku8iqQiabm7bpdrI974QvSSfpBRDB1EzOKnl254KtW0wijjdzCDZF2GsFuWjt38BOLrpXEppG9EBaTkw/eH6mENj4d1Jei/Pjcibyy9KjkQdlapEUjVsr/d5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422344; c=relaxed/simple;
	bh=F7KnCSeSJC9oYkWD1C3UePNd2aDRTDbb+WCv8YDf8Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEQ7Hh/s6KKYLn9Ft1j6r21xJZVMHAJEcKXsC0SdqhK5KiaMEUhKm4eAqmIM1jZZWPa5CdZSDqk1VdW2UTz631X2mDzUchPmf4AtECuH7PdWldP5jCCNMADcv2l6uyaOe50x6o0akHbfU4//oGSZuKrk+VdGOP8p2kxf+OxMzb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCV7PVa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCV7PVa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2AEC4CEE3;
	Wed, 23 Apr 2025 15:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422343;
	bh=F7KnCSeSJC9oYkWD1C3UePNd2aDRTDbb+WCv8YDf8Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCV7PVa+PRVYSizo2/paEpeuLLgEBaVsGztr3ZlDWWLb8IJNzKNpb2DVmwLYmR24+
	 2HlZ5gsz7kppC9rMJ46s0WlkLY36pGQ7BenWZXxO1tm49QYYkDsH/FG5IR/OJ32KHu
	 tjqNcSeGMIZwswSNhPy5CbKwdTdl/4rgauGasP6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Haisu Wang <haisuwang@tencent.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 280/291] btrfs: fix the length of reserved qgroup to free
Date: Wed, 23 Apr 2025 16:44:29 +0200
Message-ID: <20250423142635.868834732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Haisu Wang <haisuwang@tencent.com>

commit 2b084d8205949dd804e279df8e68531da78be1e8 upstream.

The dealloc flag may be cleared and the extent won't reach the disk in
cow_file_range when errors path. The reserved qgroup space is freed in
commit 30479f31d44d ("btrfs: fix qgroup reserve leaks in
cow_file_range"). However, the length of untouched region to free needs
to be adjusted with the correct remaining region size.

Fixes: 30479f31d44d ("btrfs: fix qgroup reserve leaks in cow_file_range")
CC: stable@vger.kernel.org # 6.11+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Haisu Wang <haisuwang@tencent.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1442,7 +1442,7 @@ out_unlock:
 		clear_bits |= EXTENT_CLEAR_DATA_RESV;
 		extent_clear_unlock_delalloc(inode, start, end, locked_page,
 					     clear_bits, page_ops);
-		btrfs_qgroup_free_data(inode, NULL, start, cur_alloc_size, NULL);
+		btrfs_qgroup_free_data(inode, NULL, start, end - start + 1, NULL);
 	}
 	return ret;
 }


