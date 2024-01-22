Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE63149010;
	Tue, 23 Jan 2024 00:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969189; cv=none; b=G3kmxFi9TNu2MN5FmNpgMDasIGoaGf8jgCVjqQwJd45YhCvAuVHs5IcXIjgaWZo5Otd8k/NquLrFysQrC5qeQFirm6ninWwzT2c9ZF6vHcJRVIrhudJ0JKN3YSAens92FWMqYSZYZGygHJm3bxqEUjpqRo3+UfNOwv1j16yZiok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969189; c=relaxed/simple;
	bh=uaCuyBsde9+Fb0SXgHVfasv6koX/zoR9apwmp4HDmtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbrUfihSYg8F6hzaB+KEW5kEWUFYWYrQZGNkCGtyGh1ft8lplhhHkqlZoBf3x+TNs8jawJjNHRbE5pLppRh12ZfrJiZwmXQTgT9EolBFK9SWbFBI7t54e44ZYfrvf0k3slg4WIZ05f5BDspAnS1jOEiJiAyVUL8NchKB4d5uowA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IKaEi6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IKaEi6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4F0C43399;
	Tue, 23 Jan 2024 00:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969188;
	bh=uaCuyBsde9+Fb0SXgHVfasv6koX/zoR9apwmp4HDmtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IKaEi6pDASkSdgwhaouPguaICoBshJzwXN7GXwLiwUNfhQCDpQHJKPJwvhGFYE0T
	 j4O32EVNMol7JjSW8900f+YtrEe69NpqEWCxcTLCPtQKwaB0RZaXIXpE86UyRT05tx
	 jbEEQ8rkCHJ1jekm9aw/tn10p7cYrA88ghDHkjSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 052/641] crypto: qat - fix error path in add_update_sla()
Date: Mon, 22 Jan 2024 15:49:16 -0800
Message-ID: <20240122235819.695634602@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damian Muszynski <damian.muszynski@intel.com>

[ Upstream commit 6627f03c21cb7001ae4dbbfb7a8514516d02331c ]

The input argument `sla_in` is a pointer to a structure that contains
the parameters of the SLA which is being added or updated.
If this pointer is NULL, the function should return an error as
the data required for the algorithm is not available.
By mistake, the logic jumps to the error path which dereferences
the pointer.

This results in a warnings reported by the static analyzer Smatch when
executed without a database:

    drivers/crypto/intel/qat/qat_common/adf_rl.c:871 add_update_sla()
    error: we previously assumed 'sla_in' could be null (see line 812)

This issue was not found in internal testing as the pointer cannot be
NULL. The function add_update_sla() is only called (indirectly) by
the rate limiting sysfs interface implementation in adf_sysfs_rl.c
which ensures that the data structure is allocated and valid. This is
also proven by the fact that Smatch executed with a database does not
report such error.

Fix it by returning with error if the pointer `sla_in` is NULL.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 86e3e2152b1b..f2de3cd7d05d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -812,8 +812,7 @@ static int add_update_sla(struct adf_accel_dev *accel_dev,
 	if (!sla_in) {
 		dev_warn(&GET_DEV(accel_dev),
 			 "SLA input data pointer is missing\n");
-		ret = -EFAULT;
-		goto ret_err;
+		return -EFAULT;
 	}
 
 	/* Input validation */
-- 
2.43.0



