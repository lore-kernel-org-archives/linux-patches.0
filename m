Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AE0296FA9;
	Mon, 12 May 2025 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073040; cv=none; b=YC9C1y9bUoq02jd+xiH1XB6PpdZlfo+MFBibp2aFSGCDlEEh00HTfQm3c2lV1njEkUWJ0KQYWQpEacCDMIE8rq3kEpYMbZG4izHyS/P4FpVfOiYwWOniZOzj4+EmNStAiyeYdN7qhwMn54yRUTG32vIsYFPz4Nb5ZSf9zz49JWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073040; c=relaxed/simple;
	bh=p/Z09czsGq2gi3IdwLjGuVW8WE8fiKek0J6/EseWBn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWkiswu22/9LNkbFm1zf0oYfX/I+RnNlv+k3kUuDwEf1CppJJHJ4OmVcwcVbn3pROicAgIhgAU/zGxgoi2ntkGdiw0hTivoii06M6uhdFc2rLkGLpWOxZRA4qMXHKJsTpBgnwJN1or2KyMmL/xwb0wUmmmU8vf8/7HzRsyDKBz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLPageqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLPageqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A4FC4CEE7;
	Mon, 12 May 2025 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073040;
	bh=p/Z09czsGq2gi3IdwLjGuVW8WE8fiKek0J6/EseWBn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLPageqapXQNeoTnu1mbnH7/AzzZbDqVXjdiFjSg09z4G7yRlV5BuFHeeVsJcaD8T
	 ASfcuEoMjBvndYXQJeG9En0N591cUK/g/eRg5fwp30hcDrDVCQNvYQUWZa7RMM3eE2
	 p44iDtf6qtp3K73zfn9Krv0kiCiCV/egIxqXG5ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Crivellari <marco.crivellari@suse.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/184] MIPS: Move r4k_wait() to .cpuidle.text section
Date: Mon, 12 May 2025 19:45:37 +0200
Message-ID: <20250512172047.351932848@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit b713f27e32d87c35737ec942dd6f5ed6b7475f48 ]

Fix missing .cpuidle.text section assignment for r4k_wait() to correct
backtracing with nmi_backtrace().

Fixes: 97c8580e85cf ("MIPS: Annotate cpu_wait implementations with __cpuidle")
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/genex.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 46d975d00298d..2cf312d9a3b09 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -104,6 +104,7 @@ handle_vcei:
 
 	__FINIT
 
+	.section .cpuidle.text,"ax"
 	/* Align to 32 bytes for the maximum idle interrupt region size. */
 	.align	5
 LEAF(r4k_wait)
-- 
2.39.5



