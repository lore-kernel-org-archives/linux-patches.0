Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC00158525;
	Mon,  6 Jan 2025 15:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178210; cv=none; b=TFYQVfRDzIPMprgiB7I/Ok3mYuf3E5/wstVufadoMRQo4c6eZIdVqTw7Qz2Du+Tu+LJwz22vqMQWLnV6t2IbUNjF2qdjyQXlgyH29Ue4Y7kyWpEIddMzw8yTyi97lv2T+n4UBORdZMqRljjYAnWnevjuvP5fOeY6skr2PjPLMAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178210; c=relaxed/simple;
	bh=WablwB7XB82Gi+bkEs/g4jbht9WrsRItcOiHFOM7WZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW033HA5zW1HWht//FUbYu4WlRaCiAfFT+HtsBOfigYKs5/ha9BZ3/4BP5ZDZvU/X5kj+Ri2PEfmc85PeQnVEk0yDQSYFZFTaFIWP6k64WArsHboYuepZXDTLgXjdCxGLKqekOHFEFc8iFeR4l65gL3Ae1g7i68JxSTti3cbbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AS5RGZQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AS5RGZQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446FDC4CED2;
	Mon,  6 Jan 2025 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178208;
	bh=WablwB7XB82Gi+bkEs/g4jbht9WrsRItcOiHFOM7WZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS5RGZQ5EdS8cbRcRK7EBMm72fpc/V0ds7SC8Hxja+k1jTOD8MvNw/jzt117H2J/6
	 Kgu+XePTupb1eRu1RtWwzagGi4r0gNHfADazbsyTtPNL95KzcrjzNCyISPoTI+fZLK
	 +6NK2iWtWpncIFMUwmVOn79vp5MQK70i5iFpb8x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 041/138] of: Fix refcount leakage for OF node returned by __of_get_dma_parent()
Date: Mon,  6 Jan 2025 16:16:05 +0100
Message-ID: <20250106151134.789289458@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 5d009e024056ded20c5bb1583146b833b23bbd5a upstream.

__of_get_dma_parent() returns OF device node @args.np, but the node's
refcount is increased twice, by both of_parse_phandle_with_args() and
of_node_get(), so causes refcount leakage for the node.

Fix by directly returning the node got by of_parse_phandle_with_args().

Fixes: f83a6e5dea6c ("of: address: Add support for the parent DMA bus")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241206-of_core_fix-v1-4-dc28ed56bec3@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -641,7 +641,7 @@ static struct device_node *__of_get_dma_
 	if (ret < 0)
 		return of_get_parent(np);
 
-	return of_node_get(args.np);
+	return args.np;
 }
 
 static struct device_node *of_get_next_dma_parent(struct device_node *np)


