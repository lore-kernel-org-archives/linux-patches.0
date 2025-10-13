Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F179277C8D;
	Mon, 13 Oct 2025 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367465; cv=none; b=Tp3DY1d4rHSEGS+PJ66C+x4AlD3niwyFqVW0Na2MYMuLOQmlpTKAN2z8oV2Y0AyGYB1vfFPvrydVRoky6s+FVfg2Ucn+ZtNKOxLjCjzVZWik5z0e7uJdRIO4G6U23L1HWCK7EPc7uqf7nLbjc5Bp3iZxDDpQMpCUr6lZUaYKlmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367465; c=relaxed/simple;
	bh=6pWfojyJ4sEtvlcsIgvtsb+is1+0WZTt+kkB0Dqoa/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJphxe/CoK2sH1FAxaPXlQI/7oytT5LWFSvh25yG0OLJZRRIDy7HVXquZj/W9UmvK42ngfMuPi4r9DKNj9rzdYXDz6EcEXb7TaCTcSMwh0mPv0tY8uffrnVJfgGcumAcaRz4YanBSZNMjbMibFHnH7ZTAG7wIxuH8kzqSdAbnjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvhDS/ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvhDS/ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A824C113D0;
	Mon, 13 Oct 2025 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367465;
	bh=6pWfojyJ4sEtvlcsIgvtsb+is1+0WZTt+kkB0Dqoa/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvhDS/uaqyRt6LN+4yFutut2JYnvWAoCJ5mMpRB3h5nemseWRdd8sMKcY9o7jgHup
	 Zxk8pbPeS8UmE1Np4vCWE3gGUkVOTJwVDk4gnaOKNFFS8KiFbqzGJCnm4wgf2PouKC
	 a6pykgBB8A9jSXM8dc8F/3FyIQ3w9lcKOcrLwhiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/196] ACPI: processor: idle: Fix memory leak when register cpuidle device failed
Date: Mon, 13 Oct 2025 16:43:32 +0200
Message-ID: <20251013144315.963864670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0888e4d618d53..b524cf27213d4 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1410,6 +1410,9 @@ int acpi_processor_power_init(struct acpi_processor *pr)
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



