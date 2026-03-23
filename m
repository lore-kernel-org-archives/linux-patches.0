Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC0132470A;
	Mon, 23 Mar 2026 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275228; cv=none; b=uWqa4iC2bPpAK3BVCTcwope4e2tdCWVJJYanUijpJExMaGkD8XSPd1w1CZhR9jvAuUkpGsSqkURvWSGApjEeoNcOfDh8AD5IXsrUvNxME2S3bGt7U0E2GSO4RD2NY1ABgb5bFdhahseH6isgz9hHpGw05Kv5bsg7q1MalA9yS0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275228; c=relaxed/simple;
	bh=hIjMjKsnaPpvKLBPISBr3ctTRqM6C0C9OvBqmVsPfT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSH4wj95eYBNOfTcrYHzXgc70kAumuLMgs76Olg8GaNyNPad1Pps78uR5NFBe1a/zOzB219DzgJCDMHOizQXOlcWTufsrRHHyBmRZ3J1NAIqvNyhcr3jsZ0QdJi3QWHmwnLSsQ4G9OMC1cfdxSGEt8rfFckh74L9W5CzhwpL+nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iryASKzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iryASKzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85E5C2BCB1;
	Mon, 23 Mar 2026 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275228;
	bh=hIjMjKsnaPpvKLBPISBr3ctTRqM6C0C9OvBqmVsPfT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iryASKzRgYhmeWmhlxwOVNVD281jPI2hJouOzdEY7S44llrrI/djjIitZo+HriM5v
	 jSkXfOvtuIBQwluiow4ruA5+pUGuf48dtZy6bg6AeYpZHB7qQ+m6TK+zwAezmXSjd3
	 ZK2lypExre1q8FF3XI28clV/rFOB7Jw9XlTJbP9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/460] powerpc/crash: adjust the elfcorehdr size
Date: Mon, 23 Mar 2026 14:40:16 +0100
Message-ID: <20260323134527.157112440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 04e707cb77c272cb0bb2e2e3c5c7f844d804a089 ]

With crash hotplug support enabled, additional memory is allocated to
the elfcorehdr kexec segment to accommodate resources added during
memory hotplug events. However, the kdump FDT is not updated with the
same size, which can result in elfcorehdr corruption in the kdump
kernel.

Update elf_headers_sz (the kimage member representing the size of the
elfcorehdr kexec segment) to reflect the total memory allocated for the
elfcorehdr segment instead of the elfcorehdr buffer size at the time of
kdump load. This allows of_kexec_alloc_and_setup_fdt() to reserve the
full elfcorehdr memory in the kdump FDT and prevents elfcorehdr
corruption.

Fixes: 849599b702ef8 ("powerpc/crash: add crash memory hotplug support")
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260227171801.2238847-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index dc65c13911577..248a0f00a291f 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -633,6 +633,11 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
 	kbuf->buffer = headers;
 	kbuf->mem = KEXEC_BUF_MEM_UNKNOWN;
 	kbuf->bufsz = headers_sz;
+
+	/*
+	 * Account for extra space required to accommodate additional memory
+	 * ranges in elfcorehdr due to memory hotplug events.
+	 */
 	kbuf->memsz = headers_sz + kdump_extra_elfcorehdr_size(cmem);
 	kbuf->top_down = false;
 
@@ -643,7 +648,14 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
 	}
 
 	image->elf_load_addr = kbuf->mem;
-	image->elf_headers_sz = headers_sz;
+
+	/*
+	 * If CONFIG_CRASH_HOTPLUG is enabled, the elfcorehdr kexec segment
+	 * memsz can be larger than bufsz. Always initialize elf_headers_sz
+	 * with memsz. This ensures the correct size is reserved for elfcorehdr
+	 * memory in the FDT prepared for kdump.
+	 */
+	image->elf_headers_sz = kbuf->memsz;
 	image->elf_headers = headers;
 out:
 	kfree(cmem);
-- 
2.51.0



