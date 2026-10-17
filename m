Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001C3C73F6;
	Sat, 17 Oct 2026 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260433; cv=none; b=dQFCBuEVCn2zrB1+uaOyeU6fmGp3czpWjo5CqyuJ8XtNtftCbgtM8CwSrVKDuAJCcWZieU+C2d7k5ZdYAsxMcJZFEBxuDuk9kW6YB8Gv2rYWLZEnR4hzAbHr+Rvvzi5bV24Lzc7WUiMTRgLjkAejKuOFjXrhl7aO8yRagS9vyVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260433; c=relaxed/simple;
	bh=F2yHIo62LLL9r1DbnICN7tDolTMdLI5DkwhKyaBvJNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaJIC/XJ4rP4SZTiSqq1sdrmWSbuyMf15xaeWjekEZp28Dk4krpvxXk/qalAPl5dfx4Id9RmolMRYgCmRgFcr+tvZ1ebhXAz9yjD3FUkGF4r1Zuu520zpYZ6sE9MWzMR0zay0fGtIbdDQZ9hfb9/vOuTtf9cawAXODMYKuNwmXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeYXz6PH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeYXz6PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56CA1F000C4;
	Sat, 17 Oct 2026 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260432;
	bh=Ug5P5+9zGEvpOQfz1G861k+k5I8S8AM0Y/XdlYEvoQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeYXz6PHOI9SGoHSWdzJQrRUT7tlmzlbqjz2plyjo3U1dMj4CFDPw18ScwL1q3I1z
	 +SlpwrvMfweS4kYwVLqkgVqPprZtZWS+TceYJIYLBZXCMJtr3DRFzHO0OxK2CNTmhD
	 MJjAGpxp8G7XXMmCVnSpmhjjuJEj6wLcJ7RKWwkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Koba Ko <kobak@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1502/1674] cxl/mbox: Clamp mailbox output allocation to the payload size
Date: Sat, 17 Oct 2026 18:02:54 +0200
Message-ID: <20261017160509.689690373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 8a13db9f899d149c3aab24abcb668121cfda5a4f ]

CXL_MEM_SEND_COMMAND bounds the user's in.size to the mailbox payload
size but leaves out.size unbounded, then cxl_mbox_cmd_ctor() calls
kvzalloc(out.size). A large out.size drives a huge allocation, above
INT_MAX it WARNs and taints, and with panic_on_warn=1 it panics.

The transport __cxl_pci_mbox_send_cmd() already clamps the response copy
to min(out.size, payload_size, device len), so the output buffer is
never written beyond payload_size. Clamp the allocation to payload_size
too, matching the RAW path.

Fixes: 583fa5e71cae ("cxl/mem: Add basic IOCTL interface")
Reviewed-by: Kai-Heng Feng <kaihengf@nvidia.com>
Reviewed-by: Koba Ko <kobak@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Link: https://patch.msgid.link/20260624144147.53997-1-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index d18d9188b577d..14e0354db65e8 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -364,11 +364,7 @@ static int cxl_mbox_cmd_ctor(struct cxl_mbox_cmd *mbox,
 		}
 	}
 
-	/* Prepare to handle a full payload for variable sized output */
-	if (out_size == CXL_VARIABLE_PAYLOAD)
-		mbox->size_out = mds->payload_size;
-	else
-		mbox->size_out = out_size;
+	mbox->size_out = min_t(size_t, out_size, mds->payload_size);
 
 	if (mbox->size_out) {
 		mbox->payload_out = kvzalloc(mbox->size_out, GFP_KERNEL);
-- 
2.53.0



