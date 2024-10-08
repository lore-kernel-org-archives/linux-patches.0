Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEA117DFF7;
	Tue,  8 Oct 2024 12:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390734; cv=none; b=QztqDQxXIvDVtJ7hxXOD34zHcAOD+NknkKroAJ/vNe23jFuviQFpOYQsXGtqGDXWV/hjQOm6ag48ZWrP4b8+HVSeOZgz5xx1eJQdbeR84UKf7GBK9Ar2iXf9gO30vCzD+pSd28MeGnKbHX+gQl2NKl5FhtjuwNKYs93uMNA6HLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390734; c=relaxed/simple;
	bh=bPa0d10NkrHj44uHhxXxDbAm3pSUWMs3h/1B9er1BzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgAJ8j8OCJswMV7v9yYaW6KvEcuXorr8k7BGK+HqO5sEONYCreRQpzdmZU7JU8PJWTiypubFLtEp994fusnJrRYA92tSr6WyPiM9A8KhFAYnd9E2KH38PPIPG0JwihdtNGLYieEWR5QpB0da4I1JaYuE6AzZ3cYIbAhUaZZLqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ty3/Nook; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ty3/Nook"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92820C4CEC7;
	Tue,  8 Oct 2024 12:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390734;
	bh=bPa0d10NkrHj44uHhxXxDbAm3pSUWMs3h/1B9er1BzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ty3/Nook0wSkCqTQtJfLwp1+tgV4aRkt6C1J/vHKsMVb1bP4HUlvQMmCVjPQwfIdB
	 9dAShmU5jWmf6pvhcO6VgefkTmroWen+S+gM6rH1+V7WBTvuBYTpsAfuxCSOclnG7d
	 OGFFkw+9iz669M9l6p/5Jk3T+SwUnUjAGPQ2OehI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.10 377/482] drivers/perf: riscv: Align errno for unsupported perf event
Date: Tue,  8 Oct 2024 14:07:20 +0200
Message-ID: <20241008115703.255120029@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

commit c625154993d0d24a962b1830cd5ed92adda2cf86 upstream.

RISC-V perf driver does not yet support PERF_TYPE_BREAKPOINT. It would
be more appropriate to return -EOPNOTSUPP or -ENOENT for this type in
pmu_sbi_event_map. Considering that other implementations return -ENOENT
for unsupported perf types, let's synchronize this behavior. Due to this
reason, a riscv bpf testcases perf_skip fail. Meanwhile, align that
behavior to the rest of proper place.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Fixes: 9b3e150e310e ("RISC-V: Add a simple platform driver for RISC-V legacy perf")
Fixes: 16d3b1af0944 ("perf: RISC-V: Check standard event availability")
Fixes: e9991434596f ("RISC-V: Add perf platform driver based on SBI PMU extension")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240831071520.1630360-1-pulehui@huaweicloud.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_legacy.c |    4 ++--
 drivers/perf/riscv_pmu_sbi.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/perf/riscv_pmu_legacy.c
+++ b/drivers/perf/riscv_pmu_legacy.c
@@ -22,13 +22,13 @@ static int pmu_legacy_ctr_get_idx(struct
 	struct perf_event_attr *attr = &event->attr;
 
 	if (event->attr.type != PERF_TYPE_HARDWARE)
-		return -EOPNOTSUPP;
+		return -ENOENT;
 	if (attr->config == PERF_COUNT_HW_CPU_CYCLES)
 		return RISCV_PMU_LEGACY_CYCLE;
 	else if (attr->config == PERF_COUNT_HW_INSTRUCTIONS)
 		return RISCV_PMU_LEGACY_INSTRET;
 	else
-		return -EOPNOTSUPP;
+		return -ENOENT;
 }
 
 /* For legacy config & counter index are same */
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -305,7 +305,7 @@ static void pmu_sbi_check_event(struct s
 			  ret.value, 0x1, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
 	} else if (ret.error == SBI_ERR_NOT_SUPPORTED) {
 		/* This event cannot be monitored by any counter */
-		edata->event_idx = -EINVAL;
+		edata->event_idx = -ENOENT;
 	}
 }
 
@@ -539,7 +539,7 @@ static int pmu_sbi_event_map(struct perf
 		}
 		break;
 	default:
-		ret = -EINVAL;
+		ret = -ENOENT;
 		break;
 	}
 


