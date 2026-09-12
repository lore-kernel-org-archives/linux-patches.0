Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB67C23BD06;
	Sat, 12 Sep 2026 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224388; cv=none; b=WMrvqvFeOodGxmREtPPmp0QGFSpoeZZ+u0oBXRduym7g2SuPfMcZ7TjAOWObUFA1DEhnCOlnhI+2GgIMHqxXYxDNZYr1NQX5Rr+sBiAH6cjDutR7/e4q+YuNZwE/5VBHgVEMOs8sFUl36QGDBTI6O3Y/A7H05CX5g1oamFFXlLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224388; c=relaxed/simple;
	bh=6VCHJH3EXh76s+CKzS4FA+OkiS/+Ql8GtVD2z747Eqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV0KVzmNP6eN5geVuK6pEGgITgrCvkQpCwfm4DivZhbKY8os3Z6WoW32p+DKA6IZ4JHpCtr3AuILkJ5CE5DiLrP99wzTRy1WZqWfsDYPyRKC01KknpDv0FIUa5sZ5yOMfXISC5o5wHI5FALRYPTYqPab0NiMdPEI+cbFtv9Ax9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H83hFJGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H83hFJGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B991F000FF;
	Sat, 12 Sep 2026 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224387;
	bh=xDftsYHhCXwBxTqULRc9dNeAh5qcObZh8qx6o5Ouu1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H83hFJGy2OKwkw+GhxgMVrc0mC1nmdUADRFZQbW5TDcqxJBtwJwaudKDTK7ntHQyS
	 vgeF1sWxLJzKToFIfRyc9Qd1R2uhBz24AgMuht6TWMdT+Mx9u6ujqz/qNAwaxD2CIE
	 1eUnPZlEJeZYM9c28pVarPNUnAOg84//tOqhUKts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0982/1424] perf: arm_spe: Make wakeup range check overflow safe
Date: Sat, 12 Sep 2026 08:56:54 +0200
Message-ID: <20260912065629.307542363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit fcc5eaea2d234162dfb8258372dd897bc2a1b862 ]

The current code checks whether the wakeup point is in the current
writable range by comparing it with handle->head + handle->size.

The perf AUX head is a monotonically increasing index, so that addition
can overflow when head is close to ULONG_MAX. In that case, a wakeup
point which is still inside the free space range can be missed.

Use unsigned subtraction to compare the distance from head to wakeup
against the handle->size. This can dismiss the issue when addition
overflow.

This is unlikely to happen in practice, but the change makes the
watermark check logically correct.

Fixes: d5d9696b0380 ("drivers/perf: Add support for ARMv8.2 Statistical Profiling Extension")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_spe_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 5164078c06d25..1966de0af58f2 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -489,7 +489,7 @@ static u64 __arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	 * the page boundary following it. Keep the tail boundary if
 	 * that's lower.
 	 */
-	if (handle->wakeup < (handle->head + handle->size) && head <= wakeup)
+	if ((handle->wakeup - handle->head) < handle->size && head <= wakeup)
 		limit = min(limit, round_up(wakeup, PAGE_SIZE));
 
 	if (limit > head)
-- 
2.53.0



