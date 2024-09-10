Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D0E192D75;
	Tue, 10 Sep 2024 10:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964108; cv=none; b=mp/yGugtvVeE7EVcMzQ2ppzKurDlFTQRPYKXr8jWWssvUCSl3q1RQJ3sBWB48TmOVZvzb0op7kfK4CvQ47xGsZx61oFiy1z39lvFfF4/O6B7FbkGquiYQdoGo0bca6uHOWzWK83M+eoVYL/PgG47sibGAL2ejqhjneTk2CSc++Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964108; c=relaxed/simple;
	bh=dE838avZTsB2rid5O2tdtJJ1dCrpNGYW0miaqdBQF7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDai+Iw1vghQL82XmSmm73P5sG100TX26BQpPEiByLhOt/iFm17+mRLDxdu0IQPrmMcBPQJ75MwAYANtRCKif4KgFeGkQs3nkPceDqIzXJg3bEutW17/8tjUBL4dudXlbvgBxhbqP94F6WMJKM/+MbP6B9E9n02FAZQdCO3gvNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NADd78VI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NADd78VI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B1DC4CEC3;
	Tue, 10 Sep 2024 10:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964108;
	bh=dE838avZTsB2rid5O2tdtJJ1dCrpNGYW0miaqdBQF7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NADd78VIzoWzj/bwlcYe+kFI50ACsfL2TJRA7CuGQbPHkbh0rEeTWTEhDtQP4uDHg
	 bzFbNNaQmhyGeVUfJDuMEBUvOEZyGj3rvybB7oJ6E+NLxZSgkEBG9QuX1c3o357B/H
	 MmYUoeRKMcYBLVvPUL3oJAsT15ndtJYqlTWBim3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/269] x86/kmsan: Fix hook for unaligned accesses
Date: Tue, 10 Sep 2024 11:30:58 +0200
Message-ID: <20240910092610.733550830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Brian Johannesmeyer <bjohannesmeyer@gmail.com>

[ Upstream commit bf6ab33d8487f5e2a0998ce75286eae65bb0a6d6 ]

When called with a 'from' that is not 4-byte-aligned, string_memcpy_fromio()
calls the movs() macro to copy the first few bytes, so that 'from' becomes
4-byte-aligned before calling rep_movs(). This movs() macro modifies 'to', and
the subsequent line modifies 'n'.

As a result, on unaligned accesses, kmsan_unpoison_memory() uses the updated
(aligned) values of 'to' and 'n'. Hence, it does not unpoison the entire
region.

Save the original values of 'to' and 'n', and pass those to
kmsan_unpoison_memory(), so that the entire region is unpoisoned.

Signed-off-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Link: https://lore.kernel.org/r/20240523215029.4160518-1-bjohannesmeyer@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/iomem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lib/iomem.c b/arch/x86/lib/iomem.c
index e0411a3774d4..5eecb45d05d5 100644
--- a/arch/x86/lib/iomem.c
+++ b/arch/x86/lib/iomem.c
@@ -25,6 +25,9 @@ static __always_inline void rep_movs(void *to, const void *from, size_t n)
 
 static void string_memcpy_fromio(void *to, const volatile void __iomem *from, size_t n)
 {
+	const void *orig_to = to;
+	const size_t orig_n = n;
+
 	if (unlikely(!n))
 		return;
 
@@ -39,7 +42,7 @@ static void string_memcpy_fromio(void *to, const volatile void __iomem *from, si
 	}
 	rep_movs(to, (const void *)from, n);
 	/* KMSAN must treat values read from devices as initialized. */
-	kmsan_unpoison_memory(to, n);
+	kmsan_unpoison_memory(orig_to, orig_n);
 }
 
 static void string_memcpy_toio(volatile void __iomem *to, const void *from, size_t n)
-- 
2.43.0



