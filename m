Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13D42F261C;
	Wed, 28 Jan 2026 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615509; cv=none; b=ogaZXgGVoZJv2NT8l/PLWeA7BHvtBntsMwqRwlF78c8lQbIiukF/cAnagixkE2hmo/HZHeC14hzJN7oUB7VFhXd2d0/m1YjgFRR8ui+KbAkZNCFb4jv4KQloV4OsAI2j0hs3svCLDMzO92GPTBvYVllv2nHeFnm05RYsOQf62xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615509; c=relaxed/simple;
	bh=q16z+j2KwHdG7oVg/VUImNR4wEF9j8UmfT4NS9bNK2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYKaRSdJTzTzNp8P9RbLoWKD2Cpw7924nR/X+GU1Lv4sX2Z2t55qJYScu08khfWIB6bO/M/e0FPnsL7eVzJyoXfdgXL65FO5vsQ9vmPdR2KXSZay/n8ndRmSggFYYPNwc7BlopcwbAyCxIschNj2DRjabfLDAQin/PUl2FpcfMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTI+otmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTI+otmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF88C4CEF1;
	Wed, 28 Jan 2026 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615509;
	bh=q16z+j2KwHdG7oVg/VUImNR4wEF9j8UmfT4NS9bNK2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTI+otmbIVaKqZXySZuWEtcvNMBsgfi1J4RYkv5tKePKpzlbB0Rh6J9t1bUp+YiP9
	 G7/jq+3cUisaQBby6xR2nFSbb4cvlSSctprR7iEqWG+flsAVxSssPbJGCNilFwBFhN
	 h3qjZtglfj/djFfEiSlmvvjc4TNXEO9D3PdprOg0=
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
Subject: [PATCH 6.18 006/227] Drivers: hv: Always do Hyper-V panic notification in hv_kmsg_dump()
Date: Wed, 28 Jan 2026 16:20:51 +0100
Message-ID: <20260128145344.568009889@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e109a620c83fc..71fd3ea4fa8bd 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -195,13 +195,15 @@ static void hv_kmsg_dump(struct kmsg_dumper *dumper,
 
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
@@ -210,7 +212,7 @@ static void hv_kmsg_dump(struct kmsg_dumper *dumper,
 	hv_set_msr(HV_MSR_CRASH_P0, 0);
 	hv_set_msr(HV_MSR_CRASH_P1, 0);
 	hv_set_msr(HV_MSR_CRASH_P2, 0);
-	hv_set_msr(HV_MSR_CRASH_P3, virt_to_phys(hv_panic_page));
+	hv_set_msr(HV_MSR_CRASH_P3, bytes_written ? virt_to_phys(hv_panic_page) : 0);
 	hv_set_msr(HV_MSR_CRASH_P4, bytes_written);
 
 	/*
-- 
2.51.0



