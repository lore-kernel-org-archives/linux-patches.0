Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4F23D5C06;
	Tue, 13 Oct 2026 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894413; cv=none; b=lKmUNtv45scJbapnGfvp3LdhJwORjVCKYuChPXKI0wVCcr1lZ9dUG8xJwUkDCsTQiPCdk2YoDR3QdoLJtAG9EhxJ+SCt1D9ewY8WQCg8NV3h0++mLXBe6Shj9j22bq5YIsdiO/xAOGnGdBsvN+8j51mSmBa3tgt8F6H6KxmbcFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894413; c=relaxed/simple;
	bh=H0C6BP8BxVbpX4yWHP3zNyVZd5pLMI/2H+BBjOU2kAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2rt3hn+LAsnC3wvMnbO6o1zWIkfArkUwW+0ndDQFs+kh00NpGdpS72WvPxFAZo4xiktIqHzeb/cqOb2a4jC05BR2z38evzEyGHQTKrYGAvmMpr4JIrZeRui7RaVEnqfiX9yVUUVtm2+clV7kt6IJmhQo5W2J2eZnnhL9/9B8QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ih/DBOui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ih/DBOui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D661F000FF;
	Tue, 13 Oct 2026 12:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894412;
	bh=Uoc71SKqBzAQ7iKw2i7jhYSFdB1k4STYq84+KMkx3M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ih/DBOuiowVxQp0bSoNEwjmMVhXJnHN7z9qskKYVyQhTHNAl8sXDjFYnuWTKtKkHt
	 kTn0GpOLuSkZfcVAJllxzZa00RhjNI8mDnCJKuifzSQBJbk1c7aYtbHQuCtLAKHdMp
	 NzH7+LgSNbd2TqJXrhaORI/ylPVpX2+DKGCtAP1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 552/621] btrfs: free iov when btrfs_uring_read_extent() fails
Date: Tue, 13 Oct 2026 13:39:07 +0200
Message-ID: <20261013112933.912811213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit a8ea92830b3e0e163d4e829bdcb17ca83c0f951c ]

After btrfs_uring_read_extent(), the caller always jumped to out_acct.
That skips kfree(data->iov), which is only correct for -EIOCBQUEUED
where the deferred path owns the iov. On failure, fall through to
out_free instead.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5d117c6b38cd4..fd663f8c0c52b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4928,8 +4928,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 					      cached_state, disk_bytenr, disk_io_size,
 					      count, data->args.compression,
 					      data->iov, cmd);
-
-		goto out_acct;
+		if (ret == -EIOCBQUEUED)
+			goto out_acct;
 	}
 
 out_free:
-- 
2.53.0



