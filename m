Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89BF41A547;
	Tue, 21 Jul 2026 19:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662089; cv=none; b=BHndPvVJAjbJDNZKtRjegafOTKAWDScSrTzB1fBhDgx2Ye6/EuZ2BflUPv5uTmtvtfl3aeBbTxIpt3Do/Iynf0wBKK9TvQsEP9BqVoAGcDC6w+NECbK5dAC8guzCYXZoxJuUcYkbBXrysntbvvL2IYsM6Y1FNjSY/5e11EukFTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662089; c=relaxed/simple;
	bh=pjThavG6qogkhQfbc/7mL0flKcxB+brkjQ1HuAkijpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtp7OZQdUAzMoqNWl9iHBrNegqrrzMtGz72pA53fDVMUmkMW9R2fnGWim62asxfV89BYYmQIoBUfj3TRQueS1kYHtZNA9DlhRJcMrCUb4c6bf1TQGiiWtTsLv7U8BgEgKoooTCBtxjjZPmUMB6TRZ83tezOEIkh4PlZmBTNEAdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9C9t7Q8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9C9t7Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C69D1F00A3A;
	Tue, 21 Jul 2026 19:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662084;
	bh=jdZLQ5zEVCtri5govyAINhKVIpZn8I9rVUVNh26y7h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9C9t7Q8pi412KAlNmzzLpWXpyvcS+v/BYt4cJ6XoOqpxDugZwKOqX2W28IaWtEzt
	 SNm/WThA5ErQpR0/7gYAEiNqLflLATXu1EG00RFD/k6AC7j3mbAmi2OpgjlZ0MEvdf
	 zKdUkTHh1FME3BtkcHEVUFW1HKsVS/blb+oQIO70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0310/1276] selftests/bpf: Fix bpf_iter/task_vma test
Date: Tue, 21 Jul 2026 17:12:33 +0200
Message-ID: <20260721152453.029642691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 423b39e60b6f1c..81390e3a786196 100644
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



