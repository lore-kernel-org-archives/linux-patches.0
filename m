Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BD61C5799;
	Sat, 12 Sep 2026 18:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239368; cv=none; b=gDg3gNAo0dOvf9TckEa1aUs9yW1dHoSc0L11OFKED6AM2VKvthopLGc5GuXi2yuxHHMfpYr2ugG4ZRGz+5GhYKaLnPWRMIhS1OGsjtDOAKDwrS3lQuDlf4ag8LYFwBpsVkes93UJyzXbvyh7GGADuhLPhUKae3/d26pykzaRjk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239368; c=relaxed/simple;
	bh=+wzAl7g21E0Fh2r3Iw7vU+SEwU76R8mpoWgRuX2pFo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHGz0p5X4fZ5Bf7gMcEvv4S59CL4Lm1sS9bZESU5sYeRU/yU5T0TyrbMs76t5suIDTSyhD73vrX9Ls++87B6pJEG27eviS8u6p8ILf9fEyQ8FGQrsYtgh+iS/w6XqIXEA8MkNGUEsr7ePqBSEXw+mlQMl+cfT8aCy6Y/Ns5r/ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpFOmm1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpFOmm1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5F11F000FF;
	Sat, 12 Sep 2026 18:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239367;
	bh=bZXu6HV0Xdpzp/Fgzmfn9nWlzpBOx9LP6ZCKPMAoYDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpFOmm1LlDsezR0sYQK7NkWfq+T7zPnLcvbQ0LKwWyUdotybmWIanUha/LqNUbtQS
	 A2Brv0I+eP/3pTC7uY+P51Q9Z3EIhCYaK/gsOjSb09DhbtEDj0azCW8jF3GBJPbMQt
	 T2NwiPv6l91QoYood5t0GCr5gT3R/9SbkgX57Grs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 650/935] perf: arm_spe: Make wakeup range check overflow safe
Date: Sat, 12 Sep 2026 09:01:20 +0200
Message-ID: <20260912065541.751347684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5ba677353d040..d168653c63cb9 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -457,7 +457,7 @@ static u64 __arm_spe_pmu_next_off(struct perf_output_handle *handle)
 	 * the page boundary following it. Keep the tail boundary if
 	 * that's lower.
 	 */
-	if (handle->wakeup < (handle->head + handle->size) && head <= wakeup)
+	if ((handle->wakeup - handle->head) < handle->size && head <= wakeup)
 		limit = min(limit, round_up(wakeup, PAGE_SIZE));
 
 	if (limit > head)
-- 
2.53.0



