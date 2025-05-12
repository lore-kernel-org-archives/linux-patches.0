Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613021C173C;
	Mon, 12 May 2025 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072155; cv=none; b=QPS5B/SSZ58JOAoJokv0BmgqVArCo8jUzk40MH6Fou1C+MUMFjxayyu5sq8oskaEYC45qbSZQRhV2IUhJ+cIYY1tT3VkkVg16M5+EtmnFwM9Z91olyZM9/YKlWHEDwlRMmpHhnXWtHqD89PMWhzuI2vOh8A+h8rNfLKsBW8vVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072155; c=relaxed/simple;
	bh=7jCGQpnyVAey8NOQy37P1zqQsHrwssYlg76tOlzTZ4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHwXUvTFKHDNJSlEjm1QBUOdMsCPM7tsN59A4K3KP0WkXtECH86Fm6lpceBI7oIT046ybZcdd0J4Ov4hk6xwhxEbKLiRWHIlFNEgB+k0J/JwXDbUEVsLjoIyAppQIqvdWcp/zLOKNkroXfOJGGgr4UVTCddSkb3GEKNSDuLPd+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcBWnE6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcBWnE6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A256EC4CEE7;
	Mon, 12 May 2025 17:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072155;
	bh=7jCGQpnyVAey8NOQy37P1zqQsHrwssYlg76tOlzTZ4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcBWnE6+QhDSo2mwp27LtOErky+0DSOpsmozRWPq6gHHfCSoJDV97Ea8BWNQcCAn5
	 8L+MEmghfBk33n0sfJa6yL3LY/WGPeQx3SgMxiLkUflgXB4TO8ml+pRVhe4tiFw+1E
	 gmHZ5a41/iXhzLnwqgdePPkDcmpjKVuKPZRxaumE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Crivellari <marco.crivellari@suse.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 155/197] MIPS: Move r4k_wait() to .cpuidle.text section
Date: Mon, 12 May 2025 19:40:05 +0200
Message-ID: <20250512172050.696666503@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit b713f27e32d87c35737ec942dd6f5ed6b7475f48 ]

Fix missing .cpuidle.text section assignment for r4k_wait() to correct
backtracing with nmi_backtrace().

Fixes: 97c8580e85cf ("MIPS: Annotate cpu_wait implementations with __cpuidle")
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/genex.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 46d975d00298d..2cf312d9a3b09 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -104,6 +104,7 @@ handle_vcei:
 
 	__FINIT
 
+	.section .cpuidle.text,"ax"
 	/* Align to 32 bytes for the maximum idle interrupt region size. */
 	.align	5
 LEAF(r4k_wait)
-- 
2.39.5



