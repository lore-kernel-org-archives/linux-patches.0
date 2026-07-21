Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F58446D2C2;
	Tue, 21 Jul 2026 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659299; cv=none; b=mBqKeuv8sD0mEwSbmkwkYe4jptGQXt7GVtC2A9wFTqcnzFFULXlXBvUhHC+jgSOzMs87uZ5gw3OVMe9gVjp2aV8PwvEHvE1z6z6efyHKtPwb5qgAr4AVITT/i7ZZHTl54hTW3KSNmsJLoNz2JcVTGr43Een7iG7iieIW5RWgaqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659299; c=relaxed/simple;
	bh=EKVi3gPinCIggxsWGh01UIa/vGf+/uIbAJGyWicYzGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVrYi2ZvKfTpRDTipdNLYUag533h/ZvNN0Ox9oR331ANVMjqmMDEGdJSIwAOOwj16rkxxtlWb8LKVZhpMNZFfZqt/JNJbDjEm79WefPcmzHSWYRBpqZIQJCs+CYT2AB0cc633kyxHu8Wx7JyEQkq7nJKI3TW2Ixes1sPX1VHSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=butSIYlM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="butSIYlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B505D1F000E9;
	Tue, 21 Jul 2026 18:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659298;
	bh=ewrDfCT753OChdaDp5tkjvQvMox4jdtE84e2EDI314Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=butSIYlMP2NqzTQiHP9pXbANCdaE4c48KnHmpOc1zXni+p2EfrkdIADCGblZhIENe
	 fbaatRfmAJLBQvOJ+ZuSJbJayYFHt+C8/URtp3htwhA4/Fy13v97D7hTbyGbuiphZH
	 j36vYc2dVIYh/5VSdNQHbfxYOdJjEZDgpuoPZR2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Tao Liu <ltao@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 1467/1611] riscv: Prevent NULL pointer dereference in machine_kexec_prepare()
Date: Tue, 21 Jul 2026 17:26:23 +0200
Message-ID: <20260721152548.443759843@linuxfoundation.org>
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


