Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7501DFEF;
	Wed, 20 Nov 2024 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107496; cv=none; b=RIpc3uVVUtd78mrulMdu0TasseMKdSEilY2kP3g1RM6E+UrcqRnHDNAVd2dK4nf9j2rzaP+Aur+YBjeVhxwV+tHLm2eruQGSAXS6ft1djPsZpu7irSADZpG43rxacE8N+0oLienXSVjH0L9xFU0sTQ1N7WKwIclT/rxsz21xENs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107496; c=relaxed/simple;
	bh=GjLC3r2jKwRXNKuFzVgw4zxMhWZ2R1bXwxa0O21++MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLMbHsRn7OCiNiREnHbgahTLqX9mprvo9l7y278Q8+AbL+VoREAGJQe7KT+sVWlAUhTHGASV/3kORyToetpFghNv3gHmRzUl1SabDUp0w++G7Lpj5RuVbQkD7h8Ryoni0mTDomQ52wsDBkC/1DbydokNYKqdUwf5LU+E7X6X16g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+n5O96y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+n5O96y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0374C4CED6;
	Wed, 20 Nov 2024 12:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107496;
	bh=GjLC3r2jKwRXNKuFzVgw4zxMhWZ2R1bXwxa0O21++MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+n5O96yxm9R3OEa6vQ9RV7K6Xe9Ado0/JovahiFfgtarsxglAHXNDo3YM24C3tA4
	 ey/Cc20C/S6jsHdtzkNVwlizaLaIjYFv6U4kGKKKsPRuBHPRXdimR8HbYY2dtcSu5+
	 G0+awIHCKCGSA31OQzTYvX85i95+Y1AhXC/3OYCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 019/107] drivers: perf: Fix wrong put_cpu() placement
Date: Wed, 20 Nov 2024 13:55:54 +0100
Message-ID: <20241120125630.109356471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 57f7c7dc78cd09622b12920d92b40c1ce11b234e ]

Unfortunately, the wrong patch version was merged which places the
put_cpu() after enabling a static key, which is not safe as pointed by
Will [1], so move put_cpu() before to avoid this.

Fixes: 2840dadf0dde ("drivers: perf: Fix smp_processor_id() use in preemptible code")
Reported-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/all/20240827125335.GD4772@willie-the-truck/ [1]
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20241112113422.617954-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 671dc55cbd3a8..bc562c759e1e9 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1380,8 +1380,9 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 			goto out_unregister;
 
 		cpu = get_cpu();
-
 		ret = pmu_sbi_snapshot_setup(pmu, cpu);
+		put_cpu();
+
 		if (ret) {
 			/* Snapshot is an optional feature. Continue if not available */
 			pmu_sbi_snapshot_free(pmu);
@@ -1395,7 +1396,6 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 			 */
 			static_branch_enable(&sbi_pmu_snapshot_available);
 		}
-		put_cpu();
 	}
 
 	register_sysctl("kernel", sbi_pmu_sysctl_table);
-- 
2.43.0



