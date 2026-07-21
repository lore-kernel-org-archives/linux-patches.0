Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC703E49FD;
	Tue, 21 Jul 2026 22:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671665; cv=none; b=Rd74FpRRXzHUOeS4hMIm0PARvHKGrLCBJQBzlKG201Kuy+B0ISMbpHuKJXTGE/P1Se33nCmYcmncn4pZKQh5mjWPku1azACcZECfDeA5PpsgX0XTiZtjKwrmlUXKVIUUHoR5O7mx12mwMAyZZOvPA8cSViwqChR4muzTDjfKzmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671665; c=relaxed/simple;
	bh=ygzh9lxD4q2Bto6gcmmUo61V1UV1QZiUr7JF9H1TDzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRNUrj4HVgQwpOwHr/l4jGMemQlw0hTvHa/o/aP8sAGEpfsOvuZdBzpA3TbYq+2tewy+FEBvxC/ROpN6aRl57lKt3En8H2KFoOsNnm6CPc9Bhp+BO49vQhkScGR/nBAiAZddu+Widz9w6ePhJVmfZG1jrvcpNy3v6URi57XgvS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuG4OrHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuG4OrHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBC71F000E9;
	Tue, 21 Jul 2026 22:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671664;
	bh=II/+L7yLjPELwxwRRZsHDNNhkupd5aI5ddzPcU+Fqkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuG4OrHUEzk9149JOmOPVAAg/BRitW7ucO55Py652N4Q8yGv9v1oVnQD+mLpsStlW
	 djl3LyXhvrWhyfCzqu63EB34QQQKhXomXLHlkc10BLStas8z5k5+TR9icOZKvUao9J
	 WknW7t4acNDDOutxaPok203/uUf24m1/VvpK4Hw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/843] selftests/bpf: Fix bpf_iter/task_vma test
Date: Tue, 21 Jul 2026 17:19:27 +0200
Message-ID: <20260721152413.488485044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
index 4ea6a37d1345f0..6a8d40413a5955 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
@@ -47,7 +47,7 @@ SEC("iter/task_vma") int proc_maps(struct bpf_iter__task_vma *ctx)
 		bpf_d_path(&file->f_path, d_path_buf, D_PATH_BUF_SIZE);
 
 		BPF_SEQ_PRINTF(seq, "%08llx ", vma->vm_pgoff << 12);
-		BPF_SEQ_PRINTF(seq, "%02x:%02x %u", MAJOR(dev), MINOR(dev),
+		BPF_SEQ_PRINTF(seq, "%02x:%02x %llu", MAJOR(dev), MINOR(dev),
 			       file->f_inode->i_ino);
 		BPF_SEQ_PRINTF(seq, "\t%s\n", d_path_buf);
 	} else {
-- 
2.53.0



