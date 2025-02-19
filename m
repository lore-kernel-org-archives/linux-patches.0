Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A71CDA14;
	Wed, 19 Feb 2025 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956321; cv=none; b=dooKNcjQuV/YtDvPaICm96a1tZGQrhs8qhzcdibiGFXE2n5wD+tx/PHhgecAT5OjziXv3XSoRhN3Lrwr/dFDnMNa9u6jwUzSfxfrGyuQoAlsodw6xtUglS46Pn/PGOaU/DGfJi9kHd2ZNyOXRAxJlwpJzJ5pItjKbv4Kx01UnEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956321; c=relaxed/simple;
	bh=TzLU45jrS+RLKVZpkT6a/voqj6XZC+5kxolyE+nbybo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW/v7/Mc8UygR0IzBPxBKbIIym9D/azmN9nwGHACcqgKJfaX0nwvley19wRwJQ1DgPb/CMHI+wLVqz7AlADsAb/M2T6RI3Khfhp/rwO2l/M8yG7k+MPO7jdUHhmGVsWlmZlvagp4Fo90nXSFkNQTim1XPqrhSwMsNE6KfHKRoWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3Ad7TMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3Ad7TMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FD3C4CEE6;
	Wed, 19 Feb 2025 09:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956320;
	bh=TzLU45jrS+RLKVZpkT6a/voqj6XZC+5kxolyE+nbybo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3Ad7TMomY2em6v5LiwXHCu+nIFUBG5aw4F1JfFJ9HEF7csxZxRAuKhQNKKdklHBv
	 OUClbvO/2Q+x157KGGDVGeRBEAkHLUNWa7OtU4fsacbSmA8lsQW1PCSVoTLnL+XZIk
	 PQ8vYu9nTiftgPKAEusYAG0EGPr01mCW03LsggPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/578] RDMA/mlx4: Avoid false error about access to uninitialized gids array
Date: Wed, 19 Feb 2025 09:22:23 +0100
Message-ID: <20250219082658.454390657@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 1f53d88cbb0dcc7df235bf6611ae632b254fccd8 ]

Smatch generates the following false error report:
drivers/infiniband/hw/mlx4/main.c:393 mlx4_ib_del_gid() error: uninitialized symbol 'gids'.

Traditionally, we are not changing kernel code and asking people to fix
the tools. However in this case, the fix can be done by simply rearranging
the code to be more clear.

Fixes: e26be1bfef81 ("IB/mlx4: Implement ib_device callbacks")
Link: https://patch.msgid.link/6a3a1577463da16962463fcf62883a87506e9b62.1733233426.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ba47874f90d38..7c3dc86ab7f04 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -384,10 +384,10 @@ static int mlx4_ib_del_gid(const struct ib_gid_attr *attr, void **context)
 	}
 	spin_unlock_bh(&iboe->lock);
 
-	if (!ret && hw_update) {
+	if (gids)
 		ret = mlx4_ib_update_gids(gids, ibdev, attr->port_num);
-		kfree(gids);
-	}
+
+	kfree(gids);
 	return ret;
 }
 
-- 
2.39.5



