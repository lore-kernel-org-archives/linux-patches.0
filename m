Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A063B3D568;
	Mon, 18 Dec 2023 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KemPjvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E69C433C8;
	Mon, 18 Dec 2023 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908300;
	bh=llQIt9p6Ylw51jcOz6r+LVb+S9z09gzAeo2uc8s2YGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KemPjvgtJVtUxcJYKssEfZ0MsSKULJwDWcoCe30dHlt9drReHpQ3dE9+CBDMZcmN
	 ovM7J06Mjm39v0Gj9FykSNI5Fs0aDNSr0fh34Vi8L9J2SrRi5uDTurEoD7lOWICZfQ
	 eLnUO4qhWH66IrdauY+GHJU6sCo6FaGDTVi+hqYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 127/166] cxl/hdm: Fix dpa translation locking
Date: Mon, 18 Dec 2023 14:51:33 +0100
Message-ID: <20231218135110.758892717@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 6f5c4eca48ffe18307b4e1d375817691c9005c87 upstream.

The helper, cxl_dpa_resource_start(), snapshots the dpa-address of an
endpoint-decoder after acquiring the cxl_dpa_rwsem. However, it is
sufficient to assert that cxl_dpa_rwsem is held rather than acquire it
in the helper. Otherwise, it triggers multiple lockdep reports:

1/ Tracing callbacks are in an atomic context that can not acquire sleeping
locks:

    BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1525
    in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1288, name: bash
    preempt_count: 2, expected: 0
    RCU nest depth: 0, expected: 0
    [..]
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20230524-3.fc38 05/24/2023
    Call Trace:
     <TASK>
     dump_stack_lvl+0x71/0x90
     __might_resched+0x1b2/0x2c0
     down_read+0x1a/0x190
     cxl_dpa_resource_start+0x15/0x50 [cxl_core]
     cxl_trace_hpa+0x122/0x300 [cxl_core]
     trace_event_raw_event_cxl_poison+0x1c9/0x2d0 [cxl_core]

2/ The rwsem is already held in the inject poison path:

    WARNING: possible recursive locking detected
    6.7.0-rc2+ #12 Tainted: G        W  OE    N
    --------------------------------------------
    bash/1288 is trying to acquire lock:
    ffffffffc05f73d0 (cxl_dpa_rwsem){++++}-{3:3}, at: cxl_dpa_resource_start+0x15/0x50 [cxl_core]

    but task is already holding lock:
    ffffffffc05f73d0 (cxl_dpa_rwsem){++++}-{3:3}, at: cxl_inject_poison+0x7d/0x1e0 [cxl_core]
    [..]
    Call Trace:
     <TASK>
     dump_stack_lvl+0x71/0x90
     __might_resched+0x1b2/0x2c0
     down_read+0x1a/0x190
     cxl_dpa_resource_start+0x15/0x50 [cxl_core]
     cxl_trace_hpa+0x122/0x300 [cxl_core]
     trace_event_raw_event_cxl_poison+0x1c9/0x2d0 [cxl_core]
     __traceiter_cxl_poison+0x5c/0x80 [cxl_core]
     cxl_inject_poison+0x1bc/0x1e0 [cxl_core]

This appears to have been an issue since the initial implementation and
uncovered by the new cxl-poison.sh test [1]. That test is now passing with
these changes.

Fixes: 28a3ae4ff66c ("cxl/trace: Add an HPA to cxl_poison trace events")
Link: http://lore.kernel.org/r/e4f2716646918135ddbadf4146e92abb659de734.1700615159.git.alison.schofield@intel.com [1]
Cc: <stable@vger.kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/hdm.c  |    3 +--
 drivers/cxl/core/port.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -373,10 +373,9 @@ resource_size_t cxl_dpa_resource_start(s
 {
 	resource_size_t base = -1;
 
-	down_read(&cxl_dpa_rwsem);
+	lockdep_assert_held(&cxl_dpa_rwsem);
 	if (cxled->dpa_res)
 		base = cxled->dpa_res->start;
-	up_read(&cxl_dpa_rwsem);
 
 	return base;
 }
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -219,9 +219,9 @@ static ssize_t dpa_resource_show(struct
 			    char *buf)
 {
 	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
-	u64 base = cxl_dpa_resource_start(cxled);
 
-	return sysfs_emit(buf, "%#llx\n", base);
+	guard(rwsem_read)(&cxl_dpa_rwsem);
+	return sysfs_emit(buf, "%#llx\n", (u64)cxl_dpa_resource_start(cxled));
 }
 static DEVICE_ATTR_RO(dpa_resource);
 


