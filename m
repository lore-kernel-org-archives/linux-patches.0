Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DAA15E8B;
	Mon, 30 Dec 2024 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574339; cv=none; b=PU1Rl4BNOlgoE0cuxJxKCcD23wl5Fjyc0KNL2NyMeg5w/9TAAUHseuZeSSwjR2nu6ir70OO8ACctmjmAtNa3+Vo/vB01KLhW5xnmbcfayugY1SxFVC96sUu5HYy6JseLBQnXhdENmvecp0/IszBsLQyjwZ5kTN2MNQHlYQ6eHKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574339; c=relaxed/simple;
	bh=jXzA9h4PjNzvsbYizHn3iGcAKZW5uPUaz40D1UCEbHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxbvXNRF+7rdNZnyKxXbJq1SNJJ6li/5eN7fOz2b1XyHCkd6XYIQUh75IYp5DVvCqGcMhYi2ujeZDtYDdZFi6+flUA2KLQ1Ev+YZ50h1p7iAZTn/LOnLp4142pAuv6wT047LtVVuINEvYdZCnXU8ILNKtu/EVEEPg8FkNBmmp2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DctueX2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DctueX2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918A9C4CED0;
	Mon, 30 Dec 2024 15:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574339;
	bh=jXzA9h4PjNzvsbYizHn3iGcAKZW5uPUaz40D1UCEbHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DctueX2RxHCSEGFMAxXqQdMgwP+YzU1et8UwqIMF3BHSrCJJzUhfX2cWvRa+JLY7j
	 +pJmY45s4XLfETE6M3RgJ5/SQ4vNJSOXNEKFWsYsRkacHX2h1IT0lxSz2IBzZGQYTq
	 FiOpLgqr9r7Yagan0AZH8wx/3mEhGjjrErtx7Sc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 107/114] btrfs: check folio mapping after unlock in put_file_data()
Date: Mon, 30 Dec 2024 16:43:44 +0100
Message-ID: <20241230154222.249467268@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit 0fba7be1ca6df2881e68386e5575fe096f33c4ca upstream.

When we call btrfs_read_folio() we get an unlocked folio, so it is possible
for a different thread to concurrently modify folio->mapping. We must
check that this hasn't happened once we do have the lock.

CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5291,6 +5291,7 @@ static int put_file_data(struct send_ctx
 		unsigned cur_len = min_t(unsigned, len,
 					 PAGE_SIZE - pg_offset);
 
+again:
 		folio = filemap_lock_folio(mapping, index);
 		if (IS_ERR(folio)) {
 			page_cache_sync_readahead(mapping,
@@ -5323,6 +5324,11 @@ static int put_file_data(struct send_ctx
 				ret = -EIO;
 				break;
 			}
+			if (folio->mapping != mapping) {
+				folio_unlock(folio);
+				folio_put(folio);
+				goto again;
+			}
 		}
 
 		memcpy_from_folio(sctx->send_buf + sctx->send_size, folio,


