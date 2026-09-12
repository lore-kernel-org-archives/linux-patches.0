Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BED3546E1;
	Sat, 12 Sep 2026 10:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209189; cv=none; b=L6ZLGX7ZEJaLS/ixmbXKbKe9GHYj1hCWc3dkHszDfE2T+QWhTeFqJb10v01UDwIf1E+uy9Xs7icgDeUDdoQCoiAwP73q07sgd9RTvvYOK87bqMkHkPZGmzwqnMTVRCRlY7YueAbz8WjIt6W1W2zvX80tJwYa8oKqu/ROy2ms1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209189; c=relaxed/simple;
	bh=/XIR9ae2j93vy7xU8sz48UuwBicQyDsnT8MramnQOww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WX8h2h3QiqNzu1a9AVoda8o8gtV02Y9M+rKNqCgPj9gq/VNZy6EBfrAmY1a7L8KB4uSb1OFcqwFuZRUr0zbFtjnj2GAdHeAMjQDbeH0RURBvKiAI4U0Bpc5gVRNUKDYIm7A9weMGHZ4BBBlhC7cb8mn87WoxGfLPkLisjH+eZB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+aKcVHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+aKcVHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1641F000FF;
	Sat, 12 Sep 2026 10:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209187;
	bh=FTcJhH8xuO3Dhe5kPLKCbsX44zXAJEUZv80ZZykpgqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+aKcVHwMV6L9LDs4mJMEptrjgPET7TTVNZTQIyD/mui3OPdQjfC3IB3ONStZ1TtT
	 Icv2w3Nvw6W4+IFApG8XOxxNOdYCR54U5bMTsyHlyN9eWPqaNhxk05Ig/vBi20DfYi
	 bR8b2QiZaqyu5uBi84LuX3UfIDP4lIP+ie2EO7hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0769/1518] perf: arm_spe: Make wakeup range check overflow safe
Date: Sat, 12 Sep 2026 08:48:58 +0200
Message-ID: <20260912065640.830457455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index e4e4e63c64c42..7bc24db50d1ff 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -552,7 +552,7 @@ static u64 __arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	 * the page boundary following it. Keep the tail boundary if
 	 * that's lower.
 	 */
-	if (handle->wakeup < (handle->head + handle->size) && head <= wakeup)
+	if ((handle->wakeup - handle->head) < handle->size && head <= wakeup)
 		limit = min(limit, round_up(wakeup, PAGE_SIZE));
 
 	if (limit > head)
-- 
2.53.0



