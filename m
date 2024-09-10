Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1D519A281;
	Tue, 10 Sep 2024 10:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962681; cv=none; b=Y0budExAGO4Xr+iW6354FUlMPTFkyHL9JsqbQ05PjijAO0976bDQxh/4buerwRQQJDvjEvlRV4BosjHBWuyy64GunctnYZ8QbI6HXH8Th2h9lRMP4xga34/00/Mgs7a/8x/GEph9Z6EvvPXNPQ6aE8PVbyf/d/aa/+VjDKXlXEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962681; c=relaxed/simple;
	bh=kTJIwBmwGpkC+yRAKbSse2szuPhxB9MucxLwZAUnoXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwf4kpOeZPYZJx/hnVBrRroYsf6QSkVrF6zgyo7GqFE9xcoKusV7subjJof58F9RLujtefFKGWO2t2J/s/CBsZnFC6SrJYNqKqsVsq6aj6Vzpp2c9bx74xBUxRzkQOGOuxlhTKKP0W+pDubfCV7RxorEqBcjFbbCB4UjCzpvrPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unNrjQz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unNrjQz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB6DC4CEC6;
	Tue, 10 Sep 2024 10:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962681;
	bh=kTJIwBmwGpkC+yRAKbSse2szuPhxB9MucxLwZAUnoXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unNrjQz8SxZe5/beMVodTbpbXM724y/oQfWYcEMnECbl6Oi6r5ml18gCk5/uVFopP
	 pfsuSqwGds917mxq1+Om9ehN7Fp685YLiw9xAnzDHkt7q5JCvRVIY5fQOnvnH1g4oD
	 ebw9KB7w73BKu2q8x1UFvQaXnc/+mX0Cz0RFuHjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/121] arm64: acpi: Harden get_cpu_for_acpi_id() against missing CPU entry
Date: Tue, 10 Sep 2024 11:33:10 +0200
Message-ID: <20240910092551.266156888@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 2488444274c70038eb6b686cba5f1ce48ebb9cdd ]

In a review discussion of the changes to support vCPU hotplug where
a check was added on the GICC being enabled if was online, it was
noted that there is need to map back to the cpu and use that to index
into a cpumask. As such, a valid ID is needed.

If an MPIDR check fails in acpi_map_gic_cpu_interface() it is possible
for the entry in cpu_madt_gicc[cpu] == NULL.  This function would
then cause a NULL pointer dereference.   Whilst a path to trigger
this has not been established, harden this caller against the
possibility.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240529133446.28446-13-Jonathan.Cameron@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/acpi.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index f391ea7a5409..cbf97e648d19 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -115,7 +115,8 @@ static inline int get_cpu_for_acpi_id(u32 uid)
 	int cpu;
 
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
-		if (uid == get_acpi_id_for_cpu(cpu))
+		if (acpi_cpu_get_madt_gicc(cpu) &&
+		    uid == get_acpi_id_for_cpu(cpu))
 			return cpu;
 
 	return -EINVAL;
-- 
2.43.0



