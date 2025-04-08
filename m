Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13722268C41;
	Tue,  8 Apr 2025 11:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111873; cv=none; b=VxeOoqrDJcMia7qhyZdAVLTO5Aurx+57j56GqwNVg4s3dKdefz4sw0dm+bNOE/CTSUqeoBDKmyfxLq4oWkYdcnY1VwNHLy/iMS1WFc61nXkRqIMeAYaBZo+5msKFyEB0sCbiInEMM5T3DG/sUAN5FoocYC3XUg4bD439y/tWiOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111873; c=relaxed/simple;
	bh=6nCCFiD3CJ9ZWI3G+D1aYokP2+qcoWgQmkvLAHzIxwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7NbVQFqzTvb9c7mZHoiqumdAqD3+xLoarAdgKWLKeSqHz0Oy11zDuDzFCznsl5KG78x/R3v/viK9R7AMlWMy84bus1WUJXGdYxMpc3RQLrKqHhYSMRQzrydPNtQzA3D2bBr8VC4UJBvMq8YLqgJ3+klMZgfSbPe2lWsed33IYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYso/xY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYso/xY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CDEC4CEE5;
	Tue,  8 Apr 2025 11:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111872;
	bh=6nCCFiD3CJ9ZWI3G+D1aYokP2+qcoWgQmkvLAHzIxwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYso/xY1pZdzXnxDV1AosBr9gKTB03rr7BFQO1IJoVpqjo5X9lvJSXE4ES/ej7SxH
	 WUSvOxQh3Shp5UiDHQu0rjpLQkAoXazjsyQ3Q4k2zxVxbpRWrWi4VGeOWfP/LgA13g
	 V3mg2lt+1cPLIQP4OOTXMI//2Iqaj3qkup6OiJ6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 589/731] riscv: Fix riscv_online_cpu_vec
Date: Tue,  8 Apr 2025 12:48:06 +0200
Message-ID: <20250408104927.975337976@linuxfoundation.org>
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

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 5af72a818612332a11171b16f27a62ec0a0f91d7 ]

We shouldn't probe when we already know vector is unsupported and
we should probe when we see we don't yet know whether it's supported.
Furthermore, we should ensure we've set the access type to
unsupported when we don't have vector at all.

Fixes: e7c9d66e313b ("RISC-V: Report vector unaligned access speed hwprobe")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250304120014.143628-12-ajones@ventanamicro.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/unaligned_access_speed.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 85c868a8cee63..2e41b42498c76 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -370,10 +370,12 @@ static void check_vector_unaligned_access(struct work_struct *work __always_unus
 
 static int riscv_online_cpu_vec(unsigned int cpu)
 {
-	if (!has_vector())
+	if (!has_vector()) {
+		per_cpu(vector_misaligned_access, cpu) = RISCV_HWPROBE_MISALIGNED_VECTOR_UNSUPPORTED;
 		return 0;
+	}
 
-	if (per_cpu(vector_misaligned_access, cpu) != RISCV_HWPROBE_MISALIGNED_VECTOR_UNSUPPORTED)
+	if (per_cpu(vector_misaligned_access, cpu) != RISCV_HWPROBE_MISALIGNED_VECTOR_UNKNOWN)
 		return 0;
 
 	check_vector_unaligned_access_emulated(NULL);
-- 
2.39.5



