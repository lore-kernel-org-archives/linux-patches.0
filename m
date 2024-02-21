Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FC97EF1F;
	Wed, 21 Feb 2024 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524814; cv=none; b=PLRbapAJXWxd/ymLUt7FJ6LHRmEc2GbFSWBCN5TMSBmiVhhIavd8J2Y1TVRzmd/yFID1ypoaepL654siX6ZvNV+K6vBeFIy+ErBD7cr8q9PO1kh7iyHlhru9WDSYw54QSoxPPHMahb75AOPcQSY4g4CsCok6aLUYbBfbtHfK94Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524814; c=relaxed/simple;
	bh=lkQjFSeflmhruS0IHub/SsboGVj0iiw+8Kp0xVz6EbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrbiQNHdy7Tcv+Hff4UUdpamHrb2bGBkHYFH0gFLI0k875K5KrtjUFmjuPjinfo8Eetb79y1SC2J69/JdxtKLYfPu/PW0kNpOGAeO/at7dL2V1m8h7Hf4zT9aGu7GHXsQxHcUgxJ7l0AsZCTkrTquRqEBmGVH8UfBJETvh2pvVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIiMMCxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIiMMCxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724AEC433C7;
	Wed, 21 Feb 2024 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524813;
	bh=lkQjFSeflmhruS0IHub/SsboGVj0iiw+8Kp0xVz6EbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIiMMCxmUAvP0D6UsPdop0vF41uWLutW6rQf7RWmVnz8+RzlrYPx67G5GIA1L869M
	 mUO0K9XswJTnSV7vyqnz1ewKF1qN1R4eMnjImhzL191Rypm2nUAkVYvudCdHL6z9SH
	 DD6kL9GG5KjUM+Pv+VhawcHQ6S5QnIGKxOG93km4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/379] crypto: lib/mpi - Fix unexpected pointer access in mpi_ec_init
Date: Wed, 21 Feb 2024 14:08:56 +0100
Message-ID: <20240221130005.619297033@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit ba3c5574203034781ac4231acf117da917efcd2a ]

When the mpi_ec_ctx structure is initialized, some fields are not
cleared, causing a crash when referencing the field when the
structure was released. Initially, this issue was ignored because
memory for mpi_ec_ctx is allocated with the __GFP_ZERO flag.
For example, this error will be triggered when calculating the
Za value for SM2 separately.

Fixes: d58bb7e55a8a ("lib/mpi: Introduce ec implementation to MPI library")
Cc: stable@vger.kernel.org # v6.5
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/mpi/ec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/mpi/ec.c b/lib/mpi/ec.c
index c21470122dfc..941ba0b0067e 100644
--- a/lib/mpi/ec.c
+++ b/lib/mpi/ec.c
@@ -584,6 +584,9 @@ void mpi_ec_init(struct mpi_ec_ctx *ctx, enum gcry_mpi_ec_models model,
 	ctx->a = mpi_copy(a);
 	ctx->b = mpi_copy(b);
 
+	ctx->d = NULL;
+	ctx->t.two_inv_p = NULL;
+
 	ctx->t.p_barrett = use_barrett > 0 ? mpi_barrett_init(ctx->p, 0) : NULL;
 
 	mpi_ec_get_reset(ctx);
-- 
2.43.0



