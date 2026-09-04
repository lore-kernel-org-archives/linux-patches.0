Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B67C41A4F8;
	Fri,  4 Sep 2026 05:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499402; cv=none; b=JaRmhn/QXh2MHFBFAdwIBMEieBVPMx6N0B1le2R/6tlxm3b3YlCuhMzQuwMcXCE5uOMHBLnopjhf/5XrQ10K1Jn+54NHvZOWK9j4jtOOEMySVQy3RnMLByI+ODklNQyeZjESMWxcE2/TZILxbNCo+zvM0eD1xemBQNP147jcEkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499402; c=relaxed/simple;
	bh=zbC8S7v+ykk8KPrgFOQANsTiAVMdg8bDN6ooJ86mKvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQb38fByWVlPdwDOT0T6JcWHp5ylTgRcvkyG8UuXH0QSuh2L542FYrc4KYQyC8UpBln7vTBZ6qVxKsTYcTFUjD9rYK9kAta8VmR+C8wcf5c052CS35953Fz1yULwu7hTBzbQFNaJTi3IFCScF6kU7x+1hYvCUncpjrcLBo88ZMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c97KpS7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c97KpS7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B28C1F00A3D;
	Fri,  4 Sep 2026 05:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499400;
	bh=tRn6t4xTN/6VotiJ/BeWAqoM1SYCc5GCY0ntFXLdQJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c97KpS7NtnwU5ncbvGdD6MizL1lkTC1N0VNL/sS1laHJ8+uicX0VAO1r57hUNn74N
	 kpWS90IfoTG/s02cgsC9HdyXWR6Tf8EBzhH1K0dEamLJfUxhJULw3QEbU3gfz+lbNT
	 NCWzhQVzlaXOkw4MUd0w64vKJ18S9+bXGVRKP6/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Mykola Marzhan <mykola@meshstor.io>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Yu Kuai <yukuai@fygo.io>
Subject: [PATCH 7.2 361/713] md/raid10: fix still_degraded being inverted in raid10_sync_request()
Date: Fri,  4 Sep 2026 06:55:29 +0200
Message-ID: <20260904045811.921791997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunye Zhao <yunye.zhao@linux.alibaba.com>

commit 47f1441b281decde6954a2fa82b4131637d685ac upstream.

Commit fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into
bitmap_operations") converted still_degraded from int to bool, but
inverted the assignment in the loop that checks whether the array will
still be degraded after the current device is recovered:
"still_degraded = 1" became "still_degraded = false".

As a result, recovering a device while another mirror is still missing
calls md_bitmap_start_sync() with degraded == false, which clears bitmap
bits that the still-missing device needs.  When that device is re-added,
its bitmap-based recovery finds the bits already cleared and skips every
region written while the array was degraded, so it is marked In_sync
while holding stale data: silent corruption.

Reproducer (raid10 near=2, 4 disks, internal bitmap):
 - fail and remove one disk of each mirror pair
 - write to the degraded array
 - re-add both disks and let recovery finish
 - "check" reports mismatch_cnt=262272 after 256 MiB of degraded
   writes and file contents differ; the second disk's "recovery"
   completes in milliseconds because everything is skipped

The same conversion in raid1 got it right (still_degraded = true).
Restore the correct value.

Fixes: fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations")
Cc: stable@vger.kernel.org
Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
Reviewed-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260723135535.101995-2-yunye.zhao@linux.alibaba.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3365,7 +3365,7 @@ static sector_t raid10_sync_request(stru
 				struct md_rdev *rdev = conf->mirrors[j].rdev;
 
 				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
-					still_degraded = false;
+					still_degraded = true;
 					break;
 				}
 			}


