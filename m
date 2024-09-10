Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35440188921;
	Tue, 10 Sep 2024 09:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962173; cv=none; b=npZ9IHVkmi+xXNDXnyfi9TnnOzAK5QFQZqjAP6Lb23CjWnWmjtZZRPiimiT86WzQ+KtM9WQumIZh9Lv+KyBy5hbblW26aHpytIXZJPjwI+/gHeTAy8fIi34svP6gaOdmy2yvv6mJn5F9LQ4J+rsyWADQ9PA1EQUwLP6o1JUw3P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962173; c=relaxed/simple;
	bh=6tcACk8gDMvJ64I6DIn5AfVIjLQMl2bUzMU3v/3BozU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZnz4pGeqEPJ6dhEeoJ4nfgPZw9gHwNHP7nu6V1vHssA3++p9kmkoLkQ49ClptTA0DHQepJ0qmIlHxewzAsftkNxHYoAnSstiidtkKLFEFxYjl+4dB1zo6eCWD/LVWf/jQJ9Kz/roOLBgoQrucyO8Jj0aQQBdIi35cJKq8BFLxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pChSZKwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pChSZKwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65277C4CEC3;
	Tue, 10 Sep 2024 09:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962172;
	bh=6tcACk8gDMvJ64I6DIn5AfVIjLQMl2bUzMU3v/3BozU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pChSZKwlVnLBLWBS0YjAlbHFk/Z+ylVaRbrDqt7fdvwcbBsHGp0l9RdAcwWv+7mob
	 u3UCORJanAS0vY87cwgDEOCunoQvv2AbmLJXRuzYaA0WA3y2fZIFDyYWSthEtwyfZr
	 DY1TayFbcQKUc0Isp8ZKe+v2VwmCfKH7CmQvUCQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 320/375] arm64: acpi: Harden get_cpu_for_acpi_id() against missing CPU entry
Date: Tue, 10 Sep 2024 11:31:57 +0200
Message-ID: <20240910092633.316333720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index bc9a6656fc0c..a407f9cd549e 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -124,7 +124,8 @@ static inline int get_cpu_for_acpi_id(u32 uid)
 	int cpu;
 
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
-		if (uid == get_acpi_id_for_cpu(cpu))
+		if (acpi_cpu_get_madt_gicc(cpu) &&
+		    uid == get_acpi_id_for_cpu(cpu))
 			return cpu;
 
 	return -EINVAL;
-- 
2.43.0



