Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D446D08B;
	Tue, 21 Jul 2026 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655112; cv=none; b=A5OaQZknGG1ud9/ZbUUotyXtIeNOBPaxrSJHujyQtm4a/FVwYANkxtYEvK0Gx9VIl370ljPUOhF/UhiJimICp3s46aHmEe3RyQ8zz1sKVrqLaZWJ0j1hIaUFcRub7GVT+i0idVxCuxwa6m1kL5n6ekjwTVSTssz3OhkVLjQnnGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655112; c=relaxed/simple;
	bh=9hW7KqUrebEvfFqDRDoIu7Wkg1TTea3e7oZGjSAEKvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkCOP3Xh+pFrYLBHSRZgsb0ILw6KV3RBJMtOCg9h5WS4wIJ5o+MGqcvCnNz30iqbFNcjBmLxUbUN6Hksqq1w2H1yRqe153FQ736AkJ5qMullx0A+GE3tMuc/CnBJZ4shVCwehv4lRsWyUCHyAawKfSMsk0n5pOUiGTu5dhS4G5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJ5Deyk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJ5Deyk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9751F000E9;
	Tue, 21 Jul 2026 17:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655111;
	bh=QE6Atcug40YpCxusWixmIE7hH2ZzLPDjSYJhKFnpKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJ5Deyk4R+FYJFgJahk/APDiF6fY9Xa7lzR3TItbwp8ENW+b244xyCEnPhICVrYSr
	 p2LzDqj9ZZev/1wSOuEUKbl/PnmToJjRb0aBvp26YC8UJ6FsjGQd7QItR0GncD73xY
	 25c+F4IsgP6UdS7Caw0HC2IYmtuhDybJkV4Wtb6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1960/2077] net/mlx5: HWS, fix matcher leak on resize target setup failure
Date: Tue, 21 Jul 2026 17:27:13 +0200
Message-ID: <20260721152638.939080636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


