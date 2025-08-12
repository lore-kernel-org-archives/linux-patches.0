Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBC22FFDD8;
	Tue, 12 Aug 2025 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024030; cv=none; b=kEAXrqXS1HFnhAaqjqq87Rw3yefrBXsUpWbF4CWHCaXAmuLBIKhjNm0ngcYwe8h7W72TFRcknxF0jQ08fn86f96XMExstt24MTWc51GDJy3mXhCj4zkr15/nerjtypRYreoO5q3A7zsIkFMrseoy25RBE3wBU8alHr7zqT/qJhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024030; c=relaxed/simple;
	bh=VBqyFfxNbcTNLoX4pSqYzNcnm53zT+UsWdWUl3MG/sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ff0QY3zl7HGP6K++8+f5PyUGmQb7VRDu+zidLwlxK4nA1dR+7vbgu+mot8JinCQoZSNj48JTT3dVN2N3LhECuX7SA4DzhRpmWFoGBqyLU4IyzfC8qR6oR5Pfno1/wsftqMyg+CJa1QReFt1OBlaAUHnrV1MZQAyA4MUCc4mRNZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjoRWApb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjoRWApb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73486C4CEF0;
	Tue, 12 Aug 2025 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024029;
	bh=VBqyFfxNbcTNLoX4pSqYzNcnm53zT+UsWdWUl3MG/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjoRWApb+yThv02oAkNqrDf32IANQbdJU+PWLoJ5U6cPDiL0jpMz3uWmpwB8DwtFZ
	 fek4+p1ksCQ2AzgG40QM610yWEj9hsmHDmtW7lZ15b7kh6Cs7QJ/MsOVxtOxWkwrlJ
	 bhSgZunOLVTwkaqI7uGoF1EfXgTng7ilSuPKofnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Milon <ethan.milon@eviden.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 253/627] iommu/vt-d: Fix UAF on sva unbind with pending IOPFs
Date: Tue, 12 Aug 2025 19:29:08 +0200
Message-ID: <20250812173428.935976317@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit f0b9d31c6edd50a6207489cd1bd4ddac814b9cd2 ]

Commit 17fce9d2336d ("iommu/vt-d: Put iopf enablement in domain attach
path") disables IOPF on device by removing the device from its IOMMU's
IOPF queue when the last IOPF-capable domain is detached from the device.
Unfortunately, it did this in a wrong place where there are still pending
IOPFs. As a result, a use-after-free error is potentially triggered and
eventually a kernel panic with a kernel trace similar to the following:

 refcount_t: underflow; use-after-free.
 WARNING: CPU: 3 PID: 313 at lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
 Workqueue: iopf_queue/dmar0-iopfq iommu_sva_handle_iopf
 Call Trace:
   <TASK>
   iopf_free_group+0xe/0x20
   process_one_work+0x197/0x3d0
   worker_thread+0x23a/0x350
   ? rescuer_thread+0x4a0/0x4a0
   kthread+0xf8/0x230
   ? finish_task_switch.isra.0+0x81/0x260
   ? kthreads_online_cpu+0x110/0x110
   ? kthreads_online_cpu+0x110/0x110
   ret_from_fork+0x13b/0x170
   ? kthreads_online_cpu+0x110/0x110
   ret_from_fork_asm+0x11/0x20
   </TASK>
  ---[ end trace 0000000000000000 ]---

The intel_pasid_tear_down_entry() function is responsible for blocking
hardware from generating new page faults and flushing all in-flight
ones. Therefore, moving iopf_for_domain_remove() after this function
should resolve this.

Fixes: 17fce9d2336d ("iommu/vt-d: Put iopf enablement in domain attach path")
Reported-by: Ethan Milon <ethan.milon@eviden.com>
Closes: https://lore.kernel.org/r/e8b37f3e-8539-40d4-8993-43a1f3ffe5aa@eviden.com
Suggested-by: Ethan Milon <ethan.milon@eviden.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20250723072045.1853328-1-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 72b477911fdb..c0be0b64e4c7 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3999,8 +3999,8 @@ static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 
-	iopf_for_domain_remove(old, dev);
 	intel_pasid_tear_down_entry(info->iommu, dev, pasid, false);
+	iopf_for_domain_remove(old, dev);
 	domain_remove_dev_pasid(old, dev, pasid);
 
 	return 0;
-- 
2.39.5



