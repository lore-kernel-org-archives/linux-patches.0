Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8BB250C18;
	Tue, 20 May 2025 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750212; cv=none; b=sM7K2cQYIS1a9U6bee9Z41KV6LegwuzhcTnU1QHdkTJRZhDYNNz2/t7dY7rK5tPyPo7MYDKTUKg6WNJK06qW5UDS9IZVhBSv3b9Vor3xGFmJJW8SYYspA7yEH0tS2iy3v79eHbds54mpfNJotXNtX7oRKcKZLdLjGnvZG1uy460=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750212; c=relaxed/simple;
	bh=5eJJW0LkTccGthSezKm7risl34GhLu3OH7WfC+V5osg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOewvsxUlxU6YLORtqE+ctOnSRNZ2DT2rnRu1eYKbI10SKj+RJHHaJi/2N74C862m2FVmfp9er6gkbblbiT93tZZkNpaRDCtYlQCKbxiJXU6pPWAgucvPMA3b1fJ7HwYil7hGjV3t4PIbGIJ7B1OasQLQhPB2TV40JNL4dsHsrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znnv7U0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znnv7U0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F86C4CEE9;
	Tue, 20 May 2025 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750212;
	bh=5eJJW0LkTccGthSezKm7risl34GhLu3OH7WfC+V5osg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Znnv7U0CPVmm7VX/y9tBU4CAiBOPAWxUOS7Q0YysAMAc4bOy2wqowX+fAWZWaJ5gd
	 KusAWww8LcjLtYC0UceYkP9FKVYHg96bHqE05xlfA+28caTUmf+atUHRAoUSkFp2La
	 U/iGBKwNuyhM3xPVChgrpw8qzy0i10NTfoNaUrX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 071/143] udf: Make sure i_lenExtents is uptodate on inode eviction
Date: Tue, 20 May 2025 15:50:26 +0200
Message-ID: <20250520125812.859749722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 55dd5b4db3bf04cf077a8d1712f6295d4517c337 upstream.

UDF maintains total length of all extents in i_lenExtents. Generally we
keep extent lengths (and thus i_lenExtents) block aligned because it
makes the file appending logic simpler. However the standard mandates
that the inode size must match the length of all extents and thus we
trim the last extent when closing the file. To catch possible bugs we
also verify that i_lenExtents matches i_size when evicting inode from
memory. Commit b405c1e58b73 ("udf: refactor udf_next_aext() to handle
error") however broke the code updating i_lenExtents and thus
udf_evict_inode() ended up spewing lots of errors about incorrectly
sized extents although the extents were actually sized properly. Fix the
updating of i_lenExtents to silence the errors.

Fixes: b405c1e58b73 ("udf: refactor udf_next_aext() to handle error")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -115,7 +115,7 @@ void udf_truncate_tail_extent(struct ino
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
-	if (ret == 0)
+	if (ret >= 0)
 		iinfo->i_lenExtents = inode->i_size;
 	brelse(epos.bh);
 }


