Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ECC352FBF;
	Tue,  6 Jan 2026 17:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720168; cv=none; b=QKbWRGzReXwPvqUL33PEOamAtmdF3JS3ALya/qCk44BXHzdyqt5AGXhpmx+fhLTzeBvLEVtMaWyXpS/Lec6LyTvR4xL22ATwZCd3bVKJVZrAFxcRP20jl/QqeLFXtywYxCr/fPPy11n1SG3mRroTxknReDlZgAHAMCap8UAxkfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720168; c=relaxed/simple;
	bh=T1eY8XcvOWlZ4TQNPOCcSMyK8qdY60zx6pct342lrxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSlCHXH+ilbNgXXsX5CB4k0vA3rB4DTMxt9hnAWMn8fpvbTmya2xpgwcC+KzHTQilZDkAuLQ9UBkq7SXbDO3S+Iold3FpqM8vdRTa1aS2nOrCmlTwE9zk0aO6no5iYu8mZiCDN4s9m4bvHcZtyLaChz4dTk2MnjZdETOILmzDn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwXhLrWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwXhLrWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34124C116C6;
	Tue,  6 Jan 2026 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720168;
	bh=T1eY8XcvOWlZ4TQNPOCcSMyK8qdY60zx6pct342lrxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwXhLrWL4cdFIqavICsVK91j9n+Ne+dyTacXwl6oNO7TP60xSuQJbMtKZbbLxrMRP
	 aZ6FKm/gXVkuYUL8+8nb3L3MDTqDHZNRYMlPrRl94GfM1sNzM/fX13zBK/YxFtA9oD
	 kOTzyQQ8VpqpcVLlyuyz5nf0FGfadDldUU4C9Lds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 155/567] x86/mce: Do not clear banks poll bit in mce_poll_banks on AMD SMCA systems
Date: Tue,  6 Jan 2026 17:58:57 +0100
Message-ID: <20260106170457.061615082@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Avadhut Naik <avadhut.naik@amd.com>

commit d7ac083f095d894a0b8ac0573516bfd035e6b25a upstream.

Currently, when a CMCI storm detected on a Machine Check bank, subsides, the
bank's corresponding bit in the mce_poll_banks per-CPU variable is cleared
unconditionally by cmci_storm_end().

On AMD SMCA systems, this essentially disables polling on that particular bank
on that CPU. Consequently, any subsequent correctable errors or storms will not
be logged.

Since AMD SMCA systems allow banks to be managed by both polling and
interrupts, the polling banks bitmap for a CPU, i.e., mce_poll_banks, should
not be modified when a storm subsides.

Fixes: 7eae17c4add5 ("x86/mce: Add per-bank CMCI storm mitigation")
Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251121190542.2447913-2-avadhut.naik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/threshold.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/threshold.c
+++ b/arch/x86/kernel/cpu/mce/threshold.c
@@ -85,7 +85,8 @@ void cmci_storm_end(unsigned int bank)
 {
 	struct mca_storm_desc *storm = this_cpu_ptr(&storm_desc);
 
-	__clear_bit(bank, this_cpu_ptr(mce_poll_banks));
+	if (!mce_flags.amd_threshold)
+		__clear_bit(bank, this_cpu_ptr(mce_poll_banks));
 	storm->banks[bank].history = 0;
 	storm->banks[bank].in_storm_mode = false;
 


