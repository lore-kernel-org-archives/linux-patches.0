Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE3626B088;
	Thu, 13 Feb 2025 15:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459280; cv=none; b=F3nd/r2oawQaK0NKeP010fRNbr3T9JE8mxAT3P5SalQX3gURD251DYc5LTtrgq81gdb13FcEEOpCcSSWaVBirqaevc2EwBa9hrfOCHs7Gyy+FHBmjAZG7Mj/WnQd+H8YkB0YSZuhQl48pP5hQXDLlWzIFzM+PLmBRMnPA3Qq43E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459280; c=relaxed/simple;
	bh=1CNVyTvAw4hW76nfnipVBPjPw5OvWI6Dzf0i1r7YyHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ee9Thx2kaB9QqA+5kHKlk7EzgSGak7Zy+CHoYCJFH99/2QiGv15FCzzp9ZG+V6iuT2XeplrSBUTIaiOeuXw0hxFehZ5vNCq3F6VEL6xaqbB4gbNzk3TS41g/BDfG9CoNCFEE3EQcolUoDxniom1GIn7h9qzJ0vU2O4xUKWMjNQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMGMrTJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMGMrTJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70FC4CED1;
	Thu, 13 Feb 2025 15:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459280;
	bh=1CNVyTvAw4hW76nfnipVBPjPw5OvWI6Dzf0i1r7YyHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMGMrTJ6Jow3drsVbmqlLrUKJrO0vqOjsk/sjAIvlJNyMpMjVeKP32IAf2OzWuo8j
	 xNZQrpsWUo8OsfMBdYdoOaaabnPcLsis/QEjApQglmSJcAtmSyRqNPL8DID1qdHgF2
	 wVSSh8P8MU/tAL5xvKlWuwPaFVPh4oCKRHRXN9Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.13 219/443] of: reserved-memory: Warn for missing static reserved memory regions
Date: Thu, 13 Feb 2025 15:26:24 +0100
Message-ID: <20250213142449.064406916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 81dfedd5234b42df11a473eefe7328ea4a0416ad upstream.

For child node of /reserved-memory, its property 'reg' may contain
multiple regions, but fdt_scan_reserved_mem_reg_nodes() only takes
into account the first region, and miss remaining regions.

But there are no simple approach to fix it, so give user warning
message when miss remaining regions.

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20250114-of_core_fix-v5-2-b8bafd00a86f@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_reserved_mem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -263,6 +263,11 @@ void __init fdt_scan_reserved_mem_reg_no
 			       uname);
 			continue;
 		}
+
+		if (len > t_len)
+			pr_warn("%s() ignores %d regions in node '%s'\n",
+				__func__, len / t_len - 1, uname);
+
 		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 


