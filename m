Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4E94BEE43;
	Sat, 12 Sep 2026 16:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230493; cv=none; b=sXEdnfhoxlTCj4V2ek1KxIV6UwczuIQnfpM6mCii6UOiKhPP54ulrZnX+Ddgj8E1f0wrxbndiN8vdaaoajPYcdckZop4zD7g9BE6X+EbjkNTVitJOr33A7Db+/RUm9C8u1jsNYJ5AcnAynlH1x3dKprBsgGgxfsrZH7jTwj6EjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230493; c=relaxed/simple;
	bh=CZkyDIRZiJ1Bc/5baqXbjNuC4BbaKcOQ80qGJpmm6Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILTVVG/nwMTZgbh97sT51M0dwN2gdoVDzQqPNN+Co5mR+ER7XVt2955+17XRrP+HkTjc/EKTr74g25/uGa1V8FqrDanWzooROTwBMNcsWEJ+4aXHdOjfuhpNi5K1dH4WXpc0lukCYU990eV4viK2fKloLPFA4gLUIgqyoZ7lbDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prrcuQAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prrcuQAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DD01F000FF;
	Sat, 12 Sep 2026 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230492;
	bh=IR52/G8731hbEq8bH5x9HpfKdeBdgJrpxmEIKmPK9GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prrcuQAVZomNzXbE6SXIm2XiR9MFvZ7kAu9mB81Ft6ooU/eeOFzJL7naoxN4AmNZ0
	 I37jpfB5KrpWy7MdsepCiud6qDXxZFIZamwd/LDbnzw4piZy/gFqImbcOoK5b0VTPP
	 irfEqrynqNlLSx5lPdiryJwrmS3rchHF1z6oMLlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0805/1191] perf: arm_spe: Make wakeup range check overflow safe
Date: Sat, 12 Sep 2026 08:58:53 +0200
Message-ID: <20260912065606.351641281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 815bf2e2dffa4..c9b5ac48d5e31 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -459,7 +459,7 @@ static u64 __arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	 * the page boundary following it. Keep the tail boundary if
 	 * that's lower.
 	 */
-	if (handle->wakeup < (handle->head + handle->size) && head <= wakeup)
+	if ((handle->wakeup - handle->head) < handle->size && head <= wakeup)
 		limit = min(limit, round_up(wakeup, PAGE_SIZE));
 
 	if (limit > head)
-- 
2.53.0



