Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068441474CC;
	Tue, 21 Jul 2026 18:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659347; cv=none; b=ERqDCs+g2J+FYR6JKz7tNJWvIZQs6B3HO1/7+wUz+XZ1rNPQFdyheo5PNG+xRtsmpDYOu22kmhxt/ldyBgxpOzFClzckeC8kbCHcKCp0Yqog0yk4rxyb1PoxQGMBvsOlnnwlUjLftXaP9438D3lJUXY+n8O75S/iIAg7bceO5PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659347; c=relaxed/simple;
	bh=hg8dher7Ie5yVf0o/YsRa2U0QwnW4DDxQsGbGyfWwzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkU+HCvynkc7knBfmqtm4OU1CKVQSg5Qh6FdcC0VmIQUlSh9I1ahn+j7Qh/NHa1/LsngMK2TURnqz5nzdPKFwIoA1OQTNZUe6zknNZ8bQDse+UXOmnzhaJBm1ljLNK24djYaYddEDKI/8IX61ZbrpY+DkE/sH2Tj8Z/rqL7ddNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbK3uQ/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbK3uQ/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D81D1F000E9;
	Tue, 21 Jul 2026 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659345;
	bh=kvdtLY7Nu8vXBXLwtD6+mFhTSrQnV+x/pCeiWY4Q+5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbK3uQ/LSHcHAr9qH4Y1gDX6Y47hC03pPgu1k4y9PQZCydsSgHw7rrC7mTOfmCHya
	 TIufkh7NUHh/1LbC8QV92SE3GsHHEdkTNzugz3+UYZDGxKrikA4XWn5zDZQvSxZQ1e
	 wP0XLz28wjQv8OXDiad4XKN660FMB3k7XiZrYYjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1443/1611] net/mlx5: HWS, fix matcher leak on resize target setup failure
Date: Tue, 21 Jul 2026 17:25:59 +0200
Message-ID: <20260721152547.906420698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit bb09d0e64ecaa0aa0f7d1133a1696ed74dead295 upstream.

hws_bwc_matcher_move() allocates a replacement matcher before setting it
as the resize target. If mlx5hws_matcher_resize_set_target() fails, the
replacement matcher is not attached anywhere and is leaked.

Fix the leak by destroying the replacement matcher before returning from
the resize-target failure path.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. As we do not have a
mlx5 HWS-capable device to test with, no runtime testing was able to be
performed.

Fixes: 2111bb970c78 ("net/mlx5: HWS, added backward-compatible API handling")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260629064049.3852759-1-dawei.feng@seu.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
@@ -205,6 +205,7 @@ static int hws_bwc_matcher_move(struct m
 	ret = mlx5hws_matcher_resize_set_target(old_matcher, new_matcher);
 	if (ret) {
 		mlx5hws_err(ctx, "Rehash error: failed setting resize target\n");
+		mlx5hws_matcher_destroy(new_matcher);
 		return ret;
 	}
 


