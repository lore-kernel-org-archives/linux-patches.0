Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1914831B;
	Tue, 23 Jan 2024 00:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969157; cv=none; b=DUdw8cOtphT7bgUqxsrAWw4l3YTwHB9cz9l0rVF9gAgQH0bh56z5ll5catGqI/Zar0VvM1PFaKahv6xVHvPUg51P5J+anljZgQA2V8TFuLCbBQivDiItmf+/iuRnceUkqR3apNVVSr5n6TO+dcnXJthR6bKfA4SFS+YzPZvd2Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969157; c=relaxed/simple;
	bh=qw1QLXDAGLBfuRzFr+qyQxjxdiYliXdYgY/z7Du9tRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTbd2agd08ROqBuuIP+jaPDDYnnR2Q01bDNpPX+QK9sQd1KvAyETc9ZXPJ9UI3bYMIZNNTrgwz6b46OAj7KyIXgJbVVmpKPtDy7Gcems1LGqMdSrW/ZHSX5oE+EOXikYp8fRvz0C7NytWMA3WoNp/qAHGc56JZtsf7eOBT0afjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kotv32H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kotv32H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F089AC43390;
	Tue, 23 Jan 2024 00:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969157;
	bh=qw1QLXDAGLBfuRzFr+qyQxjxdiYliXdYgY/z7Du9tRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kotv32HDda1oklUGvqgo3iijZG77g/e+3wglmGIP2onQGS/OXH0ykfOcDMz9wOYf
	 bHdqZ0bXeYdtGKAQ5lyRu/FyJgeJPmF3uhlIDQUIhYGexDICz7/rVpmpp9VEH7dl5y
	 RzXTudmR6qQLnlS58pJQdsxSVinCNM8wCCvJCi7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 053/641] crypto: qat - fix mutex ordering in adf_rl
Date: Mon, 22 Jan 2024 15:49:17 -0800
Message-ID: <20240122235819.725455469@linuxfoundation.org>
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

[ Upstream commit 487caa8d5ef9a9a27b092c5790d529a7a0c24f8b ]

If the function validate_user_input() returns an error, the error path
attempts to unlock an unacquired mutex.
Acquire the mutex before calling validate_user_input(). This is not
strictly necessary but simplifies the code.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index f2de3cd7d05d..de1b214dba1f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -815,13 +815,13 @@ static int add_update_sla(struct adf_accel_dev *accel_dev,
 		return -EFAULT;
 	}
 
+	mutex_lock(&rl_data->rl_lock);
+
 	/* Input validation */
 	ret = validate_user_input(accel_dev, sla_in, is_update);
 	if (ret)
 		goto ret_err;
 
-	mutex_lock(&rl_data->rl_lock);
-
 	if (is_update) {
 		ret = validate_sla_id(accel_dev, sla_in->sla_id);
 		if (ret)
-- 
2.43.0



