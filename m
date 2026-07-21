Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA9239DBC5;
	Tue, 21 Jul 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649640; cv=none; b=BFujIcBg4LBsxaWkil48pRwSQ/ONxr7Zat7RcD4LAtsLnaoP74bz6XEnGHG9upW9R5rzIyTGff9ZS+1HfWYeU4CnnQTDAZ4ietdkOkEjTqTgaWCuqy97z0PpR99KDMRruE0H0+HC4ZkqK5ZL4qRVxz3F76UyevpeGrQjpSyPj/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649640; c=relaxed/simple;
	bh=wCGb58Fbp2bezsxBMg07snyef1ccT+vQOoPCKmXyftM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUJAspvp7CQsO3P4SIAOaBDljoeWDrZ/a13182S4Lw/YJoqOFaylrjhith3XYAKxs0i7v94sMoTKyJONpFvMqzUZOG85Dv4nNtP14vuk1OXAsAFNgU6igIKRq5nHDGDJl4LZl7xBjp4hl2mBETunC4cvUsuzySFLk+jRsVAOh4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZqMGpDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZqMGpDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC211F000E9;
	Tue, 21 Jul 2026 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649638;
	bh=N3zwisHcqQYF9upmMIohSw32jSP1A46m9BSIUpvy9u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZqMGpDTAxaOxeEow/TFCZ6a6KsD9G0Etml/wcHBcZeFs2wKp5msZLv+Qj+G1k4fk
	 dyh+9WZ3gdPTnT3qzDmFtHv2/2Gy1oMh7Gr8Mp8L7NZaXGKZLAvZi34jRZf78Es9FJ
	 lpcEoaiPsnbs/+EUtdgGxH+HSKZyAhPjs5vuBZC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0654/2077] selftests/bpf: Fix bpf_iter/task_vma test
Date: Tue, 21 Jul 2026 17:05:27 +0200
Message-ID: <20260721152608.232618566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



