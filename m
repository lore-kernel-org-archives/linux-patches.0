Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F91F37B00F;
	Thu, 20 Aug 2026 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239497; cv=none; b=Q3RmHPZM5ObNdXFmyM0kVOdZDYRzYVHbe6K+TuQrfzFbMdHzqn4/ygphwoFV/2X2IEp/J6njrd0GLQ0msQzFGjyjP+ewFEVyPzj/ks+1hmAmlmZPWwb0kWvfXJU0/0jQhgL3VKvjqn5dv/Ayug/Y+f9pMuxjHup+7lHhsHvZAMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239497; c=relaxed/simple;
	bh=JLS5FK9IwCKk7oV09qAMCFebwlg9AewA+GoPgP2lckc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0qMGoSOfTllrsjE+HJ7IARcjv2XsT1b5xxdH35H1F7vEQpqmVFcO2ZpTOI2ag8pxKkC0jtWzkjUlRexAFy4npAlp2w7/Td8/Hs8CQYKpKMJwuFHBv1/iwnM/ZZl8DXrPOEL+Xy7ZKV1AVAgY3FUDtGxOQzcMdeNGfWL+5QIXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EG42m55M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EG42m55M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2ADD1F000E9;
	Thu, 20 Aug 2026 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239496;
	bh=eC8ztH8B22srsoLQxe6myxwqzClpCL/QzK7wQcIqJsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EG42m55Mc5YGb3lmWu7mtAph6SCacpuWaE28/DnozqKfyt+D/M+0FT16ZmWUSxzuJ
	 lzdJ5bF+pVm/NWDCdU9Gl3Suh3kqX3GKmpddf7FjsLPptFPy06OxBrEeT5ybFQ96EC
	 E4PApqcyuFI2A4hPa27+FVBCZp6vF1EEb+uZk34U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 070/220] s390/vfio_ccw: Free all memory if cp_init() fails
Date: Thu, 20 Aug 2026 16:54:20 +0200
Message-ID: <20260820145225.594214437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit 74186c2968f8f756ac3226b545b598457c910c75 upstream.

The routine cp_free() is called to unpin/free any memory once an I/O
is completed successfully, or if cp_prefetch() fails. But if cp_init()
fails, and cp->initialized is not enabled, the same routine cannot be
used to free all the memory.

An attempt to address this exists in ccwchain_handle_ccw(), where a
single call to ccwchain_free() is made for the currently-processed
CCW segment. But this will leak other segments (created as a result
of a Transfer in Channel) that had been allocated as part of the same
channel program.

Address this by performing the cleanup outside of the recursive
ccwchain_handle_ccw()/ccwchain_loop_tic() logic.

Fixes: 8b515be512a2 ("vfio-ccw: Fix memory leak and don't call cp_free in cp_init")
Cc: stable@vger.kernel.org
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_cp.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -455,9 +455,6 @@ static int ccwchain_handle_ccw(dma32_t c
 	/* Loop for tics on this new chain. */
 	ret = ccwchain_loop_tic(chain, cp);
 
-	if (ret)
-		ccwchain_free(chain);
-
 	return ret;
 }
 
@@ -486,6 +483,23 @@ static int ccwchain_loop_tic(struct ccwc
 	return 0;
 }
 
+static int ccwchain_build_ccws(dma32_t cda, struct channel_program *cp)
+{
+	struct ccwchain *chain, *temp;
+	int ret;
+
+	ret = ccwchain_handle_ccw(cda, cp);
+
+	if (ret) {
+		/* Cleanup if an error occurred */
+		list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
+			ccwchain_free(chain);
+		}
+	}
+
+	return ret;
+}
+
 static int ccwchain_fetch_tic(struct ccw1 *ccw,
 			      struct channel_program *cp)
 {
@@ -735,7 +749,7 @@ int cp_init(struct channel_program *cp,
 	memcpy(&cp->orb, orb, sizeof(*orb));
 
 	/* Build a ccwchain for the first CCW segment */
-	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
+	ret = ccwchain_build_ccws(orb->cmd.cpa, cp);
 
 	if (!ret)
 		cp->initialized = true;


