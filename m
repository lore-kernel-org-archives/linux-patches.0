Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4E02367DF;
	Wed, 23 Apr 2025 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421711; cv=none; b=HNOkJlj3vmLJCcODSnCn0sSpS7DbWBAKSh3FS2S/OV1wXG4gxZ1TpY3xdushz2wPWKwWn/qwq5Y+zG9u/8Dih/YRbmoQx2ZekZ0TvQKfON5ibfgvC9hR/y0ZpSlpbuOSXagcJ1TfsKi9ug90DctKEftNlb5p1gCl5GsYm4uW4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421711; c=relaxed/simple;
	bh=VgMwFkFiQUyOzGWL2JqPb/XCKm07RvoNXSaj8LAkna0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPN2eHcbyt8RjCJUd144TRy0rs7wxInBhq4TBR+yE9hsEV22dOj73xf9UfiH4yEenIMjMyYnMIXFkSUv3GFu/J5sz9XUekwQ43LDiyYK07kKsIdJnDEUt9umPpGh/EprmuS+sDk/BADT/SY4G13kJbo3IhvKQaimh+GaFa7LR5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPr/tVLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPr/tVLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62332C4CEE2;
	Wed, 23 Apr 2025 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421710;
	bh=VgMwFkFiQUyOzGWL2JqPb/XCKm07RvoNXSaj8LAkna0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPr/tVLiYh82ZD0GbcfNDScn2uSU19sL/opznMHtExbxdG/H3/O3oR4AzKFSVUZ3G
	 Tmj/nlTnnOwIkE549KPUWkK+5YXBxd9cC74MweIziwvwx5og7u8P+ydeBLRK1QaJFd
	 BmHiJrwqjjJYf9khl0C7mWjZ70gDweQ2qq5gDh9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 152/291] of/irq: Fix device node refcount leakage in API of_irq_parse_raw()
Date: Wed, 23 Apr 2025 16:42:21 +0200
Message-ID: <20250423142630.606381882@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

commit ff93e7213d6cc8d9a7b0bc64f70ed26094e168f3 upstream.

if the node @out_irq->np got by of_irq_parse_raw() is a combo node which
consists of both controller and nexus, namely, of_irq_parse_raw() returns
due to condition (@ipar == @newpar), then the node's refcount was increased
twice, hence causes refcount leakage.

Fix by putting @out_irq->np refcount before returning due to the condition.
Also add comments about refcount of node @out_irq->np got by the API.

Fixes: 041284181226 ("of/irq: Allow matching of an interrupt-map local to an interrupt controller")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-4-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -166,6 +166,8 @@ const __be32 *of_irq_parse_imap_parent(c
  * the specifier for each map, and then returns the translated map.
  *
  * Return: 0 on success and a negative number on error
+ *
+ * Note: refcount of node @out_irq->np is increased by 1 on success.
  */
 int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 {
@@ -311,6 +313,12 @@ int of_irq_parse_raw(const __be32 *addr,
 		addrsize = (imap - match_array) - intsize;
 
 		if (ipar == newpar) {
+			/*
+			 * We got @ipar's refcount, but the refcount was
+			 * gotten again by of_irq_parse_imap_parent() via its
+			 * alias @newpar.
+			 */
+			of_node_put(ipar);
 			pr_debug("%pOF interrupt-map entry to self\n", ipar);
 			return 0;
 		}


