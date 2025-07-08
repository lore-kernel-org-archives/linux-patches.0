Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062D6625;
	Tue,  8 Jul 2025 00:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932992; cv=none; b=SfUrv+mc5amPufsED78s9/bkjoUghdc/0KiByWlZxk+snWko6B6FjYfiSpQOq7XW4CpklBvqsLJpdQAOOFk2J3j6QyleYeIs5tL4Q1u5C3u82gYu9Co6iyRdTnTBWp+JaiI78invp3pajisel0CzHsiyadynt4588ToDBzqGUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932992; c=relaxed/simple;
	bh=RzdkN5AejmjB2MQUG24aRqjEsj394B4y1HkQ71kFhus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OQvCGHngIKHG1AEgcpO1NO60XCSUr6qCLZz2qPufzp7NmjLUJC7u/2S+di036AktvVIETEjsKua04FaxX/oYhZjTHNm+p6xSX17/AfErB1yZGav/FxKmiz7TfCnJ2ewlGacgu2EGxzbTM7umSZVCvKPS+LbjyjCzN5FDUWHbYDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGRZuIXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGRZuIXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A9CC4CEE3;
	Tue,  8 Jul 2025 00:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932990;
	bh=RzdkN5AejmjB2MQUG24aRqjEsj394B4y1HkQ71kFhus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGRZuIXDJiNZvr5TW6m1pRT7/r/eWHh8nJGkGKVpNak+z0xWa8EaLUZsXM18lbJA9
	 VX+Aq/LhoU2n3+NpZUSz33yXxOXhKkfaOrpd4R1eVReM25QxpVqJnmiVD7Gn06cHG9
	 ruTbWl+grZzsYY/sEaBhOyw/cFNiViVvODyOzs1eDjljpub5L9j45oDybBiikOQCtD
	 0NpLWsQaoK8iSnU6zkGX7CgLh89e70ZnNckyrwIg6RjsYgsJHJ5t7DkbE/w9dUYTo1
	 VTQYh+y3QUJdDI3i2BRwc+ZHz5iwDfORaQ2SJMA6StBmcRikjlsF1qwq1ETOlNKDZh
	 kHQkTbhRWKFyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alessandro Carminati <acarmina@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/3] regulator: core: fix NULL dereference on unbind due to stale coupling data
Date: Mon,  7 Jul 2025 20:03:04 -0400
Message-Id: <20250708000306.793995-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000306.793995-1-sashal@kernel.org>
References: <20250708000306.793995-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.295
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
index a01a769b2f2d1..e5ce97dc32158 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5062,6 +5062,7 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 				 err);
 	}
 
+	rdev->coupling_desc.n_coupled = 0;
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	rdev->coupling_desc.coupled_rdevs = NULL;
 }
-- 
2.39.5

