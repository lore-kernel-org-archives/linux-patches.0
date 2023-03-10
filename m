Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F008825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B11C433D2;
	Fri, 10 Mar 2023 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460431;
	bh=ZONAirZ6zfNf1iTb0FxKJx91w3mgVP51sUbKEawi4b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6HYUSMNK4TnPOiezDPMJ9A5OgvQXwjqo0qy0tWH2W9Uq9KRPqtT4Psyg+nyhqNTu
	 WHiVMZFFfHB5YqWSKby4G4UNmCA7KhtRkOpp2OOOucYMzzWUG7dCUPXDcTu12kg3Y6
	 G90HTcXFH66BVQ6iLoYDgKpT3e3NdnKmHlxv5LPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 332/529] s390/extmem: return correct segment type in __segment_load()
Date: Fri, 10 Mar 2023 14:37:55 +0100
Message-Id: <20230310133820.405245245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 8c42dd78df148c90e48efff204cce38743906a79 upstream.

Commit f05f62d04271f ("s390/vmem: get rid of memory segment list")
reshuffled the call to vmem_add_mapping() in __segment_load(), which now
overwrites rc after it was set to contain the segment type code.

As result, __segment_load() will now always return 0 on success, which
corresponds to the segment type code SEG_TYPE_SW, i.e. a writeable
segment. This results in a kernel crash when loading a read-only segment
as dcssblk block device, and trying to write to it.

Instead of reshuffling code again, make sure to return the segment type
on success, and also describe this rather delicate and unexpected logic
in the function comment. Also initialize new segtype variable with
invalid value, to prevent possible future confusion.

Fixes: f05f62d04271 ("s390/vmem: get rid of memory segment list")
Cc: <stable@vger.kernel.org> # 5.9+
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/extmem.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/arch/s390/mm/extmem.c
+++ b/arch/s390/mm/extmem.c
@@ -289,15 +289,17 @@ segment_overlaps_others (struct dcss_seg
 
 /*
  * real segment loading function, called from segment_load
+ * Must return either an error code < 0, or the segment type code >= 0
  */
 static int
 __segment_load (char *name, int do_nonshared, unsigned long *addr, unsigned long *end)
 {
 	unsigned long start_addr, end_addr, dummy;
 	struct dcss_segment *seg;
-	int rc, diag_cc;
+	int rc, diag_cc, segtype;
 
 	start_addr = end_addr = 0;
+	segtype = -1;
 	seg = kmalloc(sizeof(*seg), GFP_KERNEL | GFP_DMA);
 	if (seg == NULL) {
 		rc = -ENOMEM;
@@ -326,9 +328,9 @@ __segment_load (char *name, int do_nonsh
 	seg->res_name[8] = '\0';
 	strlcat(seg->res_name, " (DCSS)", sizeof(seg->res_name));
 	seg->res->name = seg->res_name;
-	rc = seg->vm_segtype;
-	if (rc == SEG_TYPE_SC ||
-	    ((rc == SEG_TYPE_SR || rc == SEG_TYPE_ER) && !do_nonshared))
+	segtype = seg->vm_segtype;
+	if (segtype == SEG_TYPE_SC ||
+	    ((segtype == SEG_TYPE_SR || segtype == SEG_TYPE_ER) && !do_nonshared))
 		seg->res->flags |= IORESOURCE_READONLY;
 
 	/* Check for overlapping resources before adding the mapping. */
@@ -386,7 +388,7 @@ __segment_load (char *name, int do_nonsh
  out_free:
 	kfree(seg);
  out:
-	return rc;
+	return rc < 0 ? rc : segtype;
 }
 
 /*


