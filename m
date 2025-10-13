Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12DA30C371;
	Mon, 13 Oct 2025 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368921; cv=none; b=aJfo8uNCuK+EwlwuvYB+f4Y9VzB5UBn/Q1r4m8qnYZv44ycI1IFnOY/mpr4sDtDD2/V+Op19ZvPVd/tcbmcMIjX1teUfKigsYHTsnaA9VLsqmBNDt7lQi19Cg/HSaWv8KCel7UFeGltMp5F7mK3vw84MwNVeJDktQZnVXQTqb3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368921; c=relaxed/simple;
	bh=EOT4pMTZtlTB5/F2PJFedtne0e/FJfiYKoobpnrMG84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0184IMBWWaZqHm72YVa3c+Jr6+cniLJU1kqwf6OuNYbbTWtivjHhZqMpPgafjCNUqar60VF3rI1asyA2aG5oajjjQ0lfZ0mLXfF2R+Bju9SZDO0nMkLU3z1jryYh5lD0BmInZ+z2bwoJ5mBbSWotaaLmPj0keXfakAzi7J5UfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTK5Z+F8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTK5Z+F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF56C4CEE7;
	Mon, 13 Oct 2025 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368921;
	bh=EOT4pMTZtlTB5/F2PJFedtne0e/FJfiYKoobpnrMG84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTK5Z+F88TIsDRxolbmmUwbO/SQqktjs6EusrwehsLwDIe8uhB6xNuvCGaj6WglLn
	 xW2qM9IAtmIvhuf4axZslqzyUGsBPsqDPnFzHOVTRBRTB95Raqd4orH37HSWQ79gXc
	 AOwJzxKJmByBVbifn173MvFeaYNZGzLH+0YPxScw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 066/563] ACPI: processor: idle: Fix memory leak when register cpuidle device failed
Date: Mon, 13 Oct 2025 16:38:47 +0200
Message-ID: <20251013144413.680389509@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 11b3de1c03fa9f3b5d17e6d48050bc98b3704420 ]

The cpuidle device's memory is leaked when cpuidle device registration
fails in acpi_processor_power_init().  Free it as appropriate.

Fixes: 3d339dcbb56d ("cpuidle / ACPI : move cpuidle_device field out of the acpi_processor_power structure")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20250728070612.1260859-2-lihuisong@huawei.com
[ rjw: Changed the order of the new statements, added empty line after if () ]
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 2c2dc559e0f8d..d0fc045a8d310 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1405,6 +1405,9 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 		if (retval) {
 			if (acpi_processor_registered == 0)
 				cpuidle_unregister_driver(&acpi_idle_driver);
+
+			per_cpu(acpi_cpuidle_device, pr->id) = NULL;
+			kfree(dev);
 			return retval;
 		}
 		acpi_processor_registered++;
-- 
2.51.0



