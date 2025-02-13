Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F7514A605;
	Thu, 13 Feb 2025 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460582; cv=none; b=Haed0OmdFYbr5D4FkcgaftJsk8o7HeUGUEMEIp/4aeMdROkvINC7l4juYJludIUnCs3MMNrz70b79mEO5seKBmmRaOxQ9YsTpquKBBC71+DKkaE7+0fgln/GWYNw4v/L32GsPRu6AGmRBpLzXSIraMXjfSw+rzcsV3abvCUxLJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460582; c=relaxed/simple;
	bh=A8TwQ8rCjc+WS4aOGH40voXoYx2EpNF8wSiqyk2uRGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgdGUad8WaYsheMAlNC9Kfj4C6Bmi8lHidxZ3LkoX2MZh9JCIJjcLHK460u8ZT5UtHTAXgDXidFI15drPj8yEkbkGRqtpzW88wy5mkrcaE/DSGUHJm1AVRXT7UUH43IhRWDxKEuROUkWe7EVEhjb5VOl5v50cE36NMfdyNuBC1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XE3S2bIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XE3S2bIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B6FC4CED1;
	Thu, 13 Feb 2025 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460582;
	bh=A8TwQ8rCjc+WS4aOGH40voXoYx2EpNF8wSiqyk2uRGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XE3S2bIvpMmznf4e6ru8Dy+nH97nQg1vvay52h5VZULMyG+bPRfsM7r2DxGGcfLLn
	 zCnx9gKvJGyWb6yemRrPgtNh9QO6de2K4DhNMdyoMQqJZpK3J5885kCMgAvNhGdsX4
	 xAparUCvjE6wI9sqg1o31t6Kys0MDlSWT2VAkgnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 153/273] block: dont revert iter for -EIOCBQUEUED
Date: Thu, 13 Feb 2025 15:28:45 +0100
Message-ID: <20250213142413.386309560@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit b13ee668e8280ca5b07f8ce2846b9957a8a10853 upstream.

blkdev_read_iter() has a few odd checks, like gating the position and
count adjustment on whether or not the result is bigger-than-or-equal to
zero (where bigger than makes more sense), and not checking the return
value of blkdev_direct_IO() before doing an iov_iter_revert(). The
latter can lead to attempting to revert with a negative value, which
when passed to iov_iter_revert() as an unsigned value will lead to
throwing a WARN_ON() because unroll is bigger than MAX_RW_COUNT.

Be sane and don't revert for -EIOCBQUEUED, like what is done in other
spots.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -718,11 +718,12 @@ static ssize_t blkdev_read_iter(struct k
 		file_accessed(iocb->ki_filp);
 
 		ret = blkdev_direct_IO(iocb, to);
-		if (ret >= 0) {
+		if (ret > 0) {
 			iocb->ki_pos += ret;
 			count -= ret;
 		}
-		iov_iter_revert(to, count - iov_iter_count(to));
+		if (ret != -EIOCBQUEUED)
+			iov_iter_revert(to, count - iov_iter_count(to));
 		if (ret < 0 || !count)
 			goto reexpand;
 	}


