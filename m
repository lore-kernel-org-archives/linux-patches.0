Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F8929B231;
	Mon, 12 May 2025 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073559; cv=none; b=D/g6essLA8U2cvquoxNZ9WDJTK1gCVQ3FTmaEQUvXbeuzKOk2RihlC7ihboDtsBKh6nMxhFwt0+l6+4MTzmLGVthuDYRhaGwEvxSkK9jP/A+FzA6ggwdjLr1E5FJK0V2xGyB40s5lVZZwEm0q32DFpTqB0NrANLtcj4ecV5KdWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073559; c=relaxed/simple;
	bh=afG8tlM186MFOAFOmzSJHgot7Nehi2KluHpZG6BH8kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKNVLV5ATx0furp7HizFAmSE89R8DsT7YsrI3xIrlm0rHRhfvB7vAniUrNSTC1vD/IdcDrkWGlSd9Kk00aqsiG9bSRQe3DdlEJz5zJHaPAXYGm9gSLA2gYNRjV9QXkglKu+UP6LO5s27eySZzfxeYvYIY2lUlG7DF9I0aOe9S2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOaBM42p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOaBM42p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641F2C4CEE7;
	Mon, 12 May 2025 18:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073558;
	bh=afG8tlM186MFOAFOmzSJHgot7Nehi2KluHpZG6BH8kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOaBM42pxfHXM2MGNDzjY2clbvcRH//hD16cYH3eHhZT3OpsBs81BTclFKm0XeGyJ
	 xnFIqkGdAkO8VM3MTJlh/JyFgfyT3cEcxGyYzvIo0+3v5q9pOd2AOUlHyvlebDiVnZ
	 JAG6UU7Bl8C2lo+sCilyTZ6CR3cFynbAGfFAZgKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Crivellari <marco.crivellari@suse.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/113] MIPS: Move r4k_wait() to .cpuidle.text section
Date: Mon, 12 May 2025 19:46:14 +0200
Message-ID: <20250512172031.143637157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 488275e4566d4..f4cf3fcd337e1 100644
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



