Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623096;
	b=ddcp/TImdav+Nlyed1/12IbyyzZy66hS26jvAbKvZ3H7iH70bVFAKS7A227ZFcJeZOcF
	 l2xEYT8C3VyvacPt7RthY7u86tSkQ6HESv0FHVyOAffHT68nVWF/7auQv21xQYjt8O+Uf
	 /CDhoatupLSshzggkPPIZtcQf7dZQyGZafPufUrn2NichJWNZ5yQBmTXex4VLLVDO7gO5
	 HBiJvT3N5LEQ9uVwoy7ibz4NTYpT0oh5JtMj+BAnURukcj636pry6CQkEWcXRIkfBTSv+
	 lZ/M3ZG7OI4mZpXsk9UBxqW1IBinPrNjMOeEyc+RTUkLpT0mKr7DPDbaOU3B/JQEBUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iN5dyfdQfzg9S+Bu9EavQOJH2jdOwRlEH8wwHOzzz8o=;
	b=iaIvvt3VbFs2GKK6F6rzNs6P5DtjXKJTh+cVvW2rf1pxkn0Esuc04stItg/OrL7A1qYv
	 tSd5MpE4f476hKa2Iq6GBZO1fdsvAbcRQkWjWNLc08p+jLhAW+QcthHXzWPfLxKpZR5x7
	 2zq8nVwBb1XItRRCkzYjtYXYzoAwzvHlZSJ0eLkrQzPbgmPMNEaueLn/2qfig4aQupGZ3
	 in6J+3xsspZkLxisHvayKjxv2YCkh16hZ2SYyR+6fQNQ7k0BWW6/VHOeAwtnh/9wMUFeo
	 YMi010Jshm451sK5FTuPHa7jOB8M/BFAXVr8S0nYkhA5N6zP9Rc/+exhhEbyN4u8R4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOdLP9in;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1569606A31E;
	Wed, 25 Nov 2026 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOdLP9in
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EE21F000C0;
	Wed, 25 Nov 2026 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623096;
	bh=iN5dyfdQfzg9S+Bu9EavQOJH2jdOwRlEH8wwHOzzz8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOdLP9in1Xa+oCw2GWc/nPX0JlVZc+bM6Hu2yOzS0Zoaf2HVzb2xHgnS97Fi0EuNb
	 vSPGizV+py1ql+e+u88QvbzG02NV6aEEOzgYKiFDii1rcVc7woPp4SVmfK6go8VeCs
	 KC/QU5XB+OExZu9LORUsMdV4NffHPZjdE1HvVnBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 750/990] arm64: kexec_file: Do not use CMA for images with a non-zero text_offset
Date: Wed, 25 Nov 2026 15:35:17 +0100
Message-ID: <20261125143839.628787381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 18f2d01bfce99a885511c451cba95234eea190bc upstream.

image_load() adds text_offset to kernel_segment->mem and subtracts it
from kernel_segment->memsz.  For CMA backed segments this breaks the
load path: the payload is copied to page_address(cma), which is the CMA
base, while image->start is set to the adjusted address, so kexec jumps
into the middle of the kernel.  kimage_map_segment() has the same
mismatch when a segment has been moved.

The adjusted memsz also breaks the release path: the CMA pages are
freed using segment->memsz >> PAGE_SHIFT, which is fewer than were
allocated, leaking the tail of the allocation.

Both problems are specific to CMA segments, which are accessed through
page_address(cma) and ignore segment->mem.  The normal load path uses
segment->mem, so the text_offset adjustment stays consistent there.
Keep honoring text_offset, but load such images from regular memory by
setting image->no_cma: they lose the CMA contiguous allocation, but
keep working.

Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260921090450.807575-2-ruanjinjie@huawei.com/
Link: https://lore.kernel.org/all/20260921090450.807575-3-ruanjinjie@huawei.com/
Link: https://lore.kernel.org/all/au4JOjnQlx2aSpiE@arm.com/
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/kexec_image.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -82,6 +82,13 @@ static void *image_load(struct kimage *i
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	kbuf.memsz = le64_to_cpu(h->image_size);
 	text_offset = le64_to_cpu(h->text_offset);
+	/*
+	 * A CMA segment is loaded and mapped through page_address(cma), which
+	 * is the CMA base and cannot represent the text_offset adjustment
+	 * below.  Load images with a non-zero text_offset from normal memory.
+	 */
+	if (text_offset)
+		image->no_cma = true;
 	kbuf.buf_align = MIN_KIMG_ALIGN;
 
 	/* Adjust kernel segment with TEXT_OFFSET */


