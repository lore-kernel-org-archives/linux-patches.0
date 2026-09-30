Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D01531AFB;
	Wed, 30 Sep 2026 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790657; cv=none; b=PdsM5qJILDvsTcMkZOMhO7OjOav1TnYiyzwEn5GzEVT1rUPn1YRTfCIO9Khu4k0N39e0QNdnLyDurl6jYE8DgZIskzsV19PiSBdd0mm5QavY6d3vvtN9uOYze/q5nfw+TTqxuesBRqfHPbg39M3cZkmnBQ97iCPyg3c0N5EG0p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790657; c=relaxed/simple;
	bh=4BRZK7lLZmfmcezpuPCOf+G+bKol63w3TAP1gcOmzMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTLVVjKM+H1I9Z9ngQw46s+57G9Wcr6kjVQQLnLo8erw4rOBI00KGwLoLOz9QHiUVcd5T6okC6cFfRTB5UCndhvwVr+nc+ExYXuA9IHi4nKIjwc2vLFyMgIAVXnkUnF6IMMB4A1JavrAZGszDbMoMCFORow76d4WCgKm7vfmsSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxdFVfxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxdFVfxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916171F000FF;
	Wed, 30 Sep 2026 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790656;
	bh=kmECrZ7wgFiN7d+ErAuH8aTsekTcyc8OuZ5uQYiNUUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxdFVfxKr8JKFRU1Ae4GYucgGHgEPZoAFM51Qe/MSApk0HCRNhJA10HBhAfWuxkKQ
	 O3PzcWKh+wHv5bGeAbpU/9VNpx6WjQbXEKA3sxH98FoYFAvL8wzm1wzQ/GVBdXnOJw
	 aXR4EfGL3ecYm9QbWPGg7XoyyUaGEKXA1YLu/4y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hirokazu Honda <hiroh@chromium.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/752] tee: optee: Allow MT_NORMAL_TAGGED shared memory
Date: Wed, 30 Sep 2026 17:17:54 +0200
Message-ID: <20260930152358.235546518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hirokazu Honda <hiroh@chromium.org>

[ Upstream commit 1a6e94a8ff32e7879effd1e4a45bf112e506edc1 ]

On ARM64, shared memory can have MT_NORMAL_TAGGED attribute when using
the Memory Tagging Extension (MTE). The OP-TEE driver needs to
recognize this as normal memory to allow sharing such buffers with the
Secure World.

Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/call.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 945f03da02237..4588a23d5b02b 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -574,7 +574,8 @@ static bool is_normal_memory(pgprot_t p)
 	return (((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC) ||
 		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK));
 #elif defined(CONFIG_ARM64)
-	return (pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL);
+	return ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL)) ||
+	       ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL_TAGGED));
 #else
 #error "Unuspported architecture"
 #endif
-- 
2.53.0



