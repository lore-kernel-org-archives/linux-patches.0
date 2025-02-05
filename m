Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B7A1519B4;
	Wed,  5 Feb 2025 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768411; cv=none; b=JNckOrlCq576oycgwYW9IssrNkQoyyWN+rktJMjMV6ZmG3sRxOkE9UJOILpTMT1dwYinpmAglc5aY+qr8ISFz03jZt23HQiRpchEAF545ceJGwsWhOF19agThs1vTixIsgZ8BrLCS7XpObzLLbkS8z5lmnOA5zCwJm9ClXG68yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768411; c=relaxed/simple;
	bh=EazvEnzGDVLkcbByGAPfabpcjyrfxKBsYiMQWZly7Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUqqb/OfoTbdPj6kMLiTu+GLZPwncKuZ1m0dpRKEpVoOYBuHzi/H0bQbCJ+C9IxdEg2TGlpdAevi/GiDkWnN9I9hkcLA0zLGBLF/Qq8C7Y6WwYJLPoQ6uzbxBDd7lbjPxN5juPaO84QuSV9iHPlRhOyRnigMPYyN7yv/ZsIZHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhJLzba0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhJLzba0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72F1C4CED1;
	Wed,  5 Feb 2025 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768411;
	bh=EazvEnzGDVLkcbByGAPfabpcjyrfxKBsYiMQWZly7Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhJLzba0YmabPl1V721lsc0V0uOjFQ3qNFou1lravyuIGHO71+dXCcI+EccDeKrxR
	 ktOAVjNFAj6VrVdV1xUPw4Z/hCnyulHO1sqcKY35bWKESpzvMEibKK/MYVqKzRoGM6
	 DaRx0ajJADQAjZF/O/kuSe7t/qni4Zjvu24mCKVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 576/590] of: reserved-memory: Warn for missing static reserved memory regions
Date: Wed,  5 Feb 2025 14:45:31 +0100
Message-ID: <20250205134517.303517224@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
@@ -214,6 +214,11 @@ void __init fdt_scan_reserved_mem_reg_no
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
 


