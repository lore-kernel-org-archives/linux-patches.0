Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B50243376;
	Wed, 25 Feb 2026 01:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983566; cv=none; b=jIZYCz5FrUPhhhEItIZbaWEswkijFRD7cyZ3oybQgTo40wCocqX04hPA8hn0W4rzZnS/j77t2kSpqOkGQMXaFFP+GSSyq3kc8JNjzR05ErzvyAt/boFQ83WYmdORXl0dmZaOnCap4rHtTTWhZ6fULCAx2qZH7nl/3X1tnBcnKbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983566; c=relaxed/simple;
	bh=fKIgDVXnNpHZSHseJ+TE0BcLgvL98Lrwl/Rd3B2JQ9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUoAVJR+z+A+k8fabRR0O7xzFywn3mJjJGhYEjUXZaROlp5Uz+LnwmjcgX+cRuri7kD402155Ct8ylyUr3eUDDvU1HVsiPdDMGY0eGEaV1NskEQSxouCNtGuezAgs9UwEdBRf5rZLwySeG7I4yNz/eI0w/CzAzwfsgBGmqDELBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rjs254J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rjs254J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D17C116D0;
	Wed, 25 Feb 2026 01:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983566;
	bh=fKIgDVXnNpHZSHseJ+TE0BcLgvL98Lrwl/Rd3B2JQ9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rjs254JDKnJ3dSYrNOOnzqa9LsKDjR3vL16Ay6VW9zrw+wcv7Kxcf9PuCVBt5uh/
	 qIFxMYWD9PtVW8tUbEaQ1aD4dPxNKDBnq6ldMtFR9dlxbMmDZcfA6jc/g7GOseQJo4
	 1TPlm6vB0B3PNrmTFKUIhqMotzvec7G4JhL+2nKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean V Kelley <skelley@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 624/781] ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs
Date: Tue, 24 Feb 2026 17:22:13 -0800
Message-ID: <20260225012415.117875631@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean V Kelley <skelley@nvidia.com>

[ Upstream commit 56eb0c0ed345da7815274aa821a8546a073d7e97 ]

per_cpu(cpc_desc_ptr, cpu) object is initialized for only the online
CPUs via acpi_soft_cpu_online() --> __acpi_processor_start() -->
acpi_cppc_processor_probe().

However, send_pcc_cmd() and acpi_get_psd_map() still iterate over all
possible CPUs. In acpi_get_psd_map(), encountering an offline CPU
returns -EFAULT, causing cppc_cpufreq initialization to fail.

This breaks systems booted with "nosmt" or "nosmt=force".

Fix by using for_each_online_cpu() in both functions.

Fixes: 80b8286aeec0 ("ACPI / CPPC: support for batching CPPC requests")
Signed-off-by: Sean V Kelley <skelley@nvidia.com>
Link: https://patch.msgid.link/20260211212254.30190-1-skelley@nvidia.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index e66e20d1f31b7..b59b0100d03c5 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -362,7 +362,7 @@ static int send_pcc_cmd(int pcc_ss_id, u16 cmd)
 end:
 	if (cmd == CMD_WRITE) {
 		if (unlikely(ret)) {
-			for_each_possible_cpu(i) {
+			for_each_online_cpu(i) {
 				struct cpc_desc *desc = per_cpu(cpc_desc_ptr, i);
 
 				if (!desc)
@@ -524,7 +524,7 @@ int acpi_get_psd_map(unsigned int cpu, struct cppc_cpudata *cpu_data)
 	else if (pdomain->coord_type == DOMAIN_COORD_TYPE_SW_ANY)
 		cpu_data->shared_type = CPUFREQ_SHARED_TYPE_ANY;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		if (i == cpu)
 			continue;
 
-- 
2.51.0



