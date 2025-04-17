Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FF5253340;
	Thu, 17 Apr 2025 18:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916144; cv=none; b=swCxoTBvpqLjBpJtEsTqtywYWElSMMAf6UY0mLLuvO9JyvUJE7mCOVPEpJwRwQjzvNuQPMawRyK76ZkQ2zFHpWr1dHSO24Jo94Yr50yIB1XwNZztCjBoW7ACrnoh1kQDr9PchibMmW1v9X8oVLf5ARJUL7K0Zgxxr3tVrwzrops=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916144; c=relaxed/simple;
	bh=SQzeFEf9e2LkEMC/Z5hPcHQB7bpf2ZzUlqSnLxn9nRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOHWn7Fh2rGWH31LpCJTFHueqUanxT+4U4OAHudHuhcUmpyvi5fuidtEV5mWb+uE0e2AFDFODQE/4ZJQ8P/WJA71zPGbaO15lwxLNBBjpOiJiBDKCj7XR0ljWqyrrloaEm8gXg5xMl/RfJHQGo98Ewo9hVGmJHUarRvu8ktmDgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2+hJWSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2+hJWSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAED8C4CEE4;
	Thu, 17 Apr 2025 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916144;
	bh=SQzeFEf9e2LkEMC/Z5hPcHQB7bpf2ZzUlqSnLxn9nRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2+hJWSKRgBcFSCh2Y/DBDChMdF+70bAvRvc9a5w60EMVHbcE8AL4jvHw0jvik/Du
	 anRDEjlaBUBg4yqvA0fy5lHaq5yLI11lji/7Mhev2FAtHd6y/X4hQNfzL27EYyTtww
	 xIcol1xqhj2PP49csgImJ1oEeHuFLMuQQwz9d8QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 358/393] of/irq: Fix device node refcount leakage in API of_irq_parse_raw()
Date: Thu, 17 Apr 2025 19:52:47 +0200
Message-ID: <20250417175121.998087326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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


