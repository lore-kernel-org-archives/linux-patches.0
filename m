Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778CD27FD62;
	Mon, 27 Oct 2025 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593257; cv=none; b=uYq7z8QGOF/aFIwoXGrYcKrKL/crnm1/LZg9+oHz1TbCjQGqHS1zQr3B3lOSuC+wRAqlMAnRigJvWNv4uq++KTITMoZ0BLLqQEkhrb1vY92JWZ8MT0oqcJTioClUPXhyK1cUwNNFigGs5Nr3tyLycVzhv6XAfOFktTuk+xoOJsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593257; c=relaxed/simple;
	bh=vRwFxBETmDPaBz21f7L8X4JaCCieBeH+xC80hhTEqL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmQZ4Kuo0xsJi/pgcjppmSxtTrAXo/t5MQky2bzgadcFGc85LHxtkBlBRoqIO1Lthw7Shtc9i5cIop8MQmkt0Tbl9afFTISiY1hqNTbbeB0wADaSJOXXQ/Rgj8z+QdNQZ0OsAB8VrrCH71wCl4pbSQvv6NUvziSTcO0RdiM4Yl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6Ytauxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6Ytauxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB727C4CEF1;
	Mon, 27 Oct 2025 19:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593257;
	bh=vRwFxBETmDPaBz21f7L8X4JaCCieBeH+xC80hhTEqL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6YtauxtrXZta/r5Rpf3FKOsE16i8GJdwsZ41QcBywo6hgRObal80xNSt7pIZbOM6
	 7Ku71QsSpvmlghXw/ozo3xKKL12WScUhKj9dQXGBDxmMYlvfY/l/8bJMGx+acZTmAx
	 1B73opyNIhbxhZuOtZaHFKweQteZGao8x1aNVe2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 035/184] net/mlx5e: Return 1 instead of 0 in invalid case in mlx5e_mpwrq_umr_entry_size()
Date: Mon, 27 Oct 2025 19:35:17 +0100
Message-ID: <20251027183515.861679238@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit aaf043a5688114703ae2c1482b92e7e0754d684e ]

When building with Clang 20 or newer, there are some objtool warnings
from unexpected fallthroughs to other functions:

  vmlinux.o: warning: objtool: mlx5e_mpwrq_mtts_per_wqe() falls through to next function mlx5e_mpwrq_max_num_entries()
  vmlinux.o: warning: objtool: mlx5e_mpwrq_max_log_rq_size() falls through to next function mlx5e_get_linear_rq_headroom()

LLVM 20 contains an (admittedly problematic [1]) optimization [2] to
convert divide by zero into the equivalent of __builtin_unreachable(),
which invokes undefined behavior and destroys code generation when it is
encountered in a control flow graph.

mlx5e_mpwrq_umr_entry_size() returns 0 in the default case of an
unrecognized mlx5e_mpwrq_umr_mode value. mlx5e_mpwrq_mtts_per_wqe(),
which is inlined into mlx5e_mpwrq_max_log_rq_size(), uses the result of
mlx5e_mpwrq_umr_entry_size() in a divide operation without checking for
zero, so LLVM is able to infer there will be a divide by zero in this
case and invokes undefined behavior. While there is some proposed work
to isolate this undefined behavior and avoid the destructive code
generation that results in these objtool warnings, code should still be
defensive against divide by zero.

As the WARN_ONCE() implies that an invalid value should be handled
gracefully, return 1 instead of 0 in the default case so that the
results of this division operation is always valid.

Fixes: 168723c1f8d6 ("net/mlx5e: xsk: Use umr_mode to calculate striding RQ parameters")
Link: https://lore.kernel.org/CAGG=3QUk8-Ak7YKnRziO4=0z=1C_7+4jF+6ZeDQ9yF+kuTOHOQ@mail.gmail.com/ [1]
Link: https://github.com/llvm/llvm-project/commit/37932643abab699e8bb1def08b7eb4eae7ff1448 [2]
Closes: https://github.com/ClangBuiltLinux/linux/issues/2131
Closes: https://github.com/ClangBuiltLinux/linux/issues/2132
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20251014-mlx5e-avoid-zero-div-from-mlx5e_mpwrq_umr_entry_size-v1-1-dc186b8819ef@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 3cca06a74cf94..06e1a04e693f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -99,7 +99,7 @@ u8 mlx5e_mpwrq_umr_entry_size(enum mlx5e_mpwrq_umr_mode mode)
 		return sizeof(struct mlx5_ksm) * 4;
 	}
 	WARN_ONCE(1, "MPWRQ UMR mode %d is not known\n", mode);
-	return 0;
+	return 1;
 }
 
 u8 mlx5e_mpwrq_log_wqe_sz(struct mlx5_core_dev *mdev, u8 page_shift,
-- 
2.51.0



