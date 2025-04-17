Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70FC2641EC;
	Thu, 17 Apr 2025 18:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914821; cv=none; b=k1sFrFLRiZRefe7F8YtqBRphS1MFEm/8XPP2b9XtkYthqTPPH1BlCJNxRumsBr2PuFTPfhiTnazBbbqdfE0qj8af2Wb6jiXG28aPiAAd44TccU5uPVU97vMXWMbxQlofYqCvKypRjWjKvyP1xevpgh7HlUwjCRiFLRi1lzM3PKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914821; c=relaxed/simple;
	bh=Tdix3TNh8I1qdnZSSuqRSSW0KAJqRt9WqGhOiiuEaGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7DNJuPdkU0OVI6lAKqWM3j+EPrgXt/NA9Pn4IDN/P1WkAEGFWtwyTDKVvH8lLlvIRLylTZDNbtPm0hVQPFdHKLpLScOPGvW+kSAJ6sXo4GE92zIQeGQw5lUw2ualYKI20ZgShorxHbuNnVgxuijhIBr4WQpkRGcOOl4FXyRMjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIXwacvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIXwacvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAB8C4CEE4;
	Thu, 17 Apr 2025 18:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914821;
	bh=Tdix3TNh8I1qdnZSSuqRSSW0KAJqRt9WqGhOiiuEaGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIXwacvTP90SrVoOwEbUAAwiqck0YryqyDBoWXFQ6T8BnbvhAtjWF6DX5ZQh33W/t
	 tZA37BGZZiX4nm++iQS3HVf3gPT5kWVLjqVwnp+aMwpbDeHMvMmbwjPmYCk6k7mQ6a
	 DQ8X7IO/qOcBhEx14pN15DCGa1WNmwCKE7sTj22w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 313/414] btrfs: tests: fix chunk map leak after failure to add it to the tree
Date: Thu, 17 Apr 2025 19:51:11 +0200
Message-ID: <20250417175124.021405901@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


