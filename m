Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95923859E3;
	Tue, 10 Mar 2026 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141242; cv=none; b=iKcMbA2ad1csYLejT4EbI1yWi03E1fD8VXH18LvQj6NGcqaKFPX94vssTezksiYNUWzGPlNQoXHjkCjOoL0GqcHdyiI962ZAzpGkNsuj0LfWqjI2qiwFPf/NoXzzsGWvK8NcWxFIAE1zseVCObSk0pmKsarSGAcFWUfIJAtXs24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141242; c=relaxed/simple;
	bh=Ow6nnxeBnDe0FRFoGrk6X25E76YqPOB8wV/+O6djx3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZp0AB3Sf4borjMqDj8CHXvkOF/O+IMDYZVf5yNES7SFBuag7oyG4GaluKA7PRbXNvntgFHzyw0qA+gGTdfxt4hHzybdJq1pdjNetNBJ8fKpTPRnZWRGgidhSr4fq1TIsbmfBd14hLYfQ8KYYP8sgUf3N/FUltZgeJeif7JgzjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=No+WlM/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="No+WlM/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F32FC2BCAF;
	Tue, 10 Mar 2026 11:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141242;
	bh=Ow6nnxeBnDe0FRFoGrk6X25E76YqPOB8wV/+O6djx3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No+WlM/P0Aq0O/jxH6dbRE9zqYiJVN+jSV6JWt6YNAjEMLorZUJ5pUUDYE6gQJKlf
	 bai/ZQqMGOvcgAghavxiUCEACzgkN0dLNCwQ6qmDC+9uWmP3M6XL2QVppuXS9H8ug/
	 9sk3kKkflcDBUT13EZ1Lp0XdMwbxBg5wiTkwdrmMBs5vwtp0Il6biRM/PVXLTFiOtu
	 eifIfPAeer6uVJnllilVofE6e7iWEqJ4DRDulVRTpDCpHa4XIftWqmDUCiYGgJXZk3
	 zUin/HqbHV3t6UJ78Ulyc6uG7IB8Iua7ZrAr5+2PnMXp+nseFaN2109uWMht12sWB2
	 4H9SzFk+P8VVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Thomson <dt@linux-mail.net>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 245/311] xen/acpi-processor: fix _CST detection using undersized evaluation buffer
Date: Tue, 10 Mar 2026 07:04:52 -0400
Message-ID: <afecefa5012b5d4ca94b126212c012db6a0ae67b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Thomson <dt@linux-mail.net>

[ Upstream commit 8b57227d59a86fc06d4f09de08f98133680f2cae ]

read_acpi_id() attempts to evaluate _CST using a stack buffer of
sizeof(union acpi_object) (48 bytes), but _CST returns a nested Package
of sub-Packages (one per C-state, each containing a register descriptor,
type, latency, and power) requiring hundreds of bytes. The evaluation
always fails with AE_BUFFER_OVERFLOW.

On modern systems using FFH/MWAIT entry (where pblk is zero), this
causes the function to return before setting the acpi_id_cst_present
bit. In check_acpi_ids(), flags.power is then zero for all Phase 2 CPUs
(physical CPUs beyond dom0's vCPU count), so push_cxx_to_hypervisor() is
never called for them.

On a system with dom0_max_vcpus=2 and 8 physical CPUs, only PCPUs 0-1
receive C-state data. PCPUs 2-7 are stuck in C0/C1 idle, unable to
enter C2/C3. This costs measurable wall power (4W observed on an Intel
Core Ultra 7 265K with Xen 4.20).

The function never uses the _CST return value -- it only needs to know
whether _CST exists. Replace the broken acpi_evaluate_object() call with
acpi_has_method(), which correctly detects _CST presence using
acpi_get_handle() without any buffer allocation. This brings C-state
detection to parity with the P-state path, which already works correctly
for Phase 2 CPUs.

Fixes: 59a568029181 ("xen/acpi-processor: C and P-state driver that uploads said data to hypervisor.")
Signed-off-by: David Thomson <dt@linux-mail.net>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260224093707.19679-1-dt@linux-mail.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-acpi-processor.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index f2e8eaf684ba6..8d1860bd5d578 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -379,11 +379,8 @@ read_acpi_id(acpi_handle handle, u32 lvl, void *context, void **rv)
 			 acpi_psd[acpi_id].domain);
 	}
 
-	status = acpi_evaluate_object(handle, "_CST", NULL, &buffer);
-	if (ACPI_FAILURE(status)) {
-		if (!pblk)
-			return AE_OK;
-	}
+	if (!pblk && !acpi_has_method(handle, "_CST"))
+		return AE_OK;
 	/* .. and it has a C-state */
 	__set_bit(acpi_id, acpi_id_cst_present);
 
-- 
2.51.0

