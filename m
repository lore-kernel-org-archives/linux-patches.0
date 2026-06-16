Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB50946AF3C;
	Tue, 16 Jun 2026 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631654; cv=none; b=UDGrYVAf/08IgtxVPeG+d4Xa8zV8KZ2cRBNReOWgUCOhYHLfIs9/JxdZ6x0e95YdqefiZfwOLYew9V/ssxoUACUOWC/C8pD8wrCl2/jCYtZB0ve6bd2WmlEBrXJIFSwqDfhyr4LhnLy8/c1rv56fcCt8T+8SgFe8pJkdejXueGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631654; c=relaxed/simple;
	bh=z3/nMbIPwWEHJ2rvOh+tQDMvjqwDj2nTMH4ETEMz1YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFLm3TbJIeeYO9+bDOkyjdgBvXyJza8tK4+513pmgQd2d0E+ZpZpMSmo3QQKeC34Ou/coryOE0hLlKr9XSHJ3t9DxmDCcL1SvPgIEY2iefvsdFMkkDzlQbcRwhqWkdzAgQlRCOGNeHlYLHvgg3j23lnG81OwgO2KlbgT94GhwbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+DDWRGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+DDWRGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13FA1F000E9;
	Tue, 16 Jun 2026 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631653;
	bh=RlAqIlol1ea0NA+9Vhsxiu348vnnGoiHHW2O522FwWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+DDWRGWzZVumkYH2vtXxuJul8+tQzfWK6SAXbANRTPjX752BlwMDp9PqaAAee1Mg
	 jIpiEVC78ahRQinvTxG1w6fTM4ncC+EXe34uKrFDSSThVAsx1ORMK0cO0zY692pwPf
	 wujJZlTfYLc6SOKgn0jk0HFc5VzyEIHXE84Dvd2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Sang <sangyao@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/522] net/mlx4: avoid GCC 10 __bad_copy_from() false positive
Date: Tue, 16 Jun 2026 20:26:31 +0530
Message-ID: <20260616145137.395405405@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4d4f9cf9facb87..fb83d8af8dcb9c 100644
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



