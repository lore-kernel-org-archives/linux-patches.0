Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77C42D7806;
	Mon, 27 Oct 2025 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590375; cv=none; b=Zh7+CoNOxk6aK1fcPeI1A7xgTBsIo8HB5FotsiXehlnIVtp6OzZerkuhm2ZTkcxb+rilt4/+WOIfmRwuS+zetvGbhnuJqGSwl8XbEQqiAERJWZd+pnDSR0abiBEQZF7jSY1lznygx2b/uIKKJrI+KwEV6LJw1w1pMdVx6+h7x3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590375; c=relaxed/simple;
	bh=fK6mBLkgOjFb5NUWrIOxaiY5HDIUqieFgN08ky5lzqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9/GzS7e+DBxDAaGIoOFGFzwg81Y+M20zdl3R3Va+pUxREN5QCa28H0IPIxA2/6GNYKWL0TqCTZ7qNUxbnI2nT87kxkqE205HWEGdT5d6XuMV7q9nh7hX1fIZHNjq/KP8ciKPx/8deKI1zTFWXX2iFQDFGFTH2T7MRXgvqiOv2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5GIK2RJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5GIK2RJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4312DC4CEF1;
	Mon, 27 Oct 2025 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590375;
	bh=fK6mBLkgOjFb5NUWrIOxaiY5HDIUqieFgN08ky5lzqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5GIK2RJLsDviGX4cAh1dqnMOjH7FHVFVsrYAgqfi/Wk3TgP5fPaSEPlsQh98HU/j
	 7n4PEiHnFdqqioOB0XOS+ZxTdAA98O42x9M8LQOP9+dAebDZK+8pTewOpHscqr+5ac
	 RDojauzNCcVkK1/DBry0HbA0DhrDhSm3WzA2TRcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/224] ACPI: processor: idle: Fix memory leak when register cpuidle device failed
Date: Mon, 27 Oct 2025 19:32:47 +0100
Message-ID: <20251027183509.567462254@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e6bba26caf3c8..86655d65f3215 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1506,6 +1506,9 @@ int acpi_processor_power_init(struct acpi_processor *pr)
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



