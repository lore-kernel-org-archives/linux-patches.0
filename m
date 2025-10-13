Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F15308F39;
	Mon, 13 Oct 2025 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368751; cv=none; b=I71iUExn5bbwSX7Q1JGfsetUfIl6gvPT4tp0926n2IXXfc+O2kZUFjvnLfyhaCZJJtLyimZoK80mVE/9DazrastBm7FBRMqZQNDX8TMqcGwjHosGAQKSs1H6chc0fu4LVL0jq4WJV+Gx9SRGUXWkn/GbLaEYfW4PFpf0T4PYSIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368751; c=relaxed/simple;
	bh=gCG/bMa82WBCH9tHm/xlBTRdOypZ1INjdAFqt+W0P3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMrRA5CQ4ARCR1JiCV2pAplgN2niwXvAXV97mSnJk9xYmincGHu7JLbkIw/+dF/okFiXkroa1jPK8LfGCChbX42FUOchiFr7kEZSSP6JFNgQRMowq78iKsL6SlG8px9nkvTiPsBH/diW4Jz5T/ncHn5ac3l3HxYfFqDkZhdZNeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAXaHSUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAXaHSUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A53FC4CEE7;
	Mon, 13 Oct 2025 15:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368749;
	bh=gCG/bMa82WBCH9tHm/xlBTRdOypZ1INjdAFqt+W0P3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAXaHSUBcMCQhiyQHjAQKumSkTGqv1kDqp7Vc1L+CWLsbNv7/ia/0jz4K36ufFP6O
	 WFuPStM1J1IJlThmtnZpBJAr0SYFzS/YrmneTQHJzgGfgG38gufpqMDVTEiHD6VahV
	 jIr/ig/Ne5R3eVEeoKFaLIzTEY2D5WqtvdSAmCd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Ichikawa <masami256@gmail.com>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.12 255/262] tee: fix register_shm_helper()
Date: Mon, 13 Oct 2025 16:46:37 +0200
Message-ID: <20251013144335.418043539@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Wiklander <jens.wiklander@linaro.org>

commit d5cf5b37064b1699d946e8b7ab4ac7d7d101814c upstream.

In register_shm_helper(), fix incorrect error handling for a call to
iov_iter_extract_pages(). A case is missing for when
iov_iter_extract_pages() only got some pages and return a number larger
than 0, but not the requested amount.

This fixes a possible NULL pointer dereference following a bad input from
ioctl(TEE_IOC_SHM_REGISTER) where parts of the buffer isn't mapped.

Cc: stable@vger.kernel.org
Reported-by: Masami Ichikawa <masami256@gmail.com>
Closes: https://lore.kernel.org/op-tee/CACOXgS-Bo2W72Nj1_44c7bntyNYOavnTjJAvUbEiQfq=u9W+-g@mail.gmail.com/
Tested-by: Masami Ichikawa <masami256@gmail.com>
Fixes: 7bdee4157591 ("tee: Use iov_iter to better support shared buffer registration")
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_shm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -321,6 +321,14 @@ register_shm_helper(struct tee_context *
 	if (unlikely(len <= 0)) {
 		ret = len ? ERR_PTR(len) : ERR_PTR(-ENOMEM);
 		goto err_free_shm_pages;
+	} else if (DIV_ROUND_UP(len + off, PAGE_SIZE) != num_pages) {
+		/*
+		 * If we only got a few pages, update to release the
+		 * correct amount below.
+		 */
+		shm->num_pages = len / PAGE_SIZE;
+		ret = ERR_PTR(-ENOMEM);
+		goto err_put_shm_pages;
 	}
 
 	/*


