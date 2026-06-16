Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E5132B138;
	Tue, 16 Jun 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628485; cv=none; b=erNT5CVo6Sa6XTpvkonlBIo9123P2vEXSdX0MoaTssZ/ujvBsrPACDcn/IpBrZGrmCmTzISTTXmwEBeMOhBG+sZEKNHeQhZ9rkV6TXeUoVrKGSzYOvtHIR/dD5hVA/s8EQj58Zzme2pQ++4tGrTSdO2bJcqSapik1pljJn6modg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628485; c=relaxed/simple;
	bh=DjbJM50BFplQxj0walVx0WuXTTjNz4YpNbewKSYZGL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUVPc+wOH9CqoY3dGGKCDZPMvv4qM4tlwoaWjuC2GpUZkBPN9fsrMWFqZX1zV1wFDUPU4Pptnaoe++rVSUDmISRdL8RBM0cTOy0FezeI9mCBB2v/Dk9HNHNOWf5Tdyks7VmShPo0C9ehR8r/8ica0+J+OqltXEyJ3nngwOknu+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adUEKCjD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adUEKCjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4291F000E9;
	Tue, 16 Jun 2026 16:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628484;
	bh=TQFjMQSaD7y+9b5YxIDHsjv1N5pGDp18cwIvnMqzacQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adUEKCjDGp5HnNvKW3lmiKjMkd4fY30WF1YODmubxpx2LdyIZ/yr2AlsnAQefu5Dc
	 RDhPONRl4hhOrrRwze2VqWl3tYj1dzjwoPPNI4jEfwdr1vUOuub58/+NGOMIWbjVFM
	 Lewznghnwr/T2CRH8as+OpJd9etS+clDc5F4fEj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Alexander Graf <graf@amazon.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Borislav Betkov <bp@alien8.de>,
	guoweikang <guoweikang.kernel@gmail.com>,
	Henry Willard <henry.willard@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Bohac <jbohac@suse.cz>,
	Joel Granados <joel.granados@kernel.org>,
	Jonathan McDowell <noodles@fb.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Webb <paul.x.webb@oracle.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Yifei Liu <yifei.l.liu@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/452] of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
Date: Tue, 16 Jun 2026 20:25:04 +0530
Message-ID: <20260616145121.942187679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 4d02233235ed0450de9c10fcdcf3484e3c9401ce ]

Refactor the OF/DT ima_get_kexec_buffer() to use a generic helper to
validate the address range.  No functional change intended.

Link: https://lkml.kernel.org/r/20251231061609.907170-3-harshit.m.mogalapalli@oracle.com
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@fb.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/kexec.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 3b98a57f1f0743..23fde2d032e6d9 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -128,7 +128,6 @@ int __init ima_get_kexec_buffer(void **addr, size_t *size)
 {
 	int ret, len;
 	unsigned long tmp_addr;
-	unsigned long start_pfn, end_pfn;
 	size_t tmp_size;
 	const void *prop;
 
@@ -144,17 +143,9 @@ int __init ima_get_kexec_buffer(void **addr, size_t *size)
 	if (!tmp_size)
 		return -ENOENT;
 
-	/*
-	 * Calculate the PFNs for the buffer and ensure
-	 * they are with in addressable memory.
-	 */
-	start_pfn = PHYS_PFN(tmp_addr);
-	end_pfn = PHYS_PFN(tmp_addr + tmp_size - 1);
-	if (!page_is_ram(start_pfn) || !page_is_ram(end_pfn)) {
-		pr_warn("IMA buffer at 0x%lx, size = 0x%zx beyond memory\n",
-			tmp_addr, tmp_size);
-		return -EINVAL;
-	}
+	ret = ima_validate_range(tmp_addr, tmp_size);
+	if (ret)
+		return ret;
 
 	*addr = __va(tmp_addr);
 	*size = tmp_size;
-- 
2.53.0



