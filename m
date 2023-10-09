Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAD318B00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7nxi3uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83963C433C7;
	Mon,  9 Oct 2023 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856945;
	bh=0Q4y1nCmP/ql+CwHwNR6sAaEtMRl60wt2xoIduMZlp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7nxi3uEXiNFrApAKW6WmJ9MtZoLy+AgYwZatX7pY6KvERtj6yCEu6KjpjIwrCzuG
	 9DmpuDhDPU/Hmdj+EXG0BzP8Pdf6FQo2ObVKibULbxU32oLyEe5mj7pKK6WSdmot9o
	 +UF1XIyalcSBSabUaScYX43e8dc91w3JqA2+3g9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jithu Joseph <jithu.joseph@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.5 044/163] platform/x86/intel/ifs: release cpus_read_lock()
Date: Mon,  9 Oct 2023 15:00:08 +0200
Message-ID: <20231009130125.235968023@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jithu Joseph <jithu.joseph@intel.com>

commit 2545deba314eec91dc5ca1a954fe97f91ef1cf07 upstream.

Couple of error paths in do_core_test() was returning directly without
doing a necessary cpus_read_unlock().

Following lockdep warning was observed when exercising these scenarios
with PROVE_RAW_LOCK_NESTING enabled:

[  139.304775] ================================================
[  139.311185] WARNING: lock held when returning to user space!
[  139.317593] 6.6.0-rc2ifs01+ #11 Tainted: G S      W I
[  139.324499] ------------------------------------------------
[  139.330908] bash/11476 is leaving the kernel with locks still held!
[  139.338000] 1 lock held by bash/11476:
[  139.342262]  #0: ffffffffaa26c930 (cpu_hotplug_lock){++++}-{0:0}, at:
do_core_test+0x35/0x1c0 [intel_ifs]

Fix the flow so that all scenarios release the lock prior to returning
from the function.

Fixes: 5210fb4e1880 ("platform/x86/intel/ifs: Sysfs interface for Array BIST")
Cc: stable@vger.kernel.org
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Link: https://lore.kernel.org/r/20230927184824.2566086-1-jithu.joseph@intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/ifs/runtest.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 1061eb7ec399..43c864add778 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -331,14 +331,15 @@ int do_core_test(int cpu, struct device *dev)
 	switch (test->test_num) {
 	case IFS_TYPE_SAF:
 		if (!ifsd->loaded)
-			return -EPERM;
-		ifs_test_core(cpu, dev);
+			ret = -EPERM;
+		else
+			ifs_test_core(cpu, dev);
 		break;
 	case IFS_TYPE_ARRAY_BIST:
 		ifs_array_test_core(cpu, dev);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 out:
 	cpus_read_unlock();
-- 
2.42.0



