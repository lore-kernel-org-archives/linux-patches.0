Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7223191D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300942; cv=none; b=AL61Oq0XxXQiIvM03iyEQK55aoc1Sre3viF58W24/dWx7PXFZFItTykl3ok+uInqUnFQ1O6+j5se79dQWXDlYnecDtiHpzyS6RlVkUu577loz84iz4dEgGYqQEoHBDzJadyAoigUIC1LtVsj4ebxVHKV6ROSH+dCkLFiLt9ikqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300942; c=relaxed/simple;
	bh=yOYnnwMEduYVzlWRXIMEL6GEHNr3ekELKXsB5hjHNGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxmzyEI5HrzicBYiWskZN7pBkj5fdG+6HITWRiwEeJgl/0U2Sw62d/WD7+aTRVAObTwMMDWYAwgeW4HqUUwSCnkba97F6ecBhMLbXHLM9WWrfErHEI6bV50U5T04MRT3TYCm4Q8Jql1nKlAd3joCmtEIB/3Vx9k6ObsPlkxx2YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WClVctue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WClVctue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E286C19423;
	Sat, 28 Feb 2026 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300941;
	bh=yOYnnwMEduYVzlWRXIMEL6GEHNr3ekELKXsB5hjHNGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WClVctueuwrHe5UyRk2ZMEyEuEoxRbYUX9IoMHC7HSVEW9441QfJpMJgSCQsRle/X
	 hFP9Sqi91HFTOEg12qHZ8sYAxxYRSmkh9R2gawxP0ajw4+ESJ9lDVnzH+SBkABym1x
	 qisUuFAHaNs2qqfwwgHpG3Ym7kaB+XqitfkpleXyvNrWuaMY5XhCN9QbaI8UWbHVJc
	 24dE/Q43JMyXB9F0KKEL0s7hs1F1FrcHrrbfwtRz8Zm8Vz54lvwN47+nxCTpITwvG3
	 wfw7ee6eUh6HQwypkwHZIVecqoWFXb2k4GZhdCGumPZYn20TLp/NLlg183YAJOGEim
	 +GajFvIc8CG8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexandre Courbot <acourbot@nvidia.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/752] rust: cpufreq: always inline functions using build_assert with arguments
Date: Sat, 28 Feb 2026 12:36:14 -0500
Message-ID: <20260228174750.1542406-63-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit 8c8b12a55614ea05953e8d695e700e6e1322a05d ]

`build_assert` relies on the compiler to optimize out its error path.
Functions using it with its arguments must thus always be inlined,
otherwise the error path of `build_assert` might not be optimized out,
triggering a build error.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/cpufreq.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
index 1a555fcb120a9..df5d9f6f43f3b 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -1015,6 +1015,8 @@ impl<T: Driver> Registration<T> {
         ..pin_init::zeroed()
     };
 
+    // Always inline to optimize out error path of `build_assert`.
+    #[inline(always)]
     const fn copy_name(name: &'static CStr) -> [c_char; CPUFREQ_NAME_LEN] {
         let src = name.to_bytes_with_nul();
         let mut dst = [0; CPUFREQ_NAME_LEN];
-- 
2.51.0

