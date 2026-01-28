Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A421A1E1DFC;
	Wed, 28 Jan 2026 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614928; cv=none; b=tJ0jozxW6bA+uuzeA94PVS7s925S4oZjFQe2+lxSLKOSaywW7z/yWSJAk277p3ALMn7c4Yn96PMo7yF0t12WDRQFS9OnUnLY7OY/fEWiuVvBOT42EzhEgwaPV+IU7r9faRPeozm7r8xqwtmcXsz0sN4Mg5lL66xoXQRsFG6kjG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614928; c=relaxed/simple;
	bh=iigL5eXVL4/0ZjOSYpoqnmAbxz0YZs4IFehEzOe3tT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkTQC8Y7AqiW9BOOEr51nO1ZaZ5mfzfgG6s0kHw7FVjSnwuRUDSvRKM9Gy9R4X1YYwtvMN3Q6kW/sxj5r8bdXclrjLSo1W4loG7OVHvJ4iv7f7A+1ipZpAR1wsbcPmX2uDlAjNADX5yBA/6+N+ZGXxGHvnDMd6ZDyPHMJgUB9XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqXRUYlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqXRUYlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B86C4CEF1;
	Wed, 28 Jan 2026 15:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614928;
	bh=iigL5eXVL4/0ZjOSYpoqnmAbxz0YZs4IFehEzOe3tT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqXRUYljsqeqbk11wVVqFymuMgBfcFv9/mOH332WZ9b1tu1dse02xBdVgw8Et07EN
	 /emM66fVSvBcrhHZ4JPVeFVkhmbxHEfaWfZTaSgJ+mJlbSVZDjO+Y9i5uTa297Muip
	 EvdkMGt8bBTg5IDZSuvMDypJPfrGdvymEbeBWVjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Roman Kisel <vdso@mailbox.org>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/169] Drivers: hv: Always do Hyper-V panic notification in hv_kmsg_dump()
Date: Wed, 28 Jan 2026 16:21:34 +0100
Message-ID: <20260128145334.422274791@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit 49f49d47af67f8a7b221db1d758fc634242dc91a ]

hv_kmsg_dump() currently skips the panic notification entirely if it
doesn't get any message bytes to pass to Hyper-V due to an error from
kmsg_dump_get_buffer(). Skipping the notification is undesirable because
it leaves the Hyper-V host uncertain about the state of a panic'ed guest.

Fix this by always doing the panic notification, even if bytes_written
is zero. Also ensure that bytes_written is initialized, which fixes a
kernel test robot warning. The warning is actually bogus because
kmsg_dump_get_buffer() happens to set bytes_written even if it fails, and
in the kernel test robot's CONFIG_PRINTK not set case, hv_kmsg_dump() is
never called. But do the initialization for robustness and to quiet the
static checker.

Fixes: 9c318a1d9b50 ("Drivers: hv: move panic report code from vmbus to hv early init code")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/202512172103.OcUspn1Z-lkp@intel.com/
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Roman Kisel <vdso@mailbox.org>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_common.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 7a35c82976e0f..f69dd08475114 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -218,13 +218,15 @@ static void hv_kmsg_dump(struct kmsg_dumper *dumper,
 
 	/*
 	 * Write dump contents to the page. No need to synchronize; panic should
-	 * be single-threaded.
+	 * be single-threaded. Ignore failures from kmsg_dump_get_buffer() since
+	 * panic notification should be done even if there is no message data.
+	 * Don't assume bytes_written is set in case of failure, so initialize it.
 	 */
 	kmsg_dump_rewind(&iter);
-	kmsg_dump_get_buffer(&iter, false, hv_panic_page, HV_HYP_PAGE_SIZE,
+	bytes_written = 0;
+	(void)kmsg_dump_get_buffer(&iter, false, hv_panic_page, HV_HYP_PAGE_SIZE,
 			     &bytes_written);
-	if (!bytes_written)
-		return;
+
 	/*
 	 * P3 to contain the physical address of the panic page & P4 to
 	 * contain the size of the panic data in that page. Rest of the
@@ -233,7 +235,7 @@ static void hv_kmsg_dump(struct kmsg_dumper *dumper,
 	hv_set_msr(HV_MSR_CRASH_P0, 0);
 	hv_set_msr(HV_MSR_CRASH_P1, 0);
 	hv_set_msr(HV_MSR_CRASH_P2, 0);
-	hv_set_msr(HV_MSR_CRASH_P3, virt_to_phys(hv_panic_page));
+	hv_set_msr(HV_MSR_CRASH_P3, bytes_written ? virt_to_phys(hv_panic_page) : 0);
 	hv_set_msr(HV_MSR_CRASH_P4, bytes_written);
 
 	/*
-- 
2.51.0



