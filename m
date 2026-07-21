Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6B83B9930;
	Tue, 21 Jul 2026 21:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670395; cv=none; b=fT2OWPwEExsBlZ5nJ9pphITpwLJg7FSjSgmZzCatUB9YMa44S/QQ6Yn61bUug7ya9B4cwkAlrwIdfe1Bw1r5FNgk38YCltiI3Hc4cqP9o4gppgJOG6bFAqTIzYySNClusRY+icsCqO/HxoUAoDfSh5nX4kxnUySLritdtKiOPbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670395; c=relaxed/simple;
	bh=LLd7Vv21R5KV59lyYudosS1mk3zQScy3xbUU70OEhMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcQd2r2Wb2YjV3KkTzwKWwd6ADNEL8x9rxyr7WpIuF3lrbn3qPTWVT8A/wHLXOOl3isfshNqMWXULA3gpwnwZYRpEBHKsfQBA7RMmdX2COD2ctNOir1d8NG97OQencxQyBf8HTaB3Qi0HT20d8JgEp/QMy2QRGTzFpvK8fiDhvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGuCOaha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGuCOaha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBBC1F000E9;
	Tue, 21 Jul 2026 21:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670394;
	bh=IvTMjvPryn9pHfzaNvtOKZOZ8QXlS5uWvqgnOyZdRoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGuCOahaGezpICpyC5fCSENCZed6Jqo6PUDptfp77vaIGXdfetRhMliSeX8B2vBl/
	 T9LzhGV87wFDQmNX8npk8qCHVuGRf5Y70y2VZ8DjiWHPoJW/RPVomi7xVyy3uqCaHT
	 xu8zRKqi4jOfRrNy8S954vp9dKrZJxh7Hiw2K5oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Tao Liu <ltao@redhat.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.1 0915/1067] riscv: Prevent NULL pointer dereference in machine_kexec_prepare()
Date: Tue, 21 Jul 2026 17:25:16 +0200
Message-ID: <20260721152445.004214524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


