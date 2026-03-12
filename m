Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CDE344DB5;
	Thu, 12 Mar 2026 20:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346782; cv=none; b=nLje02qi4lj+zbS9aWXEmFS3V804QpI+15fvsYa3wd8lGSQGDGCA0eKtVxN0MzkErri8GiyNh1hJju4CMXUQDJGW6ca3/dx/46eqdxdIY9D5bel83fIRGDnSjEn7gONlwZme+dX9sbYSiTEBfpnX79XYGelkJ+ZvZEa5UywwMdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346782; c=relaxed/simple;
	bh=yUqXkTCYCeg7rdyzWF8ECEEjFYCcODt6TWuIBjeESyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erCOklW2zk/fIyXDt67g3JqRoYkXC3ENYfxRi1iUIXWMKb+REKoTL8wGRTCnddyM1bd7ABEmCdVaWVR7SA4cBruNrU9OYvuyygs4yuCf9qes0oTPG4x7a/sc52V17ZoHYYutf9d1FCrWPVFwdWe7apoWUaYNNPlVVQjmW87dPA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlUGI1rp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlUGI1rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD42CC4CEF7;
	Thu, 12 Mar 2026 20:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346782;
	bh=yUqXkTCYCeg7rdyzWF8ECEEjFYCcODt6TWuIBjeESyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlUGI1rpJddC2JpD5vLtHX32urEzJ8cWuvFwJpQK7uQ+b8fkw44tf+FZ0FIXZN+MP
	 fX2l+D76jiJrjgjAVJ6hfm+0yPoXbp0RAfXozhi513x2DnCW05ErQtTDVCszbfIofl
	 vTe6bK9J6iCrD2YBBEEr/B2w/az96buuzoQKJzJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Baoquan He <bhe@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/265] ima: define and call ima_alloc_kexec_file_buf()
Date: Thu, 12 Mar 2026 21:07:57 +0100
Message-ID: <20260312201021.472989172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Steven Chen <chenste@linux.microsoft.com>

[ Upstream commit c95e1acb6d7f00efab73e41b31e0560751e3f469 ]

In the current implementation, the ima_dump_measurement_list() API is
called during the kexec "load" phase, where a buffer is allocated and
the measurement records are copied. Due to this, new events added after
kexec load but before kexec execute are not carried over to the new kernel
during kexec operation

Carrying the IMA measurement list across kexec requires allocating a
buffer and copying the measurement records.  Separate allocating the
buffer and copying the measurement records into separate functions in
order to allocate the buffer at kexec 'load' and copy the measurements
at kexec 'execute'.

After moving the vfree() here at this stage in the patch set, the IMA
measurement list fails to verify when doing two consecutive "kexec -s -l"
with/without a "kexec -s -u" in between.  Only after "ima: kexec: move
IMA log copy from kexec load to execute" the IMA measurement list verifies
properly with the vfree() here.

Co-developed-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Signed-off-by: Steven Chen <chenste@linux.microsoft.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com> # ppc64/kvm
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Stable-dep-of: 10d1c75ed438 ("ima: verify the previous kernel's IMA buffer lies in addressable RAM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_kexec.c | 46 +++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 650beb74346c5..b12ac3619b8fd 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -15,26 +15,46 @@
 #include "ima.h"
 
 #ifdef CONFIG_IMA_KEXEC
+static struct seq_file ima_kexec_file;
+
+static void ima_free_kexec_file_buf(struct seq_file *sf)
+{
+	vfree(sf->buf);
+	sf->buf = NULL;
+	sf->size = 0;
+	sf->read_pos = 0;
+	sf->count = 0;
+}
+
+static int ima_alloc_kexec_file_buf(size_t segment_size)
+{
+	ima_free_kexec_file_buf(&ima_kexec_file);
+
+	/* segment size can't change between kexec load and execute */
+	ima_kexec_file.buf = vmalloc(segment_size);
+	if (!ima_kexec_file.buf)
+		return -ENOMEM;
+
+	ima_kexec_file.size = segment_size;
+	ima_kexec_file.read_pos = 0;
+	ima_kexec_file.count = sizeof(struct ima_kexec_hdr);	/* reserved space */
+
+	return 0;
+}
+
 static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 				     unsigned long segment_size)
 {
-	struct seq_file ima_kexec_file;
 	struct ima_queue_entry *qe;
 	struct ima_kexec_hdr khdr;
 	int ret = 0;
 
 	/* segment size can't change between kexec load and execute */
-	ima_kexec_file.buf = vmalloc(segment_size);
 	if (!ima_kexec_file.buf) {
-		ret = -ENOMEM;
-		goto out;
+		pr_err("Kexec file buf not allocated\n");
+		return -EINVAL;
 	}
 
-	ima_kexec_file.file = NULL;
-	ima_kexec_file.size = segment_size;
-	ima_kexec_file.read_pos = 0;
-	ima_kexec_file.count = sizeof(khdr);	/* reserved space */
-
 	memset(&khdr, 0, sizeof(khdr));
 	khdr.version = 1;
 	/* This is an append-only list, no need to hold the RCU read lock */
@@ -71,8 +91,6 @@ static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 	*buffer_size = ima_kexec_file.count;
 	*buffer = ima_kexec_file.buf;
 out:
-	if (ret == -EINVAL)
-		vfree(ima_kexec_file.buf);
 	return ret;
 }
 
@@ -111,6 +129,12 @@ void ima_add_kexec_buffer(struct kimage *image)
 		return;
 	}
 
+	ret = ima_alloc_kexec_file_buf(kexec_segment_size);
+	if (ret < 0) {
+		pr_err("Not enough memory for the kexec measurement buffer.\n");
+		return;
+	}
+
 	ima_dump_measurement_list(&kexec_buffer_size, &kexec_buffer,
 				  kexec_segment_size);
 	if (!kexec_buffer) {
-- 
2.51.0



