Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F98C375F99;
	Tue, 17 Mar 2026 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765499; cv=none; b=BQ34lWPs6BkLjKNoeBxjuBa3G2ocv/I/FKoH34sAV5Q9yiALA1yrqvpXVsGba/NcCc11UjCkiwRAP6ceNtno0MUPu1cHqPbuX9TMCc0KM1kGiwWJHNEAfVd2HnDyMyiIFFQgmcBAFtjUNkvOs3RT8NKC2xpNpjJYaFVCaB4aLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765499; c=relaxed/simple;
	bh=2ydWS2XYajKGGY4Q+Q0fmaEgU3DwFdaY8vozBWsP3r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaLzMVy3XfL+VxHPhGshAgx3sYHMvzQli8R39voWeZSMNrPqQn0/rNOn2Y9bHQpvCyIVS4fdWT8/xAn10zAbdUK6WMh4i9bRYb1xyVU9DT86XPF6AxWwWBLou/3aDjsaLUXBxAi657gZInZJnIpu7DjPI22HUw0Wp31ynPZOXE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AULqwQR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AULqwQR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1FAC4CEF7;
	Tue, 17 Mar 2026 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765498;
	bh=2ydWS2XYajKGGY4Q+Q0fmaEgU3DwFdaY8vozBWsP3r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AULqwQR1pw7/bI7dba3bcBXoK+RCH/d/Ow5v8bnDlak+9YAF87Y2EgQtTmnxTnqcg
	 1GD/oQCo2vepBd0P5Z2MK0LOsTtdA5qk8dbjRrHUEkKF685OnlCKu4pqFQXjL/li5V
	 3LyNSRA5J5bl/FERKhInH1qFwD6v6FEkc8NezAs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 004/378] powerpc/crash: adjust the elfcorehdr size
Date: Tue, 17 Mar 2026 17:29:21 +0100
Message-ID: <20260317163007.130315221@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index e7ef8b2a25546..5f6d50e4c3d45 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -450,6 +450,11 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
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
 
@@ -460,7 +465,14 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
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



