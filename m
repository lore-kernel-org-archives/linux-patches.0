Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D100C1CAA95;
	Wed, 19 Feb 2025 09:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956548; cv=none; b=jWK6xWMRS4tlhY/l3+Sz059MFTdUAC1NGH+QUx8eFvgSkB9BfJ6f/l1Moa4aIH47333Dr4bfYQpXl4EDG+aJbZRxlOgXyPm/U+tLS+vWlyyBRpjVscsnBRvM+td2krXFrSIa+cQZr1gV+d+jccs0R+9yIdMxixXfDNuEZpoS1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956548; c=relaxed/simple;
	bh=+AG2m8uNKnxoov0/J1CpnIS+1dRRSAUtoZpt8fY1K0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3HfMEC1yEe/UXpCze14PN8cNvz3HWiNttidwyF7/JsIT+8k0j97/eavWFs+83iGdRTs0u26932Rsm5fhj93V5X4QrlbMLluI9FssZbv5P84Lkq98n2PFeiR4e+6fs6HRVjWr1830UtYZmJaxrUcmWdGCPwSxHerkHyBp2OorZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8Jeoc4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8Jeoc4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E4BC4CEE6;
	Wed, 19 Feb 2025 09:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956548;
	bh=+AG2m8uNKnxoov0/J1CpnIS+1dRRSAUtoZpt8fY1K0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8Jeoc4idZWAlRK9qjH+gXsU7QVFigwSnxp3x6+hOdZLixVGya0ueIxtmmhbqgRRT
	 n/0dS2SbnqnSCV59qktYDQvWBZtYK9jrK/cV5RQ/O5Sk9lB0y6PLQPeR08iQNtlEV6
	 e+kwDXhJfudI3Kv7SL4CrFcXpI3zR0UpGAlJ4OWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/578] of: reserved-memory: Do not make kmemleak ignore freed address
Date: Wed, 19 Feb 2025 09:23:08 +0100
Message-ID: <20250219082700.199827343@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 29091a52562bca4d6e678dd8f0085dac119d6a21 ]

early_init_dt_alloc_reserved_memory_arch() will free address @base when
suffers memblock_mark_nomap() error, but it still makes kmemleak ignore
the freed address @base via kmemleak_ignore_phys().

That is unnecessary, besides, also causes unnecessary warning messages:

kmemleak_ignore_phys()
 -> make_black_object()
    -> paint_ptr()
       -> kmemleak_warn() // warning message here.

Fix by avoiding kmemleak_ignore_phys() when suffer the error.

Fixes: 658aafc8139c ("memblock: exclude MEMBLOCK_NOMAP regions from kmemleak")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-10-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index f90975e004469..5a5d24eeb5f34 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -50,7 +50,8 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 			memblock_phys_free(base, size);
 	}
 
-	kmemleak_ignore_phys(base);
+	if (!err)
+		kmemleak_ignore_phys(base);
 
 	return err;
 }
-- 
2.39.5



