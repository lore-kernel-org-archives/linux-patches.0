Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136E743E4BA;
	Tue, 16 Jun 2026 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626841; cv=none; b=cGvYbXtDGawBxp9SzxmFQqrX1NEx8LpYrDJfJ+3cra/HV64b1dR67AuOsacM79BoHUFwDFclB2h14L/JNQRVUZuIjHucKtUBBx4tq9uZ06U9V/7QyHv1gdKjIoNYuyuFVFHc4dhnlCnyRZ51ZOO3/RNOdDHJacH3xSX7jdb5o7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626841; c=relaxed/simple;
	bh=I3kFYEj/WBizKX5ui1kA9WgCae5X8RlwkVhcKrzA8AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAN7z8hXTgT0RqXngCBhGrtwLU3SFaIoPC1jGSemnZIAA9Z0m5sEJZ3VJWUbATo20XWGUEbh9ldWAIW0WZeUUS03Q9xn5JVMOSOYkXY9l75DyUIFNXtGoYcXcyDMzpaz2RnwgAzAm5AapfrwFYeD3cqttI69AjXMt2H26bI5Ndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJnBoM+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJnBoM+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15D61F000E9;
	Tue, 16 Jun 2026 16:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626839;
	bh=k1b04kIU2LbQuWU1tYIc0kdsBYegINk633pi7o8Ltss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJnBoM+ZnIVrRAuFaOGdkWYTnWyrOn3UkI0UVU5cIQfvCkyb6jq5QR9Gy/UU56dvA
	 o27CPWVr3RjSEHTaQlEvpZ8JAucQQryrXiKIqrhtZ6UcuFqnGnw7gVNRXyxSYQ+lra
	 4BwmvnY3HDGavFw1y80+gtWN6/zUCogS5q6d8bgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Sang <sangyao@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/261] net/mlx4: avoid GCC 10 __bad_copy_from() false positive
Date: Tue, 16 Jun 2026 20:28:38 +0530
Message-ID: <20260616145048.783332786@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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



