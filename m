Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAE643E4BA;
	Tue, 16 Jun 2026 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626942; cv=none; b=h1w7MmjeaBTwPIDZbi4tg7EOsok95KvSbYi0hPBInehed++vpD22x9sd3xlnXHHQrYKuYBzZI1sJydGgVwOGDsKVEi0jdypXUj1NPGxFRi3R6fzLjUm07lvCW1/NKrztNoPubZSa3VoKcCHxUwaw97+zBN2dIjQLSS8yZ3690/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626942; c=relaxed/simple;
	bh=FbkUfGVEWK1pAgct9+oOE1R9E8JlThVHmr03114SAQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cg7dyubSg1t9bCtX41qCYIN4w4JGz0l6Lklc14MH8lb/wUnZJi2bS4EeUvupmMYovVRAjWd0kQPSTf8INXIz8MXQN4LZmeumQMeNIiBgMDBzdelSoyvXk+5ot+LAlMeKv5vLzvDqDfThoBG3sIQ+55GcKSd3aAuM/OngsJchwmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r71X9rhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r71X9rhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDA71F000E9;
	Tue, 16 Jun 2026 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626940;
	bh=D3ctNp57qeoCFvrkNJfcDI5g1mNj4cVUayOJl3JdsI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r71X9rhPH83F3oiEX7PBa3/fXR5xH+4X0vu7ATyX+I35RNrjzcLdxUafEX0UWGBaj
	 A71ym1FUlPf7BV5s69YQrXVymNQ8SXYyWw/MxoixjLC+/x/Alr7p3wAMPWf4Tkd7dM
	 rjAiNo7CAblv1EZPB381IKcpzqcToxja1vN/0K84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Stefan Berger <stefanb@linux.ibm.com>
Subject: [PATCH 6.12 066/261] ima: kexec: move IMA log copy from kexec load to execute
Date: Tue, 16 Jun 2026 20:28:24 +0530
Message-ID: <20260616145048.190592578@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

[ Upstream commit 9f0ec4b16f2b41d663f688a8012e9e52b2657eba ]

The IMA log is currently copied to the new kernel during kexec 'load' using
ima_dump_measurement_list(). However, the IMA measurement list copied at
kexec 'load' may result in loss of IMA measurements records that only
occurred after the kexec 'load'. Move the IMA measurement list log copy
from kexec 'load' to 'execute'

Make the kexec_segment_size variable a local static variable within the
file, so it can be accessed during both kexec 'load' and 'execute'.

Define kexec_post_load() as a wrapper for calling ima_kexec_post_load() and
machine_kexec_post_load().  Replace the existing direct call to
machine_kexec_post_load() with kexec_post_load().

When there is insufficient memory to copy all the measurement logs, copy as
much of the measurement list as possible.

Co-developed-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Steven Chen <chenste@linux.microsoft.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com> # ppc64/kvm
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
(cherry picked from commit 9f0ec4b16f2b41d663f688a8012e9e52b2657eba)
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_file.c                | 11 +++++++-
 security/integrity/ima/ima_kexec.c | 43 ++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index a20ceb4d27ccce..909432e804be16 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -201,6 +201,15 @@ kimage_validate_signature(struct kimage *image)
 }
 #endif
 
+static int kexec_post_load(struct kimage *image, unsigned long flags)
+{
+#ifdef CONFIG_IMA_KEXEC
+	if (!(flags & KEXEC_FILE_ON_CRASH))
+		ima_kexec_post_load(image);
+#endif
+	return machine_kexec_post_load(image);
+}
+
 /*
  * In file mode list of segments is prepared by kernel. Copy relevant
  * data from user space, do error checking, prepare segment list
@@ -428,7 +437,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 
 	kimage_terminate(image);
 
-	ret = machine_kexec_post_load(image);
+	ret = kexec_post_load(image, flags);
 	if (ret)
 		goto out;
 
diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 4de9834c3e1335..48fe9a7e1f456e 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -21,6 +21,7 @@
 #ifdef CONFIG_IMA_KEXEC
 static bool ima_kexec_update_registered;
 static struct seq_file ima_kexec_file;
+static size_t kexec_segment_size;
 static void *ima_kexec_buffer;
 
 static void ima_free_kexec_file_buf(struct seq_file *sf)
@@ -84,9 +85,6 @@ static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 		}
 	}
 
-	if (ret < 0)
-		goto out;
-
 	/*
 	 * fill in reserved space with some buffer details
 	 * (eg. version, buffer size, number of measurements)
@@ -106,7 +104,7 @@ static int ima_dump_measurement_list(unsigned long *buffer_size, void **buffer,
 
 	*buffer_size = ima_kexec_file.count;
 	*buffer = ima_kexec_file.buf;
-out:
+
 	return ret;
 }
 
@@ -124,9 +122,8 @@ void ima_add_kexec_buffer(struct kimage *image)
 	unsigned long binary_runtime_size;
 
 	/* use more understandable variable names than defined in kbuf */
+	size_t kexec_buffer_size = 0;
 	void *kexec_buffer = NULL;
-	size_t kexec_buffer_size;
-	size_t kexec_segment_size;
 	int ret;
 
 	if (image->type == KEXEC_TYPE_CRASH)
@@ -154,13 +151,6 @@ void ima_add_kexec_buffer(struct kimage *image)
 		return;
 	}
 
-	ima_dump_measurement_list(&kexec_buffer_size, &kexec_buffer,
-				  kexec_segment_size);
-	if (!kexec_buffer) {
-		pr_err("Not enough memory for the kexec measurement buffer.\n");
-		return;
-	}
-
 	kbuf.buffer = kexec_buffer;
 	kbuf.bufsz = kexec_buffer_size;
 	kbuf.memsz = kexec_segment_size;
@@ -188,7 +178,32 @@ void ima_add_kexec_buffer(struct kimage *image)
 static int ima_update_kexec_buffer(struct notifier_block *self,
 				   unsigned long action, void *data)
 {
-	return NOTIFY_OK;
+	size_t buf_size = 0;
+	int ret = NOTIFY_OK;
+	void *buf = NULL;
+
+	if (!kexec_in_progress) {
+		pr_info("No kexec in progress.\n");
+		return ret;
+	}
+
+	if (!ima_kexec_buffer) {
+		pr_err("Kexec buffer not set.\n");
+		return ret;
+	}
+
+	ret = ima_dump_measurement_list(&buf_size, &buf, kexec_segment_size);
+
+	if (ret)
+		pr_err("Dump measurements failed. Error:%d\n", ret);
+
+	if (buf_size != 0)
+		memcpy(ima_kexec_buffer, buf, buf_size);
+
+	kimage_unmap_segment(ima_kexec_buffer);
+	ima_kexec_buffer = NULL;
+
+	return ret;
 }
 
 static struct notifier_block update_buffer_nb = {
-- 
2.53.0



