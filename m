Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711343F789B;
	Wed, 20 May 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300854; cv=none; b=GUb1U0ImT5GjdhU1Hcy/vRNLAJtIF6A3a7dxQqMSinepXM4lPhsMR7XoTA27rTxH/67pg7hrpfWn1kmC8Yuj7wmPeqNICbNQArVLIar2w6lU8aKkAB8DiMOYbcE2SvGPBH/sb0jikm/67xC6gf6n+K3NJ2nSTgarWiAWc+LR6oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300854; c=relaxed/simple;
	bh=K5PJWq2S0myoA47uaQ5hdn6IcGq8bhN9ouiUO0Gwvao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJ7D9Wx/bGClfKdk8xOwfhiMZgUer2aM8kE9oLTGuTnVJ7kfzi9qwOhNhLdtjTP0XfRUK1ln5Khev/jJQTa2uu5J2ByXqHgm9bgFoZLjih1qo46dxH3BXyKx/4h0hziBTxSlOZRlploJ3FqhChpGcFLgnWudpuL1cvcWBUGGtqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyFUBPUP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyFUBPUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1811F000E9;
	Wed, 20 May 2026 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300853;
	bh=jLIjt5pk9Ye+XJm7BhM1Eu97yKXBf+hvskKPGJRMKro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NyFUBPUP7rHCCx2NIezBYRX6COBhKl5RdaufYQnUhEgexowlq8LpvwFLnCnYauoh7
	 ERTuDqDTWIZ/p206QdQ/24+ZhxWWllqOL3dwy3FtAgKjteYoy105fnrwY0m9YkksqY
	 q0qmjG4vtmYrM1tKNdAsvL2ut78kTr5E6bDRQylc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <dima@arista.com>,
	Enrico Bravi <enrico.bravi@polito.it>,
	Silvia Sisinni <silvia.sisinni@polito.it>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/666] ima_fs: Correctly create securityfs files for unsupported hash algos
Date: Wed, 20 May 2026 18:19:03 +0200
Message-ID: <20260520162118.425384929@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit d7bd8cf0b348d3edae7bee33e74a32b21668b181 ]

ima_tpm_chip->allocated_banks[i].crypto_id is initialized to
HASH_ALGO__LAST if the TPM algorithm is not supported. However there
are places relying on the algorithm to be valid because it is accessed
by hash_algo_name[].

On 6.12.40 I observe the following read out-of-bounds in hash_algo_name:
  ==================================================================
  BUG: KASAN: global-out-of-bounds in create_securityfs_measurement_lists+0x396/0x440
  Read of size 8 at addr ffffffff83e18138 by task swapper/0/1

  CPU: 4 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.40 #3
  Call Trace:
   <TASK>
   dump_stack_lvl+0x61/0x90
   print_report+0xc4/0x580
   ? kasan_addr_to_slab+0x26/0x80
   ? create_securityfs_measurement_lists+0x396/0x440
   kasan_report+0xc2/0x100
   ? create_securityfs_measurement_lists+0x396/0x440
   create_securityfs_measurement_lists+0x396/0x440
   ima_fs_init+0xa3/0x300
   ima_init+0x7d/0xd0
   init_ima+0x28/0x100
   do_one_initcall+0xa6/0x3e0
   kernel_init_freeable+0x455/0x740
   kernel_init+0x24/0x1d0
   ret_from_fork+0x38/0x80
   ret_from_fork_asm+0x11/0x20
   </TASK>

  The buggy address belongs to the variable:
   hash_algo_name+0xb8/0x420

  Memory state around the buggy address:
   ffffffff83e18000: 00 01 f9 f9 f9 f9 f9 f9 00 01 f9 f9 f9 f9 f9 f9
   ffffffff83e18080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >ffffffff83e18100: 00 00 00 00 00 00 00 f9 f9 f9 f9 f9 00 05 f9 f9
                                          ^
   ffffffff83e18180: f9 f9 f9 f9 00 00 00 00 00 00 00 04 f9 f9 f9 f9
   ffffffff83e18200: 00 00 00 00 00 00 00 00 04 f9 f9 f9 f9 f9 f9 f9
  ==================================================================

Seems like the TPM chip supports sha3_256, which isn't yet in
tpm_algorithms:
  tpm tpm0: TPM with unsupported bank algorithm 0x0027

That's TPM_ALG_SHA3_256 == 0x0027 from "Trusted Platform Module 2.0
Library Part 2: Structures", page 51 [1].
See also the related U-Boot algorithms update [2].

Thus solve the problem by creating a file name with "_tpm_alg_<ID>"
postfix if the crypto algorithm isn't initialized.

This is how it looks on the test machine (patch ported to v6.12 release):
  # ls -1 /sys/kernel/security/ima/
  ascii_runtime_measurements
  ascii_runtime_measurements_tpm_alg_27
  ascii_runtime_measurements_sha1
  ascii_runtime_measurements_sha256
  binary_runtime_measurements
  binary_runtime_measurements_tpm_alg_27
  binary_runtime_measurements_sha1
  binary_runtime_measurements_sha256
  policy
  runtime_measurements_count
  violations

[1]: https://trustedcomputinggroup.org/wp-content/uploads/Trusted-Platform-Module-2.0-Library-Part-2-Version-184_pub.pdf
[2]: https://lists.denx.de/pipermail/u-boot/2024-July/558835.html

Fixes: 9fa8e7625008 ("ima: add crypto agility support for template-hash algorithm")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Enrico Bravi <enrico.bravi@polito.it>
Cc: Silvia Sisinni <silvia.sisinni@polito.it>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Tested-by: Roberto Sassu <roberto.sassu@huawei.com>
Link: https://github.com/linux-integrity/linux/issues/14
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_fs.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 87045b09f1206..25970867f594e 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -404,16 +404,24 @@ static int __init create_securityfs_measurement_lists(void)
 		char file_name[NAME_MAX + 1];
 		struct dentry *dentry;
 
-		sprintf(file_name, "ascii_runtime_measurements_%s",
-			hash_algo_name[algo]);
+		if (algo == HASH_ALGO__LAST)
+			sprintf(file_name, "ascii_runtime_measurements_tpm_alg_%x",
+				ima_tpm_chip->allocated_banks[i].alg_id);
+		else
+			sprintf(file_name, "ascii_runtime_measurements_%s",
+				hash_algo_name[algo]);
 		dentry = securityfs_create_file(file_name, S_IRUSR | S_IRGRP,
 						ima_dir, (void *)(uintptr_t)i,
 						&ima_ascii_measurements_ops);
 		if (IS_ERR(dentry))
 			return PTR_ERR(dentry);
 
-		sprintf(file_name, "binary_runtime_measurements_%s",
-			hash_algo_name[algo]);
+		if (algo == HASH_ALGO__LAST)
+			sprintf(file_name, "binary_runtime_measurements_tpm_alg_%x",
+				ima_tpm_chip->allocated_banks[i].alg_id);
+		else
+			sprintf(file_name, "binary_runtime_measurements_%s",
+				hash_algo_name[algo]);
 		dentry = securityfs_create_file(file_name, S_IRUSR | S_IRGRP,
 						ima_dir, (void *)(uintptr_t)i,
 						&ima_measurements_ops);
-- 
2.53.0



