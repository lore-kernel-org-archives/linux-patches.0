Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B2D18EFEC;
	Tue, 10 Sep 2024 10:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965222; cv=none; b=DDAlBcXiwZKK35cehvStPXhmGpIUaUMIIP1l/qO/RA7X7PIucgbZLh3sFhjvptZhxwWAB5EBmo8MIyqpIvA39ejYjELbOFvGzC9GH5cdLZg0llTxtOTlyJGS/tNHJkYD0iIxrKbdheQGqH71CAOQTtGGXMZJP3XXHtwkIejTIUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965222; c=relaxed/simple;
	bh=/Bv8ZQjAfwURvEpyM9qC/sMQWh/pSV2tD0SqRWgbzEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djZPxPcbZiKHxrETdWx3zxhnjqHpJSC7gaz5XytN+63jy9thC80mOw2F/uEymotS1yLmWWmWMUXlyOpXJ/UOEp3+j5g6wXq9tIdqTF1wkeAh2Ikv7tLLK/DekcMKtZdJCXovCMWAweFnp2pWcFWX/ZXFwyfL7TrbzQvVLNlDy8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jA7F5p97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jA7F5p97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACBEC4CEC3;
	Tue, 10 Sep 2024 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965222;
	bh=/Bv8ZQjAfwURvEpyM9qC/sMQWh/pSV2tD0SqRWgbzEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA7F5p97SVkurPwjmSxYpNIz77mqkxPIl43AhiCSmIO5UTSg77OfnXxMImRBCyOcr
	 E9dQ1vNqhHuevNU/msw5oe4fVsaNQg1xSlCIPnT0FpOOORLZSGGiyz9fhVXfrVn+/q
	 TO+Kl7bqUre3bZq+UraLSl2an600x39tEv8uE7Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/186] arm64: acpi: Harden get_cpu_for_acpi_id() against missing CPU entry
Date: Tue, 10 Sep 2024 11:34:33 +0200
Message-ID: <20240910092601.958904737@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d1da93a5bad..702587fda70c 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -102,7 +102,8 @@ static inline int get_cpu_for_acpi_id(u32 uid)
 	int cpu;
 
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
-		if (uid == get_acpi_id_for_cpu(cpu))
+		if (acpi_cpu_get_madt_gicc(cpu) &&
+		    uid == get_acpi_id_for_cpu(cpu))
 			return cpu;
 
 	return -EINVAL;
-- 
2.43.0



