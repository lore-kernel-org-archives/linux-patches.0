Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2323D5667;
	Mon,  4 May 2026 14:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903232; cv=none; b=vArOvegwcDxQT+ynMqVur9GjSmt0p7hEV/L6TczfNsoBiI69661sWfzXhV+6bDz8szO5mvlVijxa0BEu1HPaosnhPTB/B031YB4ieQ+eSg+c14WTHNKul5Xk41ZNPcdvcSu+DHvdQ9u8p24TlJeLbr//qkqoI2JX3RpkxcNnHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903232; c=relaxed/simple;
	bh=w8p4aIPkvv3tpB1oxPwOjy750NMthCHJXCg2oBPsptw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1QCSXsEzq/s2bpT1YId38CQrWzUBUqBJBB78baATdu/eFQ3e2Lzw5oZrKlo7dHQWNnzJ7e2SeyYk+4OGeiYx+0MTSfRvFEILwwQdUgT1JamRQH+AMFnH0B+XuDnlG9lultwOdLh/KJwVmYDDZ5pimDUpp6RyQMPwyPp7wyB1m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iu2oX310; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iu2oX310"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C06C2BCB8;
	Mon,  4 May 2026 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903231;
	bh=w8p4aIPkvv3tpB1oxPwOjy750NMthCHJXCg2oBPsptw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iu2oX310RsxCUQ8IczZsEechXjknKusaWKuHz6WkzWG5awzM+QLh8PEfXC6twlGoc
	 fnfdI0RcQmDbzw29Pv7K3MA/gwtSaXVP+bpfh9w3AMTx/Lekc4m4BK2Hmtjf5xJo7f
	 5RtyPKdgz+VFU+TvrSiD+ErNnKMRUa02XCCGmgCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 154/307] ipv4: icmp: validate reply type before using icmp_pointers
Date: Mon,  4 May 2026 15:50:39 +0200
Message-ID: <20260504135148.583557240@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruide Cao <caoruide123@gmail.com>

commit 67bf002a2d7387a6312138210d0bd06e3cf4879b upstream.

Extended echo replies use ICMP_EXT_ECHOREPLY as the outbound reply type.
That value is outside the range covered by icmp_pointers[], which only
describes the traditional ICMP types up to NR_ICMP_TYPES.

Avoid consulting icmp_pointers[] for reply types outside that range, and
use array_index_nospec() for the remaining in-range lookup. Normal ICMP
replies keep their existing behavior unchanged.

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0dace90c01a5978e829ca741ef684dbd7304ce62.1776628519.git.caoruide123@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -64,6 +64,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/fcntl.h>
+#include <linux/nospec.h>
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/inet.h>
@@ -373,7 +374,9 @@ static int icmp_glue_bits(void *from, ch
 				      to, len);
 
 	skb->csum = csum_block_add(skb->csum, csum, odd);
-	if (icmp_pointers[icmp_param->data.icmph.type].error)
+	if (icmp_param->data.icmph.type <= NR_ICMP_TYPES &&
+	    icmp_pointers[array_index_nospec(icmp_param->data.icmph.type,
+					     NR_ICMP_TYPES + 1)].error)
 		nf_ct_attach(skb, icmp_param->skb);
 	return 0;
 }


