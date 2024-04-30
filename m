Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B982712D768;
	Tue, 30 Apr 2024 11:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475717; cv=none; b=EWm1bmm+FBIRpS9Zi7YDWMbVUlMqbo7vClwqo0/3kl7hPHXHepyx6Vf7dBEBs5RqHikLh0nBWnttckTGjrB2WrgWK0d7nOSwUcY4KrdpJCjsQXbUQkv+/n+LYwNHTsiXLx92GbnNSCnqDcIOTousRh8rxt60I3yNkRkEDJGZDFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475717; c=relaxed/simple;
	bh=MkFvTpOhSh0XDzpIsulph6AtKtyN00Mt/HpUk21gBUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qia7J1VD6wqGPWeCRZjsPYWifdPDKKMXYKFRML8USlXoOdUAoG/Ne4Rwa8sZU0pu5QmMiADthh4LEeLyZtGaynpNuPhDs6gqpjDSZxN2qK9BgxVC3NOCP6mguq5jEuMeFX6HiCoUAfHiDXCMhlFtpQiF3tKI5XwGPl4NRbWDvSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdiK7/PH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdiK7/PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0A4C2BBFC;
	Tue, 30 Apr 2024 11:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475717;
	bh=MkFvTpOhSh0XDzpIsulph6AtKtyN00Mt/HpUk21gBUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdiK7/PHgxFaa0Dctflog8jUk32LN8+fRU8cunWeIrfK38cz2nxsoo61dJCYAnNNg
	 ZKbez7/v+jBVh64FZMrBKGNZPflRZz/x8vcuCBEUYo8mbYP5X86CYCFgtLNrZPBzCi
	 H8Jonoa4mstF4RGxY9oI57p9vjItZbEvXdUmKt2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Chen Jiahao <chenjiahao16@huawei.com>,
	Mingzheng Xing <xingmingzheng@iscas.ac.cn>
Subject: [PATCH 6.6 182/186] Revert "riscv: kdump: fix crashkernel reserving problem on RISC-V"
Date: Tue, 30 Apr 2024 12:40:34 +0200
Message-ID: <20240430103103.314748940@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mingzheng Xing <xingmingzheng@iscas.ac.cn>

This reverts commit 1d6cd2146c2b58bc91266db1d5d6a5f9632e14c0 which was
mistakenly added into v6.6.y and the commit corresponding to the 'Fixes:'
tag is invalid. For more information, see link [1].

This will result in the loss of Crashkernel data in /proc/iomem, and kdump
failed:

```
Memory for crashkernel is not reserved
Please reserve memory by passing"crashkernel=Y@X" parameter to kernel
Then try to loading kdump kernel
```

After revert, kdump works fine. Tested on QEMU riscv.

Link: https://lore.kernel.org/linux-riscv/ZSiQRDGLZk7lpakE@MiWiFi-R3L-srv [1]
Cc: Baoquan He <bhe@redhat.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Mingzheng Xing <xingmingzheng@iscas.ac.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -173,6 +173,19 @@ static void __init init_resources(void)
 	if (ret < 0)
 		goto error;
 
+#ifdef CONFIG_KEXEC_CORE
+	if (crashk_res.start != crashk_res.end) {
+		ret = add_resource(&iomem_resource, &crashk_res);
+		if (ret < 0)
+			goto error;
+	}
+	if (crashk_low_res.start != crashk_low_res.end) {
+		ret = add_resource(&iomem_resource, &crashk_low_res);
+		if (ret < 0)
+			goto error;
+	}
+#endif
+
 #ifdef CONFIG_CRASH_DUMP
 	if (elfcorehdr_size > 0) {
 		elfcorehdr_res.start = elfcorehdr_addr;


