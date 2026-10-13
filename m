Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97672155C87;
	Tue, 13 Oct 2026 11:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892561; cv=none; b=Ilfi5MhBJ1+Lwu+ChYUz/WmmccB+3j6N5fQpbiP9GDUFOwVjmGrcljem99mNhjumGkLIY8SvQVJOUhP+bQCvMqKyIjQNo7YCLYRTyj0h1/44QLmjTK/JgInX6SA1K6gg6NXpWU+PRAL7/OOKuljHPfdH6gefiOn+L4ujhWJj3+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892561; c=relaxed/simple;
	bh=tDUFXxakIvFSM+PWki1roQS633uVE0fI3aNwAWvxu30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC+Yr+t2QTd1JBkkmdlNslAYUpcqRtofwSg/US10e3ZywSzqUkzLsHGUvWHVFHE8JK2Uv2xFs/AMgoqKDt+InoCVLlOoVkIbGrpRAQa/2Xepubsve6Qd1L3Gi9KCLwtQCaeaMXxm2PsnmrvhS3JwsdZe5m7AZ2rn/jrv72JDUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqPLV0DB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqPLV0DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0301F000FF;
	Tue, 13 Oct 2026 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892560;
	bh=Z0reLPZeuGFGB/1UIj5nKmLZF1PSYR6l+cqgwNgKbuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqPLV0DBceXF60igdf1maWo+tOxK6Q1Wpo4PYfCXP0rk+OLdJmQ2nsDOVxDMVpALq
	 T+1OZn56QKqUK+KXr1BKRWoMW/dQX0z8ni79vOsbH/LLYbO89s7mq6DdXlU7wSqcci
	 WgNrI3mKe4QxUBF1etFC83lWCSwEfKY/d1vDdv5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 212/281] btrfs: free iov when btrfs_uring_read_extent() fails
Date: Tue, 13 Oct 2026 13:38:48 +0200
Message-ID: <20261013112900.306822228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a537036303a47..0ac2f449134a0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4823,8 +4823,8 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
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



