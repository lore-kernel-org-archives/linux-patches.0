Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A07427F163;
	Wed,  4 Feb 2026 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218942; cv=none; b=flURjKrpQY7IrPmOxNmYKDboNlSr+MjNZE/QD7qfJpetlH3ALhA7cS4n1jzeuaX2lJOJMeO75L84V0jRKQBHv4EszLnAAr5dc6V0oWaowbls4O5nI4H/LVUP7RLoeWeKDTCywItTmcwoTtb8JwxUgMrx2rnOgXgbIG5cLslrtD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218942; c=relaxed/simple;
	bh=fW8YkMmwBeWot5NfO4UwNbbEbDAZT0u/G6MUt+tgTQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCnzPFkdw9nK02tdvmXXG+Jenxp2bnOVqcq+cZDZz8djt9Ct+i6a2RHcmFIU3k57cLEFoS45LlIdhGZC1koQM8uxOdDX4hOU9QiNZyrVdjHkogU8qU77NHsKVTmACmE6MqLUOSkSJVsCYH2qgRXiPMtV6wDWRfTPhFBOEkDb0fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgHA2Ysq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgHA2Ysq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5D2C4CEF7;
	Wed,  4 Feb 2026 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218941;
	bh=fW8YkMmwBeWot5NfO4UwNbbEbDAZT0u/G6MUt+tgTQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgHA2Ysq4xh2x6UjNc7UMyRMq2iseAMSL6ctFWtbGh+qBp9vg12RNZVV1yQKelpak
	 aUxws7bEBuNf6AfW+xSf9zYh/F1bjQ8vj3uuhUNLfv8Ho/VmmUSsSofosp5W/K9Vs9
	 UtYZRoVSutATyDsrGl490JhyNKSMNe7lrq+hRvRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-s390@vger.kernel.org
Subject: [PATCH 6.18 002/122] btrfs: zlib: fix the folio leak on S390 hardware acceleration
Date: Wed,  4 Feb 2026 15:39:44 +0100
Message-ID: <20260204143851.948762654@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 0d0f1314e8f86f5205f71f9e31e272a1d008e40b ]

[BUG]
After commit aa60fe12b4f4 ("btrfs: zlib: refactor S390x HW acceleration
buffer preparation"), we no longer release the folio of the page cache
of folio returned by btrfs_compress_filemap_get_folio() for S390
hardware acceleration path.

[CAUSE]
Before that commit, we call kumap_local() and folio_put() after handling
each folio.

Although the timing is not ideal (it release previous folio at the
beginning of the loop, and rely on some extra cleanup out of the loop),
it at least handles the folio release correctly.

Meanwhile the refactored code is easier to read, it lacks the call to
release the filemap folio.

[FIX]
Add the missing folio_put() for copy_data_into_buffer().

CC: linux-s390@vger.kernel.org # 6.18+
Fixes: aa60fe12b4f4 ("btrfs: zlib: refactor S390x HW acceleration buffer preparation")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zlib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 6caba8be7c845..10ed48d4a8466 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -139,6 +139,7 @@ static int copy_data_into_buffer(struct address_space *mapping,
 		data_in = kmap_local_folio(folio, offset);
 		memcpy(workspace->buf + cur - filepos, data_in, copy_length);
 		kunmap_local(data_in);
+		folio_put(folio);
 		cur += copy_length;
 	}
 	return 0;
-- 
2.51.0



