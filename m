Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D286D38C2A0;
	Tue, 21 Jul 2026 20:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667597; cv=none; b=t8JUQit9Ehr/2H5uTmEVlQfgVy3UT14+mC/VIx3fOcUhD6j/8dqrXbgCvBzwD+Wmw18t8DzcpgCSi+3jtbV/XC38N3EkDrVpk4lIgT1bTGca6QmhvccAfmP/CQ0CRki/xBdarueERToCEpDTNOdFEgpChn3xTyJlX3gM1FC73+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667597; c=relaxed/simple;
	bh=6p8zcpesYJHO71mS5PR/BlXbII7JHiRcTtBg++n1q6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOVrIrNT434DkG7hFZtUMVc2XBiB+q+Gvo0A1oS0TEjPxP05UKGY/pxC+Bearx3y/sLJGVTS5kl5AwwDg4fiYeyeIqY+o6nLse5axn8Fwob73I0fcfS/YAG//0Is5QpHayc8hH8MRo7I4z1UBa3jc9Na8C/PkZmZQb1PvpO+D2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFgfaGbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFgfaGbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A291F000E9;
	Tue, 21 Jul 2026 20:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667596;
	bh=3jiYHGsBKya7qpejQi8zkhJt6JjjBjTVGn36TcGS0+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFgfaGbHkKkNI1JkSnr4WeAIVwcLw3U7hp4yOcRwiXCjzLEUHA0mg3G1x7yi0nVKP
	 FrvYzcWzIyW3dNV6zcMV5ep5ur22uM5YCPLHrPXSLkGSZhpD5drRjPMyvQ53oclPjR
	 N7e2APq5+ZbU7OoAR9EhZiKc1vmvVX9URibG8ZJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Tao Liu <ltao@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.6 1122/1266] riscv: Prevent NULL pointer dereference in machine_kexec_prepare()
Date: Tue, 21 Jul 2026 17:25:59 +0200
Message-ID: <20260721152506.905424490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -67,6 +67,9 @@ machine_kexec_prepare(struct kimage *ima
 		if (image->segment[i].memsz <= sizeof(fdt))
 			continue;
 
+		if (!image->segment[i].buf)
+			continue;
+
 		if (image->file_mode)
 			memcpy(&fdt, image->segment[i].buf, sizeof(fdt));
 		else if (copy_from_user(&fdt, image->segment[i].buf, sizeof(fdt)))


