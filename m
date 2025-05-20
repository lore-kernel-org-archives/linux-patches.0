Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E0A270542;
	Tue, 20 May 2025 14:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750613; cv=none; b=KTObg2YJHFp9O8oj5optzvYqlE0k/W/d41zocYXZHhQRMD6rS9cieit03aLupM4zdNR5/PJxk4JazSSBcoHG9T2QNyDRT5q97MHvhSEeCh6ISOoa2HkzqIdljFotYphZZq2Cn4tkw5kTQ6yV1A4yDKj8+A8m3NyyJRPDYK98RO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750613; c=relaxed/simple;
	bh=DPIknEWvtsbJZ8MLhCBBtx4vsZfR5+07jW77C9oIi68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSWz3g3SK5qx3GlutHc3/PVAMzs9h50AVh9skxZuM69TjcyZu/LYx9Whv90Eo9bSuRz5AUWk/iCkaJOM1H6zPGZ0RDLaxz1dJnBlenx+P87X4aXZy4qup2w+32RvhQNYGdX30ZsddDpiRWXhPL/X4fUOlrD87FDo59hoLpx7lb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTz2GZYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTz2GZYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B05EC4CEE9;
	Tue, 20 May 2025 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750612;
	bh=DPIknEWvtsbJZ8MLhCBBtx4vsZfR5+07jW77C9oIi68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTz2GZYGXQJVa3er62ph2nbNEx08BBK6thpIAJ7X/YaJr4yPIq5jdemmAwA09ZBSa
	 zgQSMtC0lDijiJ+svXED9TymIWS6K6XhQL0N3tmxOJQJBnsfASM41RDuJTAO28HxGU
	 rxlYU7Bqrv0Dlm8S+at7JXpZHKWAERjOn5VXzOts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.14 065/145] udf: Make sure i_lenExtents is uptodate on inode eviction
Date: Tue, 20 May 2025 15:50:35 +0200
Message-ID: <20250520125813.127968482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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


