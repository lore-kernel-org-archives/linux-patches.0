Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078BD46D0AD;
	Tue, 21 Jul 2026 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655297; cv=none; b=Kd1aspSSxAlV/w2LJfVgYl2yVg9UnSCYNnvSOSU70EiF8DvVNAm4tRFWJmY9mCqALvHdtVg+cEYX2WFXPbfAKp7ZCT3JVY/K/rSBMBVOHmLZ000qbs2RbVCAvsDAlDqz7ZB2b13rGia4o3361wWG6TEgw5mGx9QGGJKIohrmM10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655297; c=relaxed/simple;
	bh=1640x23otoMXnqhDeqXn6B7coqTxkzGq67PR4MKrVEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8KGPoOdKqmqqw91jcLihq5CChxmD6znHD8yirTwZRdIBDViEbNRd9dzsu+RAcIGl5HfzOLzx8WwxYPnLaytcarZnmHjmkHujW0pRCFTe2WMObFgayUYbZlBnfH7JuAD+BLtLhhGisE43JJ9lxiD6RjDYxjTZ2VE2kXDm/W9Wec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk/lAieA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk/lAieA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D61B1F000E9;
	Tue, 21 Jul 2026 17:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655295;
	bh=X1eklcMA2M+J6aiBRbYwS5ilT6dhTqz/lgVP7LCirQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk/lAieAKOiS+J7zHBTpRRuXjq+D8kgYRJnPCms+4sDI5ddPJi5yS/J/xUJo42x9R
	 ORMMea18yGXWTk48iQ08xmIue8ZgqcCeK80RYQMA1ILZQpW0D7bvINDijD+knnsXEa
	 yjoMS2ZulS7DHGg3mUaLYBp8G0esxhSMpzo9hbW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Tao Liu <ltao@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 1988/2077] riscv: Prevent NULL pointer dereference in machine_kexec_prepare()
Date: Tue, 21 Jul 2026 17:27:41 +0200
Message-ID: <20260721152639.602734499@linuxfoundation.org>
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


