Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E773043C9;
	Sat, 25 Oct 2025 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408825; cv=none; b=ZLAUtITH9m9qNv6A0/KL3ufju3R3dB5UiFhVXQyNjbxPV+EVOWcrzX1WkjYrS2pABR5fisAyu6zQ5A4rGEbYubtou8A2qEYaYrGF4APfOQZE6J83T/3sm1IJDJ/WWFEvYMGKFAyIqjlSJO9fUSt2jRUHdOeE+hnxmvfrbJkHclc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408825; c=relaxed/simple;
	bh=aOarMjKzUQnkvIX7CTnvCUPOs0e77ay2ln+V8n0cGYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gnYgsLcvujMSdZyiQcHN6JHpi5DIou3iXt6PSFtCNRj/zStUOW2LnLgIo7zZdENK9nWslT6v52FmWSc3Qd867wuvUeQdrifrxqi/tQfN9iAIebURPlAO05o7V79qGE+izSut8uMoFk+Po0SgUCHmcuifOzZTiYYFsdyT0MUY88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDztWJa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDztWJa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E478FC4CEF5;
	Sat, 25 Oct 2025 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408824;
	bh=aOarMjKzUQnkvIX7CTnvCUPOs0e77ay2ln+V8n0cGYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDztWJa8VYdXOBjL6Y8SCuKQ7q0bVAIs6NMiPZgepyBL5qotpDR+Tlzly6XZgzQ7F
	 /381u7oGCvwkBDxZr+rKihWH2FMab7mlUYAP+YedJTONc2dq29X6C6TWArl3oHW5LC
	 OwW43xR7FxDlrJRKbuPVCFqCDa74hlDkCx+IcPMJkTzkgWkgZczFBir1FxS6FFAPuy
	 rIgdhHLyLR4l6yVm2AosRDrJ5LHzATtbUIQsVSIWn7Agt6f6YDs7L7RRkOBJAsdWdl
	 OHN9zi/MGSxcxo3DPkvnm2DRMOSrqbkD5hBQgr7afDLdJYZqfkaBYz6EaafSLPxwjD
	 X3iYclOIw5YGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Francis <David.Francis@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amdgpu: Allow kfd CRIU with no buffer objects
Date: Sat, 25 Oct 2025 11:55:18 -0400
Message-ID: <20251025160905.3857885-87-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Francis <David.Francis@amd.com>

[ Upstream commit 85705b18ae7674347f8675f64b2b3115fb1d5629 ]

The kfd CRIU checkpoint ioctl would return an error if trying
to checkpoint a process with no kfd buffer objects.

This is a normal case and should not be an error.

Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: Previously, the CRIU path rejected processes with no
  KFD buffer objects by requiring both a non-NULL `bos` pointer and a
  non-zero `num_bos`. The commit relaxes this so that a process with
  zero BOs is treated as a normal case instead of an error.

- Precise change: In `criu_restore`, the validation changes from
  rejecting zero BOs to only requiring `args->bos` when there actually
  are BOs:
  - New check only requires `bos` if `num_bos > 0`:
    `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:2568-2570`
    - `(args->num_bos > 0 && !args->bos) || !args->devices ||
      !args->priv_data || !args->priv_data_size || !args->num_devices`
  - This removes the old unconditional `!args->bos` and `!args->num_bos`
    rejection.

- Why it’s correct and safe:
  - Downstream restore code already handles zero BOs correctly:
    - Size checks scale with `num_bos`:
      `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:2439-2440`
    - Zero-length allocations are fine; `kvmalloc_array(args->num_bos,
      ...)` and `kvzalloc(...)` safely handle `num_bos == 0` and
      `kvfree` is safe:
      `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:2445-2453, 2463-2467,
      2495-2499`
    - `copy_from_user` and `copy_to_user` with size 0 are no-ops and
      safe even if `bos` is NULL:
      `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:2455-2461, 2487-2492`
    - The loop over BOs naturally skips when `num_bos == 0`:
      `drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:2479-2485`
  - For `num_bos > 0`, the new check still requires a valid `bos`
    pointer, preserving existing behavior where needed.

- Scope and risk:
  - Small, localized input validation fix in KFD CRIU restore path only;
    no architectural changes.
  - No impact on other subsystems; error handling paths remain
    unchanged.
  - Regression risk is minimal because it only relaxes a reject
    condition for a valid scenario and downstream code already supports
    zero BOs.

- User impact:
  - Fixes spurious `-EINVAL` on CRIU operations for processes without
    KFD BOs, which is a normal scenario per the commit message.
  - Improves reliability of CRIU-based workflows for AMD GPU compute
    processes.

- Stable backport criteria:
  - Important bugfix affecting real users.
  - Minimal, contained change with low risk.
  - No new features or API changes; aligns behavior with existing code
    expectations.

Note: While the commit message mentions the checkpoint ioctl, this
change updates the restore validation
(`drivers/gpu/drm/amd/amdkfd/kfd_chardev.c:2568-2570`). It still
satisfies stable criteria by correcting CRIU handling for the no-BO case
on restore, with the downstream code already safely handling `num_bos ==
0`.

 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 43115a3744694..8535a52a62cab 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2571,8 +2571,8 @@ static int criu_restore(struct file *filep,
 	pr_debug("CRIU restore (num_devices:%u num_bos:%u num_objects:%u priv_data_size:%llu)\n",
 		 args->num_devices, args->num_bos, args->num_objects, args->priv_data_size);
 
-	if (!args->bos || !args->devices || !args->priv_data || !args->priv_data_size ||
-	    !args->num_devices || !args->num_bos)
+	if ((args->num_bos > 0 && !args->bos) || !args->devices || !args->priv_data ||
+	    !args->priv_data_size || !args->num_devices)
 		return -EINVAL;
 
 	mutex_lock(&p->mutex);
-- 
2.51.0

