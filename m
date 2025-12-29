Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0C63A1E66;
	Mon, 29 Dec 2025 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025138; cv=none; b=Ez96JK8trV7kJrGJu1+W90dyuno6yKG2cJJIPFBa3iCD3d4RovSnuk7IwBjMgU+QviVOW2oR+QmbX1ZqvF1KRJiQYNvUwN6XPIoo0XlYtoSpRkwTpH/cnNVBpsHyIjm7Jn3INRWbVvkGRFRA8mA2+fbmvaGuzhf+z57dJ0r679s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025138; c=relaxed/simple;
	bh=PHMEQKF3d4qnRcHQv65lD2CrAvHUr4ZkMWISqFHyrpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAJ7HWuuB2om7gIMDEJBuxllodjGDaLhOVI7OS/wEIApGs7e0Up0Ta1gPhDOyX6QI3R9+ABB6fZLD2eGF+/KQMkRvWuUSB2UM3TZO82K1xNgvCBboOBtmLR9oLwCZWUhx/OAnxpGXzWQH/S0coBtxVQdUhVUglOhMFMW6/aen0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mr85PHBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mr85PHBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E31C4CEF7;
	Mon, 29 Dec 2025 16:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025137;
	bh=PHMEQKF3d4qnRcHQv65lD2CrAvHUr4ZkMWISqFHyrpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mr85PHBSfwp0t7xgVBbFnJSQ8jlAt1t/7lD/HcaqIRonTJJjxg5n3Uav4Td14hgQI
	 Z51e+lq+NBVX3DG503HUaSBtlJ8sCrKQ1nhUFUtFL/lTx6s6RzxtJTIptfoTZHRg+X
	 BNOx7e/9lJm/XXdOjXQ3h6scK4EcpGxfGorErbR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/430] selftests: ublk: fix overflow in ublk_queue_auto_zc_fallback()
Date: Mon, 29 Dec 2025 17:08:30 +0100
Message-ID: <20251229160728.342940562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 9637fc3bdd10c8e073f71897bd35babbd21e9b29 ]

The functions ublk_queue_use_zc(), ublk_queue_use_auto_zc(), and
ublk_queue_auto_zc_fallback() were returning int, but performing
bitwise AND on q->flags which is __u64.

When a flag bit is set in the upper 32 bits (beyond INT_MAX), the
result of the bitwise AND operation could overflow when cast to int,
leading to incorrect boolean evaluation.

For example, if UBLKS_Q_AUTO_BUF_REG_FALLBACK is 0x8000000000000000:
  - (u64)flags & 0x8000000000000000 = 0x8000000000000000
  - Cast to int: undefined behavior / incorrect value
  - Used in if(): may evaluate incorrectly

Fix by:
1. Changing return type from int to bool for semantic correctness
2. Using !! to explicitly convert to boolean (0 or 1)

This ensures the functions return proper boolean values regardless
of which bit position the flags occupy in the 64-bit field.

Fixes: c3a6d48f86da ("selftests: ublk: remove ublk queue self-defined flags")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/kublk.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/ublk/kublk.h b/tools/testing/selftests/ublk/kublk.h
index 5e55484fb0aa..1b8833a40064 100644
--- a/tools/testing/selftests/ublk/kublk.h
+++ b/tools/testing/selftests/ublk/kublk.h
@@ -393,19 +393,19 @@ static inline int ublk_completed_tgt_io(struct ublk_thread *t,
 	return --io->tgt_ios == 0;
 }
 
-static inline int ublk_queue_use_zc(const struct ublk_queue *q)
+static inline bool ublk_queue_use_zc(const struct ublk_queue *q)
 {
-	return q->flags & UBLK_F_SUPPORT_ZERO_COPY;
+	return !!(q->flags & UBLK_F_SUPPORT_ZERO_COPY);
 }
 
-static inline int ublk_queue_use_auto_zc(const struct ublk_queue *q)
+static inline bool ublk_queue_use_auto_zc(const struct ublk_queue *q)
 {
-	return q->flags & UBLK_F_AUTO_BUF_REG;
+	return !!(q->flags & UBLK_F_AUTO_BUF_REG);
 }
 
-static inline int ublk_queue_auto_zc_fallback(const struct ublk_queue *q)
+static inline bool ublk_queue_auto_zc_fallback(const struct ublk_queue *q)
 {
-	return q->flags & UBLKS_Q_AUTO_BUF_REG_FALLBACK;
+	return !!(q->flags & UBLKS_Q_AUTO_BUF_REG_FALLBACK);
 }
 
 static inline int ublk_queue_no_buf(const struct ublk_queue *q)
-- 
2.51.0



