Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AEF35C1A6;
	Thu, 20 Aug 2026 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238918; cv=none; b=DwHY5crgkgm9xvb8TAzcAE0ov0ipem8DAr4xJQ3it2rYGmG1YNIaSgS7BnH00UntXOaSYpcgTKNHTLRmrzTANsu7Zt28J7OD8GChJYKgPZx6Q9JsrytDrMqJMVryxDedvfuwK2tIFQvoLF3JnNz2AwdHttb6r1AvwDubFSPaa3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238918; c=relaxed/simple;
	bh=+GUb6DamdP5LCPWDrbiZUg4I+SJd0QJMcvhDsCPuGJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TChuJfd3bX7kASpZYaVtvnP9yVkUkauBCKdbbqmRqeYXYG+/Y4or5CmYKALGL74Zh79hSkHHCSdmVbHPzvWYPiVDmz9xlMIWYzLmjh8W1qhk9saLSueWpU+0SChS7zQTmEz9uvL0d5K4IsToNyS8QawfdmlOXZnhzkU7cXeZkZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oD1siLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oD1siLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D8E1F000E9;
	Thu, 20 Aug 2026 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238917;
	bh=ypBeMWcep4QYd1FhOa31EuGq3UQ1XECExGls1if6hI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2oD1siLdIFBUNnGJEnwkAcUlPAedQ2j1alJUX0akaeI14mQCRZAec4EXiV+CivkN6
	 kXTmTjkdnLqDA3GKbiao3igg7sQtUBV9BhG9KKfTkneQ5rkshMvrUjxrdV9dTZffbD
	 hNypbhTKRZFGM7HLfXKmJ6QSC53ldRZZCmjY0/uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 087/217] s390/vfio_ccw: Calculate idal length based on idaw type
Date: Thu, 20 Aug 2026 16:54:15 +0200
Message-ID: <20260820145240.251723969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit 4f6fdc6e1a7fbfa36b945af33c65a417948feac0 upstream.

Sashiko pointed out that get_guest_idal() unconditionally calculates
the length of the IDAL presuming everything is a Format-2 IDAW.

The output of vfio-ccw is always Format-2, but the input can be either
Format-1 (31-bit addresses) or Format-2 (64-bit addresses). As a result,
the size of the guest IDAL may be incorrect and should be trimmed down.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260720203400.7328E1F000E9@smtp.kernel.org/
Fixes: 1b676fe3d9d3 ("vfio/ccw: handle a guest Format-1 IDAL")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_cp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -233,6 +233,7 @@ static void convert_ccw0_to_ccw1(struct
 }
 
 #define idal_is_2k(_cp) (!(_cp)->orb.cmd.c64 || (_cp)->orb.cmd.i2k)
+#define get_idaw_size(_cp) ((_cp)->orb.cmd.c64 ? sizeof(u64) : sizeof(u32))
 
 /*
  * Helpers to operate ccwchain.
@@ -524,7 +525,7 @@ static dma64_t *get_guest_idal(struct cc
 	dma64_t *idaws;
 	dma32_t *idaws_f1;
 	u64 first_idaw;
-	int idal_len = idaw_nr * sizeof(*idaws);
+	int idal_len = idaw_nr * get_idaw_size(cp);
 	int idaw_size = idal_is_2k(cp) ? PAGE_SIZE / 2 : PAGE_SIZE;
 	int idaw_mask = ~(idaw_size - 1);
 	int i, ret;
@@ -593,7 +594,7 @@ static int ccw_count_idaws(struct ccw1 *
 	struct vfio_device *vdev =
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	u64 iova;
-	int size = cp->orb.cmd.c64 ? sizeof(u64) : sizeof(u32);
+	int size = get_idaw_size(cp);
 	int ret;
 	int bytes = 1;
 


