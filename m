Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E011D5ABA;
	Wed, 25 Feb 2026 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982857; cv=none; b=kySXgpQZqYHDvPBQH9b+5pTYEhLxIHH9hOC/bkZrKhYHdca+z3g8+oZowXM0HbzZyDOyvhhhVPvOgdCsQDgHCNfWe8cEm5uq/sFIUOKCvhbhFv9yQLDS0NjTCeKxUEwF/gn1e4bi7aCXuaRiYVqGNjOiTSzW+Jl9TPXqujPQ1m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982857; c=relaxed/simple;
	bh=AJO7akBsxVRcF9ta5VcA3OdUO15Us4NoKyl4Z09KWTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siJnWraf7rxfW4nbogTQ5q3QaLM9R7w7bY0KcEFHxdiWzMomCm1v5t1zn+BxZNU9JCLHclCbbvYb6l+jxSy0VgIwuQKSWuZ7GrDBC+zgATSr+1rzoUr6wPFUfmuSnw+vJZ9ZJ+9zxkeu3Aeth7YTyBT0yc8HQo5xBPQCoO1CMCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTYD1A6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTYD1A6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84482C116D0;
	Wed, 25 Feb 2026 01:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982857;
	bh=AJO7akBsxVRcF9ta5VcA3OdUO15Us4NoKyl4Z09KWTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTYD1A6Jb7pfwWEME2o+z1EL62+hUIvtYpB8p2GbsvFn8E/yY7Wnj7qRYZNLlVLDx
	 8MmuqyKY+OWPx3//jTH+KziVGyg6Knvv1jL49hoTYbNV1N5dspSjMM2kZlk9ot9g3K
	 MpI9Zle7sMqGJLLbMfTGVPz53Jwp8ipgJVsiGrT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 046/781] md/raid5: fix raid5_run() to return error when log_init() fails
Date: Tue, 24 Feb 2026 17:12:35 -0800
Message-ID: <20260225012400.833935284@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 2d9f7150ac197ce79c9c917a004d4cf0b26ad7e0 ]

Since commit f63f17350e53 ("md/raid5: use the atomic queue limit
update APIs"), the abort path in raid5_run() returns 'ret' instead of
-EIO. However, if log_init() fails, 'ret' is still 0 from the previous
successful call, causing raid5_run() to return success despite the
failure.

Fix this by capturing the return value from log_init().

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-2-yukuai@fnnas.com
Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601130531.LGfcZsa4-lkp@intel.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8dc98f545969f..a85878b009f9a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8057,7 +8057,8 @@ static int raid5_run(struct mddev *mddev)
 			goto abort;
 	}
 
-	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
+	ret = log_init(conf, journal_dev, raid5_has_ppl(conf));
+	if (ret)
 		goto abort;
 
 	return 0;
-- 
2.51.0



