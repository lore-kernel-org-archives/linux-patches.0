Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4891932C317;
	Mon, 27 Oct 2025 19:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592514; cv=none; b=X7ujKeKGdLPllOZ6JqUL2AvICLkNo+YcXZ2CUUpWPvfEk6qtMwEnd175leIm1OWrh2YJvmo2GjDBOm3tNUqX2DnC6UhL9iV+w/ar6ubidXni9KDI+GOgi9YV8nkrNDDKnO7ZdmQCqLd570uYRmFf7EqzCIAwX51T59YkiFgu92w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592514; c=relaxed/simple;
	bh=77znN9lyQamIEKhurRcn3b4mYIOb5CmGGP2b0xZmlVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIt/eKkpn7Lbyd1Tg4l2ULkXJ09PAE+BtB42Z017Wwow1yiwoShOnd5bk+doIouTT865w74MW46VPWeqkldvuKB+43pL1s/P3LEw+BMAwRzlB7e2Vqr0VzTUBGg5yH8RW47AgPb+snTUe6Bkty5a1K7pWCXYpvwI+RLTNUyKwUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oyy32SCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oyy32SCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD72C4CEF1;
	Mon, 27 Oct 2025 19:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592512;
	bh=77znN9lyQamIEKhurRcn3b4mYIOb5CmGGP2b0xZmlVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oyy32SCe+mlgfNHy0IgX76IWuz6vfs5zCt3HXvA8Gq+BJkK+n7797uMCnbPeHgpuQ
	 /BsWqzkEGCPciLkBFmq0kVywPU0rFber1lO2zM0B8CVdf1I242oPFYLFo6eaoicLyQ
	 1cu8QoXy2OzJHl4Z4aRt08K9AWeUIr3rKnKZ4TpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/157] arch_topology: Fix incorrect error check in topology_parse_cpu_capacity()
Date: Mon, 27 Oct 2025 19:36:49 +0100
Message-ID: <20251027183505.260718386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 2eead19334516c8e9927c11b448fbe512b1f18a1 ]

Fix incorrect use of PTR_ERR_OR_ZERO() in topology_parse_cpu_capacity()
which causes the code to proceed with NULL clock pointers. The current
logic uses !PTR_ERR_OR_ZERO(cpu_clk) which evaluates to true for both
valid pointers and NULL, leading to potential NULL pointer dereference
in clk_get_rate().

Per include/linux/err.h documentation, PTR_ERR_OR_ZERO(ptr) returns:
"The error code within @ptr if it is an error pointer; 0 otherwise."

This means PTR_ERR_OR_ZERO() returns 0 for both valid pointers AND NULL
pointers. Therefore !PTR_ERR_OR_ZERO(cpu_clk) evaluates to true (proceed)
when cpu_clk is either valid or NULL, causing clk_get_rate(NULL) to be
called when of_clk_get() returns NULL.

Replace with !IS_ERR_OR_NULL(cpu_clk) which only proceeds for valid
pointers, preventing potential NULL pointer dereference in clk_get_rate().

Cc: stable <stable@kernel.org>
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Fixes: b8fe128dad8f ("arch_topology: Adjust initial CPU capacities with current freq")
Link: https://patch.msgid.link/20250923174308.1771906-1-kaushlendra.kumar@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/arch_topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -327,7 +327,7 @@ bool __init topology_parse_cpu_capacity(
 		 * frequency (by keeping the initial freq_factor value).
 		 */
 		cpu_clk = of_clk_get(cpu_node, 0);
-		if (!PTR_ERR_OR_ZERO(cpu_clk)) {
+		if (!IS_ERR_OR_NULL(cpu_clk)) {
 			per_cpu(freq_factor, cpu) =
 				clk_get_rate(cpu_clk) / 1000;
 			clk_put(cpu_clk);


