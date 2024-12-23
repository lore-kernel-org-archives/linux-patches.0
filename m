Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A66913BC0C;
	Mon, 23 Dec 2024 16:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970166; cv=none; b=GazG+2aV7HQABIPFZ+VkY6vBDO9WT2JbVPiIXJ+3z7Gb39E/6C0zeJIu6w/rK+1gryM9kmy/LRQ6d8W4CSnqwMyBKCoGCIxKjWKWWytNYw++cTWoRo/j9xCBqXDmPaAAX56W61HkHVeH+VAr0gW9ZPhwwIUyfvOboqJL7Gs1Mq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970166; c=relaxed/simple;
	bh=gaFTTgUJnDucW5Mx8DaHZOpv1YSgwuBNjT49GMMCigs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiAD9EMbA2z70xYBHLnhztHRmKpRhlBPaJRI+X6/y2VkF3ztdlHpip+pYG84IcYV5lJSK5G853CLh0P/zelXyXWpNBktwCaFehJePI7/k8mVzS85P5w34JjEOrOT2tws145u1NQpgAlbZyqDVRaLXVH744fUkMQRpm8t8I7r3PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKnioB2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKnioB2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3E7C4CED3;
	Mon, 23 Dec 2024 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970166;
	bh=gaFTTgUJnDucW5Mx8DaHZOpv1YSgwuBNjT49GMMCigs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKnioB2OegAx4894pcyFnse6SalcvJlhlwTPwXgrRvvOJxmUBBh+NQtvvktMQ6+K7
	 V23OqNKYZACEKGC/2lbTBOxSPmGAAdRG47bzD8K9kra0iPunRh95zyX1DfvtTGXCBO
	 JlSd4Nt4cTWhdp38BG96s1D2UTa83bxvjA9E8otE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 150/160] of: Fix refcount leakage for OF node returned by __of_get_dma_parent()
Date: Mon, 23 Dec 2024 16:59:21 +0100
Message-ID: <20241223155414.608028005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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
@@ -616,7 +616,7 @@ struct device_node *__of_get_dma_parent(
 	if (ret < 0)
 		return of_get_parent(np);
 
-	return of_node_get(args.np);
+	return args.np;
 }
 #endif
 


