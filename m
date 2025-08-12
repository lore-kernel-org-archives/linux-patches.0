Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1B9279915;
	Tue, 12 Aug 2025 17:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020904; cv=none; b=BjTxeINjEIkcFhDcULFpeyZeWT9KHXAeLnhuD5hjEJZKMh7A7OEpEAHcWqOmVVCB/o60DbkhMwUZNdDwoWMFbAuS5qoNldpUrA37muWXbJ9+lDLh4vha9aPW9oUgFhfmzY4dYNFSNVU17dPQWT6xhTcb8hnCd6QQjmOSdS8Fy7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020904; c=relaxed/simple;
	bh=pAeF+QRDasdJ95a2GLNkOll13Wd0NWayxM34l1AJeOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z47d5BKpElXtxKh/PqnR/NW9xxm+JsolspI2DKw6WozF7S1saapFqNtvvKHXEoXO6GEjQiBg1yidc1flfPg7YhJ5HKk0FhQfio1rO73roxP5/9FAxx0GuwsEM/T9C/pZ1OxZBnhjU6SoMjBA4q1wCcjuKJiVPPLVIXq68K9o3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+tRAlbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+tRAlbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB0CC4CEF1;
	Tue, 12 Aug 2025 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020904;
	bh=pAeF+QRDasdJ95a2GLNkOll13Wd0NWayxM34l1AJeOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+tRAlbb8DwqgASMSf0EBpjnWbF7Lj1+kuSpn1PfzT9jWmpOnpsuuGZ7RjAGRz6yx
	 jTRHuLb4gAZHoE5YXZS5/8m5mGVhWwmVXFli9Npox8n3E6MzX6o6BPbWVcl7C+7JCa
	 w6U5/eW3YeaFmte3OP7U8z8fmtIu5RjAypqlhPWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivan Zohar-Kotzer <sivany32@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/262] powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()
Date: Tue, 12 Aug 2025 19:26:59 +0200
Message-ID: <20250812172954.292789058@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sivan Zohar-Kotzer <sivany32@gmail.com>

[ Upstream commit 46dc57406887dd02565cb264224194a6776d882b ]

The get_pd_power_uw() function can crash with a NULL pointer dereference
when em_cpu_get() returns NULL. This occurs when a CPU becomes impossible
during runtime, causing get_cpu_device() to return NULL, which propagates
through em_cpu_get() and leads to a crash when em_span_cpus() dereferences
the NULL pointer.

Add a NULL check after em_cpu_get() and return 0 if unavailable,
matching the existing fallback behavior in __dtpm_cpu_setup().

Fixes: eb82bace8931 ("powercap/drivers/dtpm: Scale the power with the load")
Signed-off-by: Sivan Zohar-Kotzer <sivany32@gmail.com>
Link: https://patch.msgid.link/20250701221355.96916-1-sivany32@gmail.com
[ rjw: Drop an excess empty code line ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/dtpm_cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/powercap/dtpm_cpu.c b/drivers/powercap/dtpm_cpu.c
index ae7ee611978b..99a82060ead9 100644
--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -93,6 +93,8 @@ static u64 get_pd_power_uw(struct dtpm *dtpm)
 	int i;
 
 	pd = em_cpu_get(dtpm_cpu->cpu);
+	if (!pd)
+		return 0;
 
 	pd_mask = em_span_cpus(pd);
 
-- 
2.39.5



