Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089CF3A8746;
	Tue, 16 Jun 2026 15:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623420; cv=none; b=f7GWSfxXcH5zcNkc2XHNlkgAhyp3CIyid3UENPzN+vQMRHXQRZUUj+KmD+3SDuo6h81mv/+Otp+zFvM3p+S2ATe5FZNLlHaGpKuIv254SIf82VFZrx8EcEMc3DWiHQllYc9i6zygrrvmbnmBfmc5oKfVL0XXVMBRLru0QlMFG2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623420; c=relaxed/simple;
	bh=6FNB3YrPAjex26SUC3BUROkw9ewRmT+V/v2SQ2HlfB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvarAXgyrYlYsDAq3ef18rY85PRWljJYjFUssqPs5zMjGxGLrn+H2NQQAqu/DdqO4KMZBofSk1ZfGb1HNcOb/tZyiFW0UdgcU3yUIx2X+tqAOgD9/U2jCe4tFNDRj7nYnPX3dPSudePSLo8JO/CkvvYmS24ycGPu4xlJQ0Lwb/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JAtq/x2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JAtq/x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937FB1F000E9;
	Tue, 16 Jun 2026 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623418;
	bh=kwlLgrei6NSxEzN6qzOty/6LB9lG++nJWAhg8W81WF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JAtq/x2cObBFBdgQVo7wzN/jTKajCm7oV8sZN1FS88MIUCZmrUqbiSxxJ4GHXq3P
	 OhQaPLRVditxfa6tNLZi1oFAD2nH9ewMKPTJ4JMdwlSQmjEtPcnvNra8IgYcfHF8Pw
	 vhwn2ZbLu9I0EB+NFBh1/RoKvP9V8eAnV9kvhHfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Sang <sangyao@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 111/378] net/mlx4: avoid GCC 10 __bad_copy_from() false positive
Date: Tue, 16 Jun 2026 20:25:42 +0530
Message-ID: <20260616145116.218044527@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 2365343f4aad3e1b1e7a2e87e98cf66d5e590589 ]

mlx4_init_user_cqes() fills a scratch buffer with the CQE
initialization pattern and then copies from that buffer to userspace.

In the single-copy path, the copy length is array_size(entries,
cqe_size), but the scratch buffer is allocated with PAGE_SIZE. GCC 10
does not carry the branch invariant strongly enough through the object
size checks and falsely triggers __bad_copy_from().

Size the scratch buffer to the actual copy length for the active path,
keep array_size() for the single-copy case, and retain a WARN_ON_ONCE()
guard for the PAGE_SIZE invariant before allocating the buffer.

Fixes: f69bf5dee7ef ("net/mlx4: Use array_size() helper in copy_to_user()")
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index e130e7259275a3..5c55971abbf072 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -290,6 +290,7 @@ static void mlx4_cq_free_icm(struct mlx4_dev *dev, int cqn)
 static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 {
 	int entries_per_copy = PAGE_SIZE / cqe_size;
+	size_t copy_bytes;
 	void *init_ents;
 	int err = 0;
 	int i;
@@ -314,8 +315,14 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 			buf += PAGE_SIZE;
 		}
 	} else {
+		copy_bytes = array_size(entries, cqe_size);
+		if (WARN_ON_ONCE(copy_bytes > PAGE_SIZE)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		err = copy_to_user((void __user *)buf, init_ents,
-				   array_size(entries, cqe_size)) ?
+				   copy_bytes) ?
 			-EFAULT : 0;
 	}
 
-- 
2.53.0



