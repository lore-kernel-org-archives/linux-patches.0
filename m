Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EFD8827;
	Mon, 23 Dec 2024 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970806; cv=none; b=GStHkvVoq6dMaYsd8jva3WPicqDj2MR2YP4gCxy80gr2r6jl28u3muUZX0ab3w+RskVGQslEmZ3b8o2QRuoX9CraS7dvZT265YjsAGALWSHtYECsA3dSeU3/rXCWNFLJsztXjSXK5LWONCEzlIDckrLPeEU7tdaMam4utMc48s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970806; c=relaxed/simple;
	bh=/vunKaElvkw7RQNnJP15TRfUWJ4GHdXpXfn6B0fcfh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2KD8KdqosseUTqz5LdsiaDbMqUrtLn/OnBbmetlPi4cUb/pVdX5YiM66XfK4tnl3DdgXrBnCheCG1P4MJwzfXApwAGbDaPvCX6sZeVfKIQoNyfjkhRhtaNOaOngc4rgMrW6yfNOS1gEfxT3DNC7ZuPT53Gz4YuSgQwLyn0Gx2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksGn26y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksGn26y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A87EC4CED3;
	Mon, 23 Dec 2024 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970806;
	bh=/vunKaElvkw7RQNnJP15TRfUWJ4GHdXpXfn6B0fcfh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksGn26y0L4HeYGvC257uPILD4lWNBTdIpf5oWJFrWEXA/vjsQkAO+JklJ7UU2mYTN
	 NyG/D4tsqfa9nVIgGumlCzIfpHUAr4fmp67GAx8qXYASvsuPKy1/iebnHu8mXHpxID
	 uO0oE2Io7cnt4YlLkYBcHAmsXhIDDlw78w7zOEOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 75/83] of: Fix refcount leakage for OF node returned by __of_get_dma_parent()
Date: Mon, 23 Dec 2024 16:59:54 +0100
Message-ID: <20241223155356.544099805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -595,7 +595,7 @@ struct device_node *__of_get_dma_parent(
 	if (ret < 0)
 		return of_get_parent(np);
 
-	return of_node_get(args.np);
+	return args.np;
 }
 #endif
 


