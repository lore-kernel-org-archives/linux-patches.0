Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1352A269CFD;
	Tue,  8 Apr 2025 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111853; cv=none; b=A76nTgA40idrujY5uJ9xqRS71Jfk2eI6SMxkTFwYGXGqf5CPox40AUSq7MSWjefz72bO0zqAsQW9zgNi7dqaqV4JH9B8OTtzfCukakwyrQ1OplTv5JJ4iAKnmHi9VP13BF5rqSiNljTTafhpgB9cj9nWDONEHbbBmnoiqDp2ijM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111853; c=relaxed/simple;
	bh=GjOgOGb5ohY8X0O8eKDg9ZQiF3551C20ZU8wIPKNtko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5GtHuZ5Vnr0tiqg/K51PRYVPI4VRso2GYY2xqAYCzeTsdwjU+iwDDnTxt0ZtHR2nvYoQeCVNoWd/OkHKjmTkp/dBSvJFn0znb8SqBETOo6G56p3P1XJMPpFiGpeKOSBroqJDa1mUPwwomVCW5CYjTP/k0qwfrhN9Y6lyRxYDbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiSgwYFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiSgwYFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2A1C4CEE5;
	Tue,  8 Apr 2025 11:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111852;
	bh=GjOgOGb5ohY8X0O8eKDg9ZQiF3551C20ZU8wIPKNtko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiSgwYFQSegVvgP5bF0ul2N1+4U/lyf20cEDZUCIP3ApZnTSlv1Vp2jXT69kYp8tl
	 U7ulH/SjYiPsGU/4OyDXWwPDNpulIR21j9vEtsjK3mg+ktpn25bBHXswYsmzCj0lhh
	 p/qMy/Sev5DVUvsDlAiXukXf5UPmXmiFJn+9vPWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 583/731] riscv: Fix missing __free_pages() in check_vector_unaligned_access()
Date: Tue,  8 Apr 2025 12:48:00 +0200
Message-ID: <20250408104927.833752515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 33981b1c4e499021421686dcfa7b3d23a430d00e ]

The locally allocated pages are never freed up, so add the corresponding
__free_pages().

Fixes: e7c9d66e313b ("RISC-V: Report vector unaligned access speed hwprobe")
Link: https://lore.kernel.org/r/20250228090613.345309-1-alexghiti@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/unaligned_access_speed.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 91f189cf16113..074ac4abd023e 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -349,7 +349,7 @@ static void check_vector_unaligned_access(struct work_struct *work __always_unus
 		pr_warn("cpu%d: rdtime lacks granularity needed to measure unaligned vector access speed\n",
 			cpu);
 
-		return;
+		goto free;
 	}
 
 	if (word_cycles < byte_cycles)
@@ -363,6 +363,9 @@ static void check_vector_unaligned_access(struct work_struct *work __always_unus
 		(speed ==  RISCV_HWPROBE_MISALIGNED_VECTOR_FAST) ? "fast" : "slow");
 
 	per_cpu(vector_misaligned_access, cpu) = speed;
+
+free:
+	__free_pages(page, MISALIGNED_BUFFER_ORDER);
 }
 
 static int riscv_online_cpu_vec(unsigned int cpu)
-- 
2.39.5



