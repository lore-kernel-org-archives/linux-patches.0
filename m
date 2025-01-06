Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0B314A617;
	Mon,  6 Jan 2025 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179114; cv=none; b=YUn0VbIKFqgv8Q8oKV6ULAZvg6gNjAvTJe2Ya1+BMgGj0o5DSWeDtG3f4Or0TZX8StELsectrW7b18TFgA4wsddFr1adBGqzTQOd6YHA2mClr51At74x/8/gnNVa4egBSeBx4JZcbGjhh+5Da3wW4NQbAIZZgKyTxKFajDrBcpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179114; c=relaxed/simple;
	bh=IXpEwY+W9QqbqL+Pc+wozfbK5hbpy3LGwr5sZC/2pek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el3ui26z65eS6umXJSef2Rvo3E2AtFWI/p1IhChoC9L1/txbbS1VqnNt8isEcideP9I2cnZO+R8tfizNRjBruF+9urTYPXa7+cPZAM9pp1bHxhTuBxEFagrFnXna5eAwl/c7izUPZPjOyzPFWKgRsxxBnt1VslX7tlCRdyxxJ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhiNQIQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhiNQIQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F90C4CED2;
	Mon,  6 Jan 2025 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179114;
	bh=IXpEwY+W9QqbqL+Pc+wozfbK5hbpy3LGwr5sZC/2pek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhiNQIQWespY1UYQ094/8KYbjiB2zQXN39+gBoc7rXUGPSDS1TTB1wK7ZtMQvV1xC
	 zhQBiAIYD5rChWu9qWGajpTn3viMBYoE27sLZTGpeplXELZqCn7W2UmZZ2/s+P14Or
	 iESAvQwNp+SivZEoQX2IMEH054hakfs896P5ZhOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 32/93] of: Fix refcount leakage for OF node returned by __of_get_dma_parent()
Date: Mon,  6 Jan 2025 16:17:08 +0100
Message-ID: <20250106151129.916579709@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -692,7 +692,7 @@ static struct device_node *__of_get_dma_
 	if (ret < 0)
 		return of_get_parent(np);
 
-	return of_node_get(args.np);
+	return args.np;
 }
 
 u64 of_translate_dma_address(struct device_node *dev, const __be32 *in_addr)


