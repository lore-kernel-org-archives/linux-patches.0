Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0222E40E;
	Fri, 24 Nov 2023 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvHXFHtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA666C433C8;
	Fri, 24 Nov 2023 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852024;
	bh=I6yiA7ElWRn8Jwvf+GEcmRzsOb5OyYRQpFK1Kn+DuBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvHXFHtlrIaXpKkRu3/1okmIEHCoyt01oKTVlW92gGDOnG2jCc3QrYe4QGdmTvrOe
	 rd5HYb9ZYj5pJwb21mxGStGB0yO3TqM07lBbGzvF8Cpc0CY4clZWaxmpJRcTQxp19q
	 9Mnnez0/FDOhiRgPjvyUgeRmWSnaR2bbMnlH1L+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 165/372] powerpc/perf: Fix disabling BHRB and instruction sampling
Date: Fri, 24 Nov 2023 17:49:12 +0000
Message-ID: <20231124172015.987692734@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1371,8 +1371,7 @@ static void power_pmu_disable(struct pmu
 		/*
 		 * Disable instruction sampling if it was enabled
 		 */
-		if (cpuhw->mmcr.mmcra & MMCRA_SAMPLE_ENABLE)
-			val &= ~MMCRA_SAMPLE_ENABLE;
+		val &= ~MMCRA_SAMPLE_ENABLE;
 
 		/* Disable BHRB via mmcra (BHRBRD) for p10 */
 		if (ppmu->flags & PPMU_ARCH_31)
@@ -1383,7 +1382,7 @@ static void power_pmu_disable(struct pmu
 		 * instruction sampling or BHRB.
 		 */
 		if (val != mmcra) {
-			mtspr(SPRN_MMCRA, mmcra);
+			mtspr(SPRN_MMCRA, val);
 			mb();
 			isync();
 		}


