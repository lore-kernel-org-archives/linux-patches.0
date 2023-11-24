Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB4E2EAEA;
	Fri, 24 Nov 2023 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srikiqsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B290C433C8;
	Fri, 24 Nov 2023 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852767;
	bh=NJYynJBzlz6vtCjfjGK5DAH0ioeYBA+rYcQ4wEW0foo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srikiqszaUxLOMBThKgjzBORVn/CId6UKv2zg6GULFHGOViRBjJuFI8t1cv94d7nX
	 nAj43ZzE75LYmJmPqcCK0Fnzdhcq1DPapv8kHo84v9KIxfWXJhpp7drjbiM70oJ+PV
	 brHC1GKyuk/8352GbkcTLxntTFaeYVp15kdmlKtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 090/193] powerpc/perf: Fix disabling BHRB and instruction sampling
Date: Fri, 24 Nov 2023 17:53:37 +0000
Message-ID: <20231124171950.858824553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

commit ea142e590aec55ba40c5affb4d49e68c713c63dc upstream.

When the PMU is disabled, MMCRA is not updated to disable BHRB and
instruction sampling. This can lead to those features remaining enabled,
which can slow down a real or emulated CPU.

Fixes: 1cade527f6e9 ("powerpc/perf: BHRB control to disable BHRB logic when not used")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231018153423.298373-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/perf/core-book3s.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1289,8 +1289,7 @@ static void power_pmu_disable(struct pmu
 		/*
 		 * Disable instruction sampling if it was enabled
 		 */
-		if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE)
-			val &= ~MMCRA_SAMPLE_ENABLE;
+		val &= ~MMCRA_SAMPLE_ENABLE;
 
 		/* Disable BHRB via mmcra (BHRBRD) for p10 */
 		if (ppmu->flags & PPMU_ARCH_31)
@@ -1301,7 +1300,7 @@ static void power_pmu_disable(struct pmu
 		 * instruction sampling or BHRB.
 		 */
 		if (val != mmcra) {
-			mtspr(SPRN_MMCRA, mmcra);
+			mtspr(SPRN_MMCRA, val);
 			mb();
 			isync();
 		}


