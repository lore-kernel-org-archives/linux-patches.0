Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2B2AD31;
	Thu, 22 Aug 2024 00:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724286276; cv=none; b=TSMe7fbPDpFbnLaF5Di/9r4kbBPU4Nxw/mPpx4MfKED32GYoxUck1AI8u5J8M/Zqt/qSocfRR05Y0TDi2RPG/7b3rXQdQ1K+BNv4hep/d+u058wcN6l+kqR4hUSEvt4UvY+79iX0syCLL9ZnvFv1qnzZuk8UfFOsX4bn0kNVLbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724286276; c=relaxed/simple;
	bh=9uwgIzZjoqBMGBRAWp0z6mEBdDTQ2dlrFqlDoLRbook=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc8n6xEHf82Up9Z9/Iqrjo0P2eUiMT716DdpMdMyhQCxY1HMUtRsAPhHW2dPNRo0oEDwDXLVNy+d+RlGBAwsfJC+e88/VifyCmUTUX/AggUPo4fzpy7avoZmoJUQJDPoDnqNU0sFUlGCTkxJdVOPM6dJ6sxmFbNGwcRPmouocl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MA+ZJKU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MA+ZJKU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5391CC32782;
	Thu, 22 Aug 2024 00:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724286275;
	bh=9uwgIzZjoqBMGBRAWp0z6mEBdDTQ2dlrFqlDoLRbook=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MA+ZJKU7Ki7wERE/uV2+TozmIx+PAUYz9nYuR9CjTOmr026C4MILeVhPAKBYkLNOH
	 gj88BvWARiLG1BaXB/o+C2hTMpSzW1vPoUfP/xMqA/bDrFpxfkLZ5wctPcZhCLNTAX
	 hEs43A2RYwXMMl20bS8cHCz9pnS6venaXAKsZBBkYdwlMLAuBJyq+QXSwMGz6hsjD4
	 UegWaLu4qWJ+PkKSdRGCwa3iqFL3IvAfb1K5V30GkLBupWRzSaOKZkO/bllNRsUSK5
	 TBXowpiREkRoWCGtle6eoc2mANDagIlUEN44/gaxk7BeN890GmsYYvTkEnJ420KF1O
	 26OnAVc6Po4Aw==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 2/3] of: kunit: Extract some overlay boiler plate into macros
Date: Wed, 21 Aug 2024 17:24:29 -0700
Message-ID: <20240822002433.1163814-3-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822002433.1163814-1-sboyd@kernel.org>
References: <20240822002433.1163814-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the lives of __of_overlay_apply_kunit() callers easier by
extracting some of the boiler plate involved in referencing the DT
overlays.

Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 include/kunit/of.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/kunit/of.h b/include/kunit/of.h
index 48d4e70c9666..75a760a4e2a5 100644
--- a/include/kunit/of.h
+++ b/include/kunit/of.h
@@ -62,6 +62,13 @@ static inline int __of_overlay_apply_kunit(struct kunit *test,
 					  &unused);
 }
 
+#define of_overlay_begin(overlay_name) __dtbo_##overlay_name##_begin
+#define of_overlay_end(overlay_name) __dtbo_##overlay_name##_end
+
+#define OF_OVERLAY_DECLARE(overlay_name)			\
+	extern uint8_t of_overlay_begin(overlay_name)[];	\
+	extern uint8_t of_overlay_end(overlay_name)[]		\
+
 /**
  * of_overlay_apply_kunit() - Test managed of_overlay_fdt_apply() for built-in overlays
  * @test: test context
@@ -104,12 +111,11 @@ static inline int __of_overlay_apply_kunit(struct kunit *test,
  */
 #define of_overlay_apply_kunit(test, overlay_name)		\
 ({								\
-	extern uint8_t __dtbo_##overlay_name##_begin[];		\
-	extern uint8_t __dtbo_##overlay_name##_end[];		\
+	OF_OVERLAY_DECLARE(overlay_name);			\
 								\
 	__of_overlay_apply_kunit((test),			\
-			__dtbo_##overlay_name##_begin,		\
-			__dtbo_##overlay_name##_end);		\
+			of_overlay_begin(overlay_name),		\
+			of_overlay_end(overlay_name));		\
 })
 
 #endif
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

