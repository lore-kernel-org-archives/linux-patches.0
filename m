Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8744BA34;
	Mon,  6 Jan 2025 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178671; cv=none; b=VEQxIjST2jZAkz2wF1jL/q5aQ0oX4JZLOoVAtDE78g6e7ZUtlGoCMQqquvOVo1XUWvR3XDnsyztRC2gnW/zYAK+LN+QEPryJ01wLKissu6Zg/lPvwSVt8lG9e9fQvlT8vkk3jGF3SjAw1aTgEbTMk9ec6MuQ3htLwatSmhZef5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178671; c=relaxed/simple;
	bh=IF1daYkMHD46tgN319dkOetFhdjePRqR4AVhiSunFfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehSCM50eMGIa0wWrayOPE/zODqIzRLLf33kO/+VP9u4dAHfZrDGNmz27yY2XOwyf+NJUQPkBEoMMZC0qIq+TDelPzh6U1SDV2IMU4xnLkd0J328ileOf9obqZWMKBC5ygnSILFqwZ4ghIrlXPwlN+PHNbq6/0YEwt9rgPCJexBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OV7CmJJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OV7CmJJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE31C4CEE4;
	Mon,  6 Jan 2025 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178671;
	bh=IF1daYkMHD46tgN319dkOetFhdjePRqR4AVhiSunFfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OV7CmJJ3relehHEUdNJDzoYqaFBkRuGpPjHVWyUa1YXTWj5pjwXHMDLxnMsT8c+Et
	 iwhx+eH5z2eSaS3zxGnc+6LPhKhcItsqLNiDIWNxUuSwsS5EjW872zRUgtOuDcDcmM
	 Z2OgbycWSFYf+jM8Mg1BLHhvAoUbvjPu9Qg32t7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 053/168] of: Fix refcount leakage for OF node returned by __of_get_dma_parent()
Date: Mon,  6 Jan 2025 16:16:01 +0100
Message-ID: <20250106151140.466117558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -594,7 +594,7 @@ static struct device_node *__of_get_dma_
 	if (ret < 0)
 		return of_get_parent(np);
 
-	return of_node_get(args.np);
+	return args.np;
 }
 
 static struct device_node *of_get_next_dma_parent(struct device_node *np)


