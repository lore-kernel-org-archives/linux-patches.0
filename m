Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354673DA7DD;
	Wed, 30 Sep 2026 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796002; cv=none; b=oI/x+tcJIgQIJ9Abc6ZHDF/dTp8mgNK0P7HT02okIbMuhWNDrhn9pDowRv+E1q49h4rAA2YmG6uagGguNyRxJTjmjrvIssvrv4Y8LxBBQXrXbDT4OKgIaTshF/YBBtS1EC5Z6hHyKD0rKJnpujVlqIFpkJeXCthp5rtx6p4vjSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796002; c=relaxed/simple;
	bh=KmvQGS8PHYEbM44SthkADDhytqYw3MX2+mEgNgK5vKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYJmaNpwbItt67n7hHARuv80H3Lz6mckF6xYHTpq7iC74tBqVXBwFOm+7evc3TaLGIo4QVrTrVv1bSGz32B5YTFtWm5BKRpGWLE3Ak1D1OAXuCr0Lw9elO+qqLBClTxqVUBqOpmHbwhEf/00JCI5JjarhBKti2t/BRJgrrgSk+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+qX0zKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+qX0zKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA341F000FF;
	Wed, 30 Sep 2026 19:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796001;
	bh=z6AawOmjKE4SEiKpe/6/pjDzYb//LRCIX2RWkBzsdhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+qX0zKY8SpWr06CERdh4EIysiAgUTtOFe/a5uFFAGr2PYdlg52M5kJDtK283DSok
	 qonO7gVkdKglEfUxhYJzDh87k2P53JlfUxfxu/sYBrSwEE4uEkxI0f/SAL8DO5pZ/Z
	 OOMuFAXeD3XZ7FS31tgLbXyJ936T9xH0KgmZKIQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0714/1193] Revert "alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally"
Date: Wed, 30 Sep 2026 17:23:18 +0200
Message-ID: <20260930152450.114212720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

This reverts commit e5038d7f36037fc4ffc41b1a7dcd295bab7d7a04.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/uapi/asm/fpu.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/fpu.h b/arch/alpha/include/uapi/asm/fpu.h
index d28dc36786e27..cea9eafa056fc 100644
--- a/arch/alpha/include/uapi/asm/fpu.h
+++ b/arch/alpha/include/uapi/asm/fpu.h
@@ -101,12 +101,7 @@ ieee_swcr_to_fpcr(unsigned long sw)
 		      | IEEE_TRAP_ENABLE_OVF)) << 48;
 	fp |= (~sw & (IEEE_TRAP_ENABLE_UNF | IEEE_TRAP_ENABLE_INE)) << 57;
 	fp |= (sw & IEEE_MAP_UMZ ? FPCR_UNDZ | FPCR_UNFD : 0);
-	/*
-	 * Disable denormal operand traps only when denormal inputs are to be
-	 * flushed to zero.  Otherwise they must keep trapping, so that /S
-	 * instructions reach the kernel emulation handler.
-	 */
-	fp |= (sw & IEEE_MAP_DMZ ? FPCR_DNOD : 0);
+	fp |= (~sw & IEEE_TRAP_ENABLE_DNO) << 41;
 	return fp;
 }
 
@@ -121,6 +116,7 @@ ieee_fpcr_to_swcr(unsigned long fp)
 			     | IEEE_TRAP_ENABLE_OVF);
 	sw |= (~fp >> 57) & (IEEE_TRAP_ENABLE_UNF | IEEE_TRAP_ENABLE_INE);
 	sw |= (fp >> 47) & IEEE_MAP_UMZ;
+	sw |= (~fp >> 41) & IEEE_TRAP_ENABLE_DNO;
 	return sw;
 }
 
-- 
2.53.0



