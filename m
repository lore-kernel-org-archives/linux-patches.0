Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A9D1CAA7D;
	Thu, 17 Apr 2025 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913452; cv=none; b=ScrwDlLGcmboi/58ElEsloa156ci0NulIsTAaf2S6zIWhoDMYUaTw+UiWwJaLULjxULt+ect1fEKbVKv+CF4pElslymmI4CJa5WJI3mXjGDwctWzS/B7TBbMWh796VmjZd7oL8Q+3uOpXEKk7nrpnsltg7RFlDRfglZXrcRfves=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913452; c=relaxed/simple;
	bh=59E4pEidPfYLDnFnl9SvIswfq5NQCx31j2lOHVqcdak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1GNG34UB63YCkOnjP7NRmkn7MkOlig8KRI9AIfnnsNxKuiBkGpNefvZXoIr8qwuwVvmPDm40HfG13vS+suJ8sBPQiCGqtAOtOknSLUiiLnfA8fAVAev0asjdIaxGCxz3faxRL7nQUgp0Eu/vAsudJ7d78DFNn1hJm3bGs2tiCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsY4gMD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsY4gMD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777D4C4CEE7;
	Thu, 17 Apr 2025 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913451;
	bh=59E4pEidPfYLDnFnl9SvIswfq5NQCx31j2lOHVqcdak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsY4gMD6pta8uTb/CRBkKBtOrrqXyU03js1zXE52Sh6uluGaGM2vTTmrgR3CxQjPj
	 i5tmlidX/jtXtSlzK/Tlma/gZCqyqbyYWJ2LYBSm4v1lXF782vRw6gb3qvWW1/upEL
	 DKj+xblxmBTySGeI1r7Di7vlt1feOBC54zU+lzKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 344/449] btrfs: tests: fix chunk map leak after failure to add it to the tree
Date: Thu, 17 Apr 2025 19:50:32 +0200
Message-ID: <20250417175132.049690838@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 009ca358486ded9b4822eddb924009b6848d7271 upstream.

If we fail to add the chunk map to the fs mapping tree we exit
test_rmap_block() without freeing the chunk map. Fix this by adding a
call to btrfs_free_chunk_map() before exiting the test function if the
call to btrfs_add_chunk_map() failed.

Fixes: 7dc66abb5a47 ("btrfs: use a dedicated data structure for chunk maps")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tests/extent-map-tests.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -1045,6 +1045,7 @@ static int test_rmap_block(struct btrfs_
 	ret = btrfs_add_chunk_map(fs_info, map);
 	if (ret) {
 		test_err("error adding chunk map to mapping tree");
+		btrfs_free_chunk_map(map);
 		goto out_free;
 	}
 


