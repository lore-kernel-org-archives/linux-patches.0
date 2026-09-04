Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914063242BD;
	Fri,  4 Sep 2026 05:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501032; cv=none; b=tOgrtSVatKPqLCrjxgBVYeUydp4szmgzc/iCahf8+41Ztam8G7cPtAQSHPRrMv3N4HOQs/tC2iO6olkQt33Fyf70o7W3KjhjkX7v/N1GLlaji3fiBNR4w/f7L+g+XhPboTUvZjiHBiUVWVgMzcf7xWYr3xL8jJVquZv8hbEtPQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501032; c=relaxed/simple;
	bh=UVLIf5GwRRFctBODoJMGMVM9w1oVTky2MMeCZBfyflI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxuK67hiQf68I9YxqvoE08Dp41aFi8/F+r2YVz7lDowK5dUTsrflw6CmMSkA3D+FHTP+tPWd+wVuYIXeNIbfT78BTeIre3VAQgEoS+TpmigJoTZTkXZRgiLmC6Y69/rzfOd1gK/cOw9YlAYpPqbSb9iPkF5dDxxpO1Raa4NDcY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3RnnkgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3RnnkgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB51F00A3D;
	Fri,  4 Sep 2026 05:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501031;
	bh=B891ENmIbl2QwsaH06gG1p5ZOrh81CYGcvwl4j0YH1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3RnnkgO7uibeXb4NIVd59GohBxUrKf4kfLMKxaYAIoLaLTa4ovio83a0UzPsmlC2
	 VYJm/KOqfy7cgn3dC+dVt4NDeP9+gPBm4lO6qJAJCJWLF67Koz/ZnUDg/PVUERno34
	 dvH1luOogi93ngg+t510aAUeK6EBDrAzdjZuNC6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Mykola Marzhan <mykola@meshstor.io>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Yu Kuai <yukuai@fygo.io>
Subject: [PATCH 6.18 267/552] md/raid10: fix still_degraded being inverted in raid10_sync_request()
Date: Fri,  4 Sep 2026 06:57:04 +0200
Message-ID: <20260904045756.009592466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -3384,7 +3384,7 @@ static sector_t raid10_sync_request(stru
 				struct md_rdev *rdev = conf->mirrors[j].rdev;
 
 				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
-					still_degraded = false;
+					still_degraded = true;
 					break;
 				}
 			}


