Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295732C327B;
	Tue, 15 Jul 2025 13:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585712; cv=none; b=XYUKYu7GzRYYk3FpdSKbzkVz97GTUsJuKbep774AhkLiEZihA0ybQaF3w579X2xo+QApOI+Hjw3F/DDHCJEThfic3akCcxJmGaGufswvxS6S9cBv2/10DLcypTwiR5+5t202+lxre/0EGIToC6dCJ9h8W2ApZMf+G+poZwAzgQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585712; c=relaxed/simple;
	bh=8SpRUlA+hdA3E5loFbvWNO7M2zSBEYpB3Lnf2N7eOuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/zNgR/P1dVWurjNzxBQ26C8oziuUYZxcUPHuOp3x06WomfCfeJvGVaZBX+WqeuhyZ3Ypw6gZrpisuOLWHqMibWaSprHiUDS2rYMCTQwHMk6yVfMO/ek5aCY1+7uQM+ddJuRAU238Rq0tVL50cT8mWQ/Cqptx+56wSZcTyR13sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oawSUNkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oawSUNkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F2EC4CEE3;
	Tue, 15 Jul 2025 13:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585712;
	bh=8SpRUlA+hdA3E5loFbvWNO7M2zSBEYpB3Lnf2N7eOuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oawSUNkOCjM9ROGmR08izKrl+vxvdEeyBkTEvZpL3oMSRDPLD1V+aEdsJgJfhnUzh
	 1FpgADPN7DRTS+cw5wjLjbhmrwPwti07PdZrm5ARTm9Gjy2ZWZZqY9u8rSSb/vYfV/
	 He188bemqRUPK61UGeViRPimYd2zfd5rpZerXRR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/163] io_uring: make fallocate be hashed work
Date: Tue, 15 Jul 2025 15:13:31 +0200
Message-ID: <20250715130814.570633215@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengnan Chang <changfengnan@bytedance.com>

[ Upstream commit 88a80066af1617fab444776135d840467414beb6 ]

Like ftruncate and write, fallocate operations on the same file cannot
be executed in parallel, so it is better to make fallocate be hashed
work.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Link: https://lore.kernel.org/r/20250623110218.61490-1-changfengnan@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a2be3bbca5ffa..5dc1cba158a06 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -214,6 +214,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
+		.hash_reg_file          = 1,
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
-- 
2.39.5



