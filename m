Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE55C411689;
	Thu, 30 Jul 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426963; cv=none; b=pPJ5SFwbOPAUjLdANfl8MhWmiBhz23YbO8heVCVTgYQXnZ329jTiKx+3IGbv8hEbmKoZXM4bw4nruVfTJYNmOURQoB2s1BZLQO1Gyzl0brVcyRhPDnskHchPLYmYvwRDj1yHgCZlui8rh11AHX2USkkJu56SnqlTYVPxAY6zGaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426963; c=relaxed/simple;
	bh=C93krHsrlfVtunK0pWwD8hJcqFsMVQLixrvO0PLJnW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujY6mbZ7gmkb3v+ujBXVgXjIAlm0qKDbxzpySXX82fstZvwgM47V9OubRJEWWLR7wyOnmnp/FvDcSU7xFd8JiTsp1fii14PHha5wn5QEQU3Fut1f5L+JFKcvm1/+KQN23SKh1PbZLHJPDGQjaTtz0rqOste4gdkBibdQme67UuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyZjuNte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyZjuNte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3553C1F000E9;
	Thu, 30 Jul 2026 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426961;
	bh=nX9BjPvtxOH4FN8wJj0arE4aoVmesz5unAVYPjnLIrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyZjuNte8Zeyl0QyrcsNmdK0FZaLOquzSnWUNWK2S5QmhVprFM9fkXJSYuw7teHv1
	 XNWCIlGDOYcHGKLjlD73893zP4NhmMMz5Vnb84Pp0IXjslcmabTlDN0zjfXtponZ1i
	 8raxwNgz2K2usaldoxb5Pr7Puw0OPY4UTB49k8F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 566/602] net/mlx5: HWS, fix matcher leak on resize target setup failure
Date: Thu, 30 Jul 2026 16:15:58 +0200
Message-ID: <20260730141447.939006225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit bb09d0e64ecaa0aa0f7d1133a1696ed74dead295 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.c
@@ -225,6 +225,7 @@ static int hws_bwc_matcher_move(struct m
 	ret = mlx5hws_matcher_resize_set_target(old_matcher, new_matcher);
 	if (ret) {
 		mlx5hws_err(ctx, "Rehash error: failed setting resize target\n");
+		mlx5hws_matcher_destroy(new_matcher);
 		return ret;
 	}
 


