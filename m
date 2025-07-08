Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46441C8FE;
	Tue,  8 Jul 2025 00:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932978; cv=none; b=jcmb9wqZVGiUqMdmSFlTyxkJuaEAlmnQatRgChOffdg77ItMF58f9FuyLufykC9bcpR6afdLX4ZCt5nBEE6PBC751ggmaR8G0LgNmnFSVuXSrnL532xQQxsCo7a1ujpMnDbGkF7sv/aYfaHkAiGPxKH+sf6k6N631xGpmKiZMpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932978; c=relaxed/simple;
	bh=1wP4bkZBaiOt1mnNA5GAb9Q2eL9IkcryiDTdJR+qz6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dSznUWKpViqYhR0kEyVQWvIy9gxrOgnGEG5o6Fu5OrezxMT3xe2r7haFGeRtTXkAmh8Z9jJyMwOKSVFT/eYDhDebzLw9jsPqT6i7Gv7mQbjbKEfSDUXi8ISpF8KiLKdDZS3ewroyclLtDp1r8Zjbv+tDtxaJdFGJBMH6Jzzlod0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JeMc5Mdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JeMc5Mdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488B7C4CEF1;
	Tue,  8 Jul 2025 00:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932978;
	bh=1wP4bkZBaiOt1mnNA5GAb9Q2eL9IkcryiDTdJR+qz6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeMc5MdjgD9e0oAHRQB/n1WYLe78jO3shvwbhd8IvvLjjMUd5uuHEyZ2CV1r346YR
	 dxpqFmFrfDItdsdWOfsRQdSY4+/ljl8+hidVv0GKn6F/Dk1UHEC7UhwfEXrKVclMtN
	 +cCB2fKGAiv8BSkiSKtv1AKARzdhyqEYcXZsPpLtHfrJs4VyzJO3SneXFlCr4sKWXS
	 WXeH+iM7Prc5FRoKJ4h618875ySuqfeZzQB0L82KsRF1n59sWyIFyoZzt0S2Vjpc93
	 809blvlA6zqWfJMtWMk1nBNBzxRdi7oiz8/8wZriIWoQhEDWAh2ADFAOUmzl1dFdRV
	 j4qvYIYpkznKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alessandro Carminati <acarmina@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/3] regulator: core: fix NULL dereference on unbind due to stale coupling data
Date: Mon,  7 Jul 2025 20:02:53 -0400
Message-Id: <20250708000254.793684-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000254.793684-1-sashal@kernel.org>
References: <20250708000254.793684-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.186
Content-Transfer-Encoding: 8bit

From: Alessandro Carminati <acarmina@redhat.com>

[ Upstream commit ca46946a482238b0cdea459fb82fc837fb36260e ]

Failing to reset coupling_desc.n_coupled after freeing coupled_rdevs can
lead to NULL pointer dereference when regulators are accessed post-unbind.

This can happen during runtime PM or other regulator operations that rely
on coupling metadata.

For example, on ridesx4, unbinding the 'reg-dummy' platform device triggers
a panic in regulator_lock_recursive() due to stale coupling state.

Ensure n_coupled is set to 0 to prevent access to invalid pointers.

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Link: https://patch.msgid.link/20250626083809.314842-1-acarmina@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now I understand the bug. After unbind, the regulator_dev structure may
still exist and be accessed (e.g., during runtime PM operations). If
n_coupled is not reset to 0, code like regulator_lock_recursive() will
try to iterate through n_coupled entries in the coupled_rdevs array, but
that array has been freed and set to NULL, causing a NULL pointer
dereference.

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real NULL pointer dereference bug**: The commit
   addresses a crash that occurs when regulators are accessed after
   unbind. The issue is in `regulator_lock_recursive()` at line 326-327
   where it iterates through `n_coupled` entries in the `coupled_rdevs`
   array:
  ```c
  for (i = 0; i < rdev->coupling_desc.n_coupled; i++) {
  c_rdev = rdev->coupling_desc.coupled_rdevs[i];
  ```
  If `n_coupled > 0` but `coupled_rdevs` has been freed (set to NULL),
  this causes a NULL pointer dereference.

2. **The fix is minimal and safe**: The patch adds just one line:
  ```c
  rdev->coupling_desc.n_coupled = 0;
  ```
  This ensures that after freeing the coupling data, the count is also
  reset, preventing any code from trying to access the freed array.

3. **It affects a critical subsystem**: The regulator framework is
   essential for power management, and crashes in this subsystem can
   cause system instability or complete failure.

4. **The bug can be triggered during normal operations**: The commit
   message mentions this happens during runtime PM or other regulator
   operations, which are common scenarios, not edge cases.

5. **Similar to other backported fixes**: Looking at the historical
   commits, we see that similar coupling-related fixes have been
   backported:
   - "regulator: core: Release coupled_rdevs on
     regulator_init_coupling() error" (backported)
   - "regulator: da9063: fix null pointer deref with partial DT config"
     (backported)
   These precedents show that NULL pointer fixes in the regulator
subsystem are considered important for stable trees.

6. **Clear reproducer**: The commit mentions a specific platform
   (ridesx4) where unbinding the 'reg-dummy' platform device triggers
   the panic, indicating this is a reproducible issue.

The fix follows the stable kernel rules: it's a small, contained fix for
an important bug with minimal risk of regression.

 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 18f13b9601b5b..ed5d58baa1f75 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5359,6 +5359,7 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 				 ERR_PTR(err));
 	}
 
+	rdev->coupling_desc.n_coupled = 0;
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	rdev->coupling_desc.coupled_rdevs = NULL;
 }
-- 
2.39.5

