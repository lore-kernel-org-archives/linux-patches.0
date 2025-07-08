Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178AB7DA93;
	Tue,  8 Jul 2025 00:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932984; cv=none; b=c5TXNkIT8X6jw9FZLkNLzmtDcjJyGymw8FmCSHq58mAAsv4kdZ19t3njoPCm+9SJ2t2vYEMz/TajApBIZeqHqruvHX41Exini1c60o5dpOo0qniD76RxZPSTQIzjkx/JnP/4emauCEwBdUYephqoBJJb+TgHKWG1pI+4B0Jdn0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932984; c=relaxed/simple;
	bh=ZJ/n1M5kT54C6A1wFgihCVWK97DfePfv0+6hwxriPJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MZBdSfXZMzczNIZ9uBVdjT/SM8a5ihbp5x1lgWNA0T3aRm3Bieo8aPXorvH5AtSiShFWajy1cAxzQf34cnd6DhB1Z3LNb54av6VZZPFpsc0rlTtBWx5ejWHOCF5u6vqaQhQ0mtkT4gMmrPLn4s3XxdJqw2mQvxUEWSuJ7c7owEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhMqcWqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhMqcWqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E080FC4CEF1;
	Tue,  8 Jul 2025 00:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932983;
	bh=ZJ/n1M5kT54C6A1wFgihCVWK97DfePfv0+6hwxriPJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhMqcWqbijeCUnYiuQwBzVAjzr+P6bSg1FAWgzy8R3cvTeNa5IzhhBJkJVTJfKcVh
	 3PaLP+tRfGTT5M/jVyRkxjxbd3VM+IuV/HOfnbJXa/4KORh37G4mD7zvy1uwve1FES
	 7rUx9VaKhoSWXy06fv6Gtw5NHCsbkAh16aaKawDmgOPNQxHE8c1DN4nmSu7Ir/WjWe
	 lqNtpib5EDw3Ez82GwXVJo9cHCjJsh4Qf4vljlNogvi4kbAX+w8UzTnbn2IaQ1IDfd
	 BbC0T1o7j6fQPp/y9JbTY81yH+aXYAPqsuoNBEcT1IzyyaB3NsITL5R8CzMB77Cu8d
	 FhXshLf8ew7/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alessandro Carminati <acarmina@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/3] regulator: core: fix NULL dereference on unbind due to stale coupling data
Date: Mon,  7 Jul 2025 20:02:59 -0400
Message-Id: <20250708000300.793770-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000300.793770-1-sashal@kernel.org>
References: <20250708000300.793770-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.239
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
index a0cc907a76c18..b2d866d606512 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5198,6 +5198,7 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 				 ERR_PTR(err));
 	}
 
+	rdev->coupling_desc.n_coupled = 0;
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	rdev->coupling_desc.coupled_rdevs = NULL;
 }
-- 
2.39.5

