Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A111EF363;
	Wed, 17 Sep 2025 12:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112752; cv=none; b=Je6GTt8Enxzb/eDkpn1/Tqli1IPKWOC9Duaa2jZj5ilyrBwDhB19xSQyuj9T6zg+V8L758hy46tCuS2xpHOXvGQansJ0IRF8tkto+C2PALQ7BrdhGoSlmNYjQWMG12XRroLLI+O/APL2Xaa5pYpVMNUihdk/irGYCq6ZvsZtuN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112752; c=relaxed/simple;
	bh=5ffDmHzrIJgyLCAJvSWYYu/B/CWBzh+yF8+lu6roYcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gg/Dv5zsMk8sRpyg9kreJdtHQesIopSoubXjhfX8wnKWEqQou9pTsMCRQhpz3G723GyxplrZ7SCO49TExVuCvNIMroFRIWbEtmXzHI+AWExQ/H1PAgz2nm0JMt5hKpU8fAwx66oyW3bfveXz07hXOfZVdMYP7bB1lq3ri7rrb7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZWf1di0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZWf1di0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03865C4CEF5;
	Wed, 17 Sep 2025 12:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112752;
	bh=5ffDmHzrIJgyLCAJvSWYYu/B/CWBzh+yF8+lu6roYcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZWf1di0nlu6wbMHMRTGl3iNpe16L8xjev2oClkxOQqgr3Cduut0zkQpE8Xr9eSpF
	 4C/xc18O2VlA4APi1MiP6Pqj1ZE4d1RVi8j1vSMACWgyjHOmVGDVQsGMGTxMY27wu2
	 nHVhK968oNmpkqfpHQJ6R8PIC2LKMIFNC5KUmmBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Coiby Xu <coxu@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 067/189] s390: kexec: initialize kexec_buf struct
Date: Wed, 17 Sep 2025 14:32:57 +0200
Message-ID: <20250917123353.509884641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit e67f0bd05519012eaabaae68618ffc4ed30ab680 upstream.

The kexec_buf structure was previously declared without initialization.
commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
added a field that is always read but not consistently populated by all
architectures. This un-initialized field will contain garbage.

This is also triggering a UBSAN warning when the uninitialized data was
accessed:

	------------[ cut here ]------------
	UBSAN: invalid-load in ./include/linux/kexec.h:210:10
	load of value 252 is not a valid value for type '_Bool'

Zero-initializing kexec_buf at declaration ensures all fields are
cleanly set, preventing future instances of uninitialized memory being
used.

Link: https://lkml.kernel.org/r/20250827-kbuf_all-v1-3-1df9882bb01a@debian.org
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/kexec_elf.c          | 2 +-
 arch/s390/kernel/kexec_image.c        | 2 +-
 arch/s390/kernel/machine_kexec_file.c | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/kexec_elf.c b/arch/s390/kernel/kexec_elf.c
index 4d364de43799..143e34a4eca5 100644
--- a/arch/s390/kernel/kexec_elf.c
+++ b/arch/s390/kernel/kexec_elf.c
@@ -16,7 +16,7 @@
 static int kexec_file_add_kernel_elf(struct kimage *image,
 				     struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	const Elf_Ehdr *ehdr;
 	const Elf_Phdr *phdr;
 	Elf_Addr entry;
diff --git a/arch/s390/kernel/kexec_image.c b/arch/s390/kernel/kexec_image.c
index a32ce8bea745..9a439175723c 100644
--- a/arch/s390/kernel/kexec_image.c
+++ b/arch/s390/kernel/kexec_image.c
@@ -16,7 +16,7 @@
 static int kexec_file_add_kernel_image(struct kimage *image,
 				       struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 
 	buf.image = image;
 
diff --git a/arch/s390/kernel/machine_kexec_file.c b/arch/s390/kernel/machine_kexec_file.c
index c2bac14dd668..a36d7311c668 100644
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -129,7 +129,7 @@ static int kexec_file_update_purgatory(struct kimage *image,
 static int kexec_file_add_purgatory(struct kimage *image,
 				    struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	int ret;
 
 	buf.image = image;
@@ -152,7 +152,7 @@ static int kexec_file_add_purgatory(struct kimage *image,
 static int kexec_file_add_initrd(struct kimage *image,
 				 struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	int ret;
 
 	buf.image = image;
@@ -184,7 +184,7 @@ static int kexec_file_add_ipl_report(struct kimage *image,
 {
 	__u32 *lc_ipl_parmblock_ptr;
 	unsigned int len, ncerts;
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	unsigned long addr;
 	void *ptr, *end;
 	int ret;
-- 
2.51.0



