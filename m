Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E447044D;
	Tue, 21 Jul 2026 20:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664171; cv=none; b=XZSRZoy0J0Yawgv6tXWG/08Ge7xNmQsRZg3XfI6pqnrmTNk580ndZyd8fueiSe6w66LJmnXtGEixAyvV4uM5KG7/AWWhHWDljlRdKclfP3mq9rMx3JfdpqAFvpReGR9mEuJX1CDmbhndYZV8KMzLil+AoneD1pXljvGCuX6Bhxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664171; c=relaxed/simple;
	bh=y67n97JMLcSJq7txXVxmuAajPmfatyE9bLDqvQlF4tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5ivEEVUCpPU0OAv/SG+lvrhsw7PFCmmK3TGF2Asxav66UGIM0ZJF7LVceEkrKh6VP4X8MPT8MGnZwnr41R8yJdRvY/lQLJf+HnZGRtYykpcQtwaCw3t74+e9RCmRjHJa8UOov3TfPYXJVogOFi7/KmwPP79YHUeC6kuFTy4v8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GB/opp/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GB/opp/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F4A1F000E9;
	Tue, 21 Jul 2026 20:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664170;
	bh=22O6biX3CgE0i8vk5LIhaQYMjor9QY7JU4RD8lQ/0xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GB/opp/jJfpYjyIbDI/KQA5HCG5Y5mSpVY2P/pzdbqVD0mgQosWZUQM1TNj8v/syn
	 RtffIK75ZgNvccONoekykjjoPfdvuWNh/1MuX3y2lD2WDTmxie3f47IuvMkCl/l9/A
	 W6jM759FhtqdV01nt9N54E1BFYwY+CV54EO8xskg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Tao Liu <ltao@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 1098/1276] riscv: Prevent NULL pointer dereference in machine_kexec_prepare()
Date: Tue, 21 Jul 2026 17:25:41 +0200
Message-ID: <20260721152510.556750836@linuxfoundation.org>
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

From: Tao Liu <ltao@redhat.com>

commit 81bbcff0c053c4f5c711c31a9b72fc492bd96c3f upstream.

A NULL pointer dereference issue is noticed in riscv's
machine_kexec_prepare(), where image->segment[i].buf might be NULL and
copied unchecked.

The NULL buf comes from ima_add_kexec_buffer(), where kbuf is added by
kexec_add_buffer(), but kbuf.buffer is NULL, then it is copied without
a check in machine_kexec_prepare():

  kexec_file_load
    -> kimage_file_alloc_init()
       -> kimage_file_prepare_segments()
          -> ima_add_kexec_buffer()
             -> kexec_add_buffer()
    -> machine_kexec_prepare()
       -> memcpy()

Address this by adding a check before the data copy attempt.

Fixes: b7fb4d78a6ad ("RISC-V: use memcpy for kexec_file mode")
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/kexec/CAO7dBbVftLUhd2qrh7hmijTB3PEPfZAhykCGqEfrPoOcSrrj-w@mail.gmail.com/
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Signed-off-by: Tao Liu <ltao@redhat.com>
Link: https://patch.msgid.link/20260705232706.30265-2-ltao@redhat.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/machine_kexec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -41,6 +41,9 @@ machine_kexec_prepare(struct kimage *ima
 		if (image->segment[i].memsz <= sizeof(fdt))
 			continue;
 
+		if (!image->segment[i].buf)
+			continue;
+
 		if (image->file_mode)
 			memcpy(&fdt, image->segment[i].buf, sizeof(fdt));
 		else if (copy_from_user(&fdt, image->segment[i].buf, sizeof(fdt)))


