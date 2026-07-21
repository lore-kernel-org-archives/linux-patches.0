Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F2546EC6F;
	Tue, 21 Jul 2026 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656613; cv=none; b=rjKl3P0XO0eREafF5qQCGyAvtOsysXICUxWZmtwspWOHmMtJV6QIaKj/+9I4nFQXqJGPVcImQker5r/UlwsfXXOkhGbKKxU5eGCuQzyMZFZiVDuW/HrqLE/S+IBMEYvGmnNuXiFl8Yf223UsQTyn1lThrqm0FaqOhnHn/auxvlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656613; c=relaxed/simple;
	bh=36kTDa29+aH5d2rg0amjkdQYf6YS87C45C7Yg7hFvXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7rkUtYMY630sN2+FGVVQsphESquxIqG4B04Iah7AzDOoHd+pqgP3HmTpCuQPMeQUfuvB/m1p39eY8ar1l7w7QglOkA0NvzboZd8AUjwKvNZGrw5U65y+4z+kiSCHRkcwIw7JRQVwq7BuE4fp+wv3BOvnxWJH5H3Oz6pCqaPi/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrPHans6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrPHans6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63411F00A3A;
	Tue, 21 Jul 2026 17:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656612;
	bh=SG2ZBs9WJRF0BnhWLbU8mBitJrgQOdToShgY9vLdlxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrPHans6+R+vuiJb92htXAT3Hx6u1PaPhuDTHVJHyiPYsT/1hUkClWLZSFyiIPqjb
	 6BUJgQ9v1zF+vacGuHYVuMWvsm+PwXSlx/IBjbxJnrdEjCQmbwVnVOrT8QC9XLc8NV
	 4hwl0+SaJhKHvp759PtTWwdFITQU5xhQCPa41UJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0452/1611] selftests/bpf: Fix bpf_iter/task_vma test
Date: Tue, 21 Jul 2026 17:09:28 +0200
Message-ID: <20260721152525.471656374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 2e8ad1ff712d2a397e407c9fde60901f68d077dc ]

For selftest bpf_iter/task_vma, I got a failure like below on my qemu run:

test_task_vma_common:FAIL:compare_output unexpected compare_output:
    actual
    '561593546000-561593585000r--p0000000000:241256579534/root/devshare/bpf-next/tools/testing/selftests/bpf/test_progs'
    != expected
    '561593546000-561593585000r--p0000000000:245551546830/root/devshare/bpf-next/tools/testing/selftests/bpf/test_progs'

Further debugging found out file->f_inode->i_ino value may exceed 32bit,
e.g., i_ino = 0x14c2eae35, but the format string is '%u'. This caused
inode mismatch between bpf iter and proc result.

Fix the issue by using format string '%llu' to accommodate 64bit i_ino.

Fixes: e8168840e16c ("selftests/bpf: Add test for bpf_iter_task_vma")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20260610051831.1346659-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_iter_task_vmas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_vmas.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_vmas.c
index d64ba7ddaed54e..d7fb561ed4fb90 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task_vmas.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_vmas.c
@@ -52,7 +52,7 @@ SEC("iter/task_vma") int proc_maps(struct bpf_iter__task_vma *ctx)
 		bpf_d_path(&file->f_path, d_path_buf, D_PATH_BUF_SIZE);
 
 		BPF_SEQ_PRINTF(seq, "%08llx ", vma->vm_pgoff << 12);
-		BPF_SEQ_PRINTF(seq, "%02x:%02x %u", MAJOR(dev), MINOR(dev),
+		BPF_SEQ_PRINTF(seq, "%02x:%02x %llu", MAJOR(dev), MINOR(dev),
 			       file->f_inode->i_ino);
 		BPF_SEQ_PRINTF(seq, "\t%s\n", d_path_buf);
 	} else {
-- 
2.53.0



