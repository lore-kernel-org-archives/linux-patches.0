Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0F23F4DD2;
	Fri,  4 Sep 2026 06:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502401; cv=none; b=rgd+ja97K8YjUkzeqEeBX/N0FAdgz2dOURTnONDDOkLmHyX01dyocnWsvbyF7X6IvK+UWN2kxvfzC7Mrj90I1Sh/X75ojis+lNXVfrgT8xwjOiU/+EV4LD2LJu+cqJgm9NC2VvyDMFhcNWOge5ZB2DeSNomu+BqJgNICUd7q5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502401; c=relaxed/simple;
	bh=+NH8isAv/BaJoAJDVzaJPcppxymqAPGZ/nTuCCWynzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS+Bry/ouNhwvBoeg9VSa9v3whGZo2lTqTKLNnq8KMYtFPPI41T2cu8mqSnwwSCvAOkIwJ7l6orOB2hLTxmqt8TkC0vMfOxrqfkE4LYEvX2CyozAjetgXTNVIPnBfWRHNKlxwITC493bQFNfQC/PIK2tr193SFJgAh+/OM9XCIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBpERjHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBpERjHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C5E1F00A3E;
	Fri,  4 Sep 2026 06:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502399;
	bh=ycIPs1asq7vZixaII7VS1WGFY6YAAf7cxXHnGkreBz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBpERjHMI/WrqtcurvnN+nWrBBNUXr6Yrm1gOmmp/ZHv1k5rEwCKKvFO+kvQ85WHW
	 T0nbyzCnguIX1/8UXZienFOSWkw3N0nDOwl3boozf+L4lA7H/V3Qkl+QqfxEg+1t3l
	 YJfdv5UljRl5wEdDFG+4d/keVlSld0vMvFiIIdFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Mykola Marzhan <mykola@meshstor.io>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Yu Kuai <yukuai@fygo.io>
Subject: [PATCH 6.12 195/403] md/raid10: fix still_degraded being inverted in raid10_sync_request()
Date: Fri,  4 Sep 2026 06:59:58 +0200
Message-ID: <20260904045739.289459244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -3398,7 +3398,7 @@ static sector_t raid10_sync_request(stru
 				struct md_rdev *rdev = conf->mirrors[j].rdev;
 
 				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
-					still_degraded = false;
+					still_degraded = true;
 					break;
 				}
 			}


