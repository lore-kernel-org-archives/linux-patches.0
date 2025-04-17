Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796E91E832C;
	Thu, 17 Apr 2025 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913688; cv=none; b=W0NoOtvr8Pzy8rhE9MfYPLKCX0qJz5IL5UFuBjj1KDJhBzYqmmth8eGqD/pmfCVpxGbRLEi+vb3awdinrMQIwT9v6pOm3PQPgYW1L95yNpXsGff5pUO6S5vAGtXfHjTdsz8uZN3cGMFhPx2UDB4n+dIATUTx8lGg+6Bet4OXFcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913688; c=relaxed/simple;
	bh=xYz4n43qOz4K1oP3Ko+6h8lTLO5yWw382HQFKQbMVZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkoTVtHo93o2FAfPWJjDZIposk4hWyIZiCOJHBQibMUmGg9ACBN7QQivBsZhn6TQndmWysRUFThct6yPtD0FJUrMURgTtIdh2Cmrqj97JyDfq7C+cCTF+UQTw3Q74kVdoKha4biDbgMpFzQxsfF2Mxi7e2kE7al6cNA3z5CW7JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HK/IMXAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HK/IMXAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C4EC4CEE4;
	Thu, 17 Apr 2025 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913688;
	bh=xYz4n43qOz4K1oP3Ko+6h8lTLO5yWw382HQFKQbMVZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HK/IMXArt3z7J0fC6VSobWwAeqy8DyKgIljswKU3OFOxKzS8st8fByUomhDd0ICX2
	 3dAwOzJmazTnuw9X9ombxTx9hhMuKpTC5OvaS/l6ozV0wO+JlXqnskxi1q6nzC7X2y
	 yCrUWChOiaKQIV0MeI4jfK1uEh8Db/T3I7XbRzI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.14 419/449] of/irq: Fix device node refcount leakage in API of_irq_parse_raw()
Date: Thu, 17 Apr 2025 19:51:47 +0200
Message-ID: <20250417175135.157483320@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


