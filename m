Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF6644DB64;
	Tue, 16 Jun 2026 16:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626935; cv=none; b=qK71KCk2aIyM68eKAK8KC9aiisFVT54ODjXdl6P5V3zgLETJGa6wr7gJ1ZbJRV/15QVS/pgd7MamG7qfDGiyU+jHXnh2iFLEDj1gBkx2hJhKqWAM8QYyZJdnhKBSmVXnJIdlZRaMiKiGeCNNH6cQVi9W2/K6RWjMpB5l5LuX0Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626935; c=relaxed/simple;
	bh=xx6qDe/VB9l1S3tNPRSTyhVNV12vX2D37hZd23/g1ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuUTKKiP/aZ3iBL98bBrIEyzjZ5G1CtVNiFnQuN9nesWgw22pkOy2tc4704JjIiOqxeWysudxr8XS6sQ8tHl/N+BB2GOA/V30de9Vox4ufDhulAeG3AY12qjUYXBDZKdlV64FBvGOLg3lkApszNpD2KZEQ/Jyug3C1M1m0wFo/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/Rdz9Lk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/Rdz9Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FA21F000E9;
	Tue, 16 Jun 2026 16:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626933;
	bh=m+dasrTt4CBtxO8sJrgZCXkB7+Mylh/AMunNer9bJCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/Rdz9LktdxE6IdBr0W7Uj1+VGaErdn973vFoADqn65ERix9QptPjIIV3R6Y5Jhwx
	 RL504bXi8I18IyqBjYXRRhb7VcTSJSTkIr1P0Uc7o+tiWNH/QNdy2bRbER0gR4kCgA
	 qmd6wuFsz/e2i/f2O6ZQ5pYQHcj2WFbE2HV/scKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biederman <ebiederm@xmission.com>,
	Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/261] ima: kexec: skip IMA segment validation after kexec soft reboot
Date: Tue, 16 Jun 2026 20:28:23 +0530
Message-ID: <20260616145048.143305911@linuxfoundation.org>
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

[ Upstream commit 9ee8888a80fe2bd20ce929ffbc1dedd57607a778 ]

Currently, the function kexec_calculate_store_digests() calculates and
stores the digest of the segment during the kexec_file_load syscall,
where the  IMA segment is also allocated.

Later, the IMA segment will be updated with the measurement log at the
kexec execute stage when a kexec reboot is initiated. Therefore, the
digests should be updated for the IMA segment in the  normal case. The
problem is that the content of memory segments carried over to the new
kernel during the kexec systemcall can be changed at kexec 'execute'
stage, but the size and the location of the memory segments cannot be
changed at kexec 'execute' stage.

To address this, skip the calculation and storage of the digest for the
IMA segment in kexec_calculate_store_digests() so that it is not added
to the purgatory_sha_regions.

With this change, the IMA segment is not included in the digest
calculation, storage, and verification.

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Co-developed-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Signed-off-by: Steven Chen <chenste@linux.microsoft.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com> # ppc64/kvm
[zohar@linux.ibm.com: Fixed Signed-off-by tag to match author's email ]
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
(cherry picked from commit 9ee8888a80fe2bd20ce929ffbc1dedd57607a778)
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kexec.h              |  3 +++
 kernel/kexec_file.c                | 22 ++++++++++++++++++++++
 security/integrity/ima/ima_kexec.c |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 7d6b12f8b8d058..107e726f2ef3f1 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -362,6 +362,9 @@ struct kimage {
 
 	phys_addr_t ima_buffer_addr;
 	size_t ima_buffer_size;
+
+	unsigned long ima_segment_index;
+	bool is_ima_segment_index_set;
 #endif
 
 	/* Core ELF header buffer */
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f852528bdc246a..a20ceb4d27ccce 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -38,6 +38,21 @@ void set_kexec_sig_enforced(void)
 }
 #endif
 
+#ifdef CONFIG_IMA_KEXEC
+static bool check_ima_segment_index(struct kimage *image, int i)
+{
+	if (image->is_ima_segment_index_set && i == image->ima_segment_index)
+		return true;
+	else
+		return false;
+}
+#else
+static bool check_ima_segment_index(struct kimage *image, int i)
+{
+	return false;
+}
+#endif
+
 static int kexec_calculate_store_digests(struct kimage *image);
 
 /* Maximum size in bytes for kernel/initrd files. */
@@ -764,6 +779,13 @@ static int kexec_calculate_store_digests(struct kimage *image)
 		if (ksegment->kbuf == pi->purgatory_buf)
 			continue;
 
+		/*
+		 * Skip the segment if ima_segment_index is set and matches
+		 * the current index
+		 */
+		if (check_ima_segment_index(image, i))
+			continue;
+
 		ret = crypto_shash_update(desc, ksegment->kbuf,
 					  ksegment->bufsz);
 		if (ret)
diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 501b952b36981f..4de9834c3e1335 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -164,6 +164,7 @@ void ima_add_kexec_buffer(struct kimage *image)
 	kbuf.buffer = kexec_buffer;
 	kbuf.bufsz = kexec_buffer_size;
 	kbuf.memsz = kexec_segment_size;
+	image->is_ima_segment_index_set = false;
 	ret = kexec_add_buffer(&kbuf);
 	if (ret) {
 		pr_err("Error passing over kexec measurement buffer.\n");
@@ -174,6 +175,8 @@ void ima_add_kexec_buffer(struct kimage *image)
 	image->ima_buffer_addr = kbuf.mem;
 	image->ima_buffer_size = kexec_segment_size;
 	image->ima_buffer = kexec_buffer;
+	image->ima_segment_index = image->nr_segments - 1;
+	image->is_ima_segment_index_set = true;
 
 	kexec_dprintk("kexec measurement buffer for the loaded kernel at 0x%lx.\n",
 		      kbuf.mem);
-- 
2.53.0



