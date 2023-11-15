Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950723BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/Kn+rkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4256CC433CA;
	Wed, 15 Nov 2023 19:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078018;
	bh=+BLa5JGrjeZojACRRuh3oiJFceKujcYJEo8qiqL+B6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/Kn+rkjhbNkaY62CYufFsFMKEb7B+SOS0y9PnzZHICYfIaXfGTn7si26Sx6hD2+v
	 mmnyy+Sqk6DZcW0aijU7LhrT0uXT46AdYFBNiKjBez/o7M07j2ceqR5AW4zQvwXs2j
	 HM7KKqTq+NUcv3Cmn71Rp+8YV3VQyjQBGLDa9vYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/379] mlxsw: Use size_mul() in call to struct_size()
Date: Wed, 15 Nov 2023 14:21:49 -0500
Message-ID: <20231115192647.179651425@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit e22c6ea025013ae447fe269269753ffec763dde5 ]

If, for any reason, the open-coded arithmetic causes a wraparound, the
protection that `struct_size()` adds against potential integer overflows
is defeated. Fix this by hardening call to `struct_size()` with `size_mul()`.

Fixes: 2285ec872d9d ("mlxsw: spectrum_acl_bloom_filter: use struct_size() in kzalloc()")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index e2aced7ab4547..95f63fcf4ba1f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -496,7 +496,7 @@ mlxsw_sp_acl_bf_init(struct mlxsw_sp *mlxsw_sp, unsigned int num_erp_banks)
 	 * is 2^ACL_MAX_BF_LOG
 	 */
 	bf_bank_size = 1 << MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_BF_LOG);
-	bf = kzalloc(struct_size(bf, refcnt, bf_bank_size * num_erp_banks),
+	bf = kzalloc(struct_size(bf, refcnt, size_mul(bf_bank_size, num_erp_banks)),
 		     GFP_KERNEL);
 	if (!bf)
 		return ERR_PTR(-ENOMEM);
-- 
2.42.0



