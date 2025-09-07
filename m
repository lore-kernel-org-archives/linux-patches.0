Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE6D125B2;
	Sun,  7 Sep 2025 20:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277977; cv=none; b=fTTq2aIk2mL0H9eO0CgCh/w/150mDN3zVm2bVRPAc8zya/BnKMGjpnuR9nhGVBSX3XX5e5nRPxA2j7p9VgzgTY5m3MmM7gTgeeEPu143H7T3mpPNLUmp/S72upUqo6uqZ+P+gpTRFcDm1jb5w2vehAudfPnluvUmAyJEdqp6o3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277977; c=relaxed/simple;
	bh=w+teoBLGtY3Y9tKoPWPPTnXlwFONCyYt03invsCH/uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ6BA8aS9bEUjIjFCF/Z0X34GyI6ZPnnFJFykGeNUkpib+c0fIlnhFn7gIBLgQ/ewaE+0VdAiuGdEF09WEPshAydkcEOweRtb55sNDbj2I41rivOHaxroj1cKR6jCecQOYDfb69zBuwmUJa6q2QoiDOyOL7r+NvVdoCyD9k6Cw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnUIxPho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnUIxPho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B023C4CEF0;
	Sun,  7 Sep 2025 20:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277977;
	bh=w+teoBLGtY3Y9tKoPWPPTnXlwFONCyYt03invsCH/uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnUIxPhoYA06xDzQl74MRTZwqM4rQebUybYnf7knEbAHt3lFjbhtVNDZ4Fg/Qs2MD
	 omnSUhmYfLuo9aJWJExkh66VW4Bzt7iAwVtj4/sMZglVEjgLccXcYaGWZBMztdvTmR
	 WOWzMm/sVuGM8VjMG/u9kcETrGrB2CE2jKG2CE3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 182/183] riscv: Fix sparse warning about different address spaces
Date: Sun,  7 Sep 2025 22:00:09 +0200
Message-ID: <20250907195620.155067659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit a03ee11b8f850bd008226c6d392da24163dfb56e upstream.

We did not propagate the __user attribute of the pointers in
__get_kernel_nofault() and __put_kernel_nofault(), which results in
sparse complaining:

>> mm/maccess.c:41:17: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void const [noderef] __user *from @@     got unsigned long long [usertype] * @@
   mm/maccess.c:41:17: sparse:     expected void const [noderef] __user *from
   mm/maccess.c:41:17: sparse:     got unsigned long long [usertype] *

So fix this by correctly casting those pointers.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508161713.RWu30Lv1-lkp@intel.com/
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: f6bff7827a48 ("riscv: uaccess: use 'asm_goto_output' for get_user()")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Cyril Bur <cyrilbur@tenstorrent.com>
Link: https://lore.kernel.org/r/20250903-dev-alex-sparse_warnings_v1-v1-2-7e6350beb700@rivosinc.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -438,10 +438,10 @@ unsigned long __must_check clear_user(vo
 }
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
-	__get_user_nocheck(*((type *)(dst)), (type *)(src), err_label)
+	__get_user_nocheck(*((type *)(dst)), (__force __user type *)(src), err_label)
 
 #define __put_kernel_nofault(dst, src, type, err_label)			\
-	__put_user_nocheck(*((type *)(src)), (type *)(dst), err_label)
+	__put_user_nocheck(*((type *)(src)), (__force __user type *)(dst), err_label)
 
 static __must_check __always_inline bool user_access_begin(const void __user *ptr, size_t len)
 {


