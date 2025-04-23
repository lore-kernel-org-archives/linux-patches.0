Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71721A0BE0;
	Wed, 23 Apr 2025 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422569; cv=none; b=ZrIRkRbqNkucP1kP3dZsaa37g8UDE2QQqNn74xg/UyfzYzDNcxqADzWhgOuZ4/okaoQltWskc9r1HqQ0zlrA7Is0INnI43eYO2PNjSSgLUgasqZ3wjuLgrY4z4OQ8FNnEjqByJfd3ZksNs1DB+uHAA/r4Dcfh4Ese7YC2N6fYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422569; c=relaxed/simple;
	bh=wYCOv9VA0JmWtWm6Rxy7+IU4H2JwA0jvSO56xNx3a3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDGx8Lg1EM1SpdXxg9ftXOhZ0gkbPLZXmF9ANOvU8C2I3hzAE6jXsqeBib90IWF2fsK3QVUQUYzvF6pxy2ojoO+RHfVP35B3Gyi1d6anTsV2sMdmAn/pAMVbLtO/fWTAjwtG5mhJYUaDD8dIhw2VfyYAsL31MFyrRmwJSBxafNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTdREI5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTdREI5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B91BC4CEE2;
	Wed, 23 Apr 2025 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422569;
	bh=wYCOv9VA0JmWtWm6Rxy7+IU4H2JwA0jvSO56xNx3a3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTdREI5rbr8+fG/HgnnQINDbz+wg6jGIXjnJRIdRZCT2zLkr3if3T60YVnA4B1J9I
	 4w8UGOpUofJlRFxq5D+SxOhCM2T8mLDRDPz1vyZ/bnIzAPcm+hcJtlGG8JSqpBM9JC
	 DgfDRjq8JDPaR8kQCajII9c3kM8bRuaMGqWOY9WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Haisu Wang <haisuwang@tencent.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 392/393] btrfs: fix the length of reserved qgroup to free
Date: Wed, 23 Apr 2025 16:44:48 +0200
Message-ID: <20250423142659.507581822@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1560,7 +1560,7 @@ out_unlock:
 		clear_bits |= EXTENT_CLEAR_DATA_RESV;
 		extent_clear_unlock_delalloc(inode, start, end, locked_page,
 					     clear_bits, page_ops);
-		btrfs_qgroup_free_data(inode, NULL, start, cur_alloc_size, NULL);
+		btrfs_qgroup_free_data(inode, NULL, start, end - start + 1, NULL);
 	}
 	return ret;
 }


