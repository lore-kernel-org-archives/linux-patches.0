Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369F12D542A;
	Mon, 27 Oct 2025 19:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592098; cv=none; b=oK6cAL3YUScYEoHfzvkxsBCLTX3KdRSukzCwnjKLrCYwMi0muuRCfFXqaydvoRIHxijLMK5URdlI05u4fmQIqRKgsBrh7oRLSvQD0i6wUOeGaNuYMo17v3OCKC4UNBRLaTin5KPQd269v4SNhDOOJdv6aSzQeAhDfEZpF1bsCgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592098; c=relaxed/simple;
	bh=jUhMoANh0l03YKhknf5DpDU3GrYHKp9TllH4an6OTNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpSJ8dZ0yUiqPu5hKoZ1j6w9y/hmB3F41g/UHAG0Vcfh0uYeBcHOjIAB3ECo7SDgZ+u+IqKKkNxLWt6oZTpQULILCgidPNRZYivbgJL+tV9ZPrdHHf+IuKiYC1S9IcMoJi6ae9TedhxImPGNb98YgLRgvPj/KpHM0+emNi57ryk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eajf2cgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eajf2cgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA92C4CEF1;
	Mon, 27 Oct 2025 19:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592098;
	bh=jUhMoANh0l03YKhknf5DpDU3GrYHKp9TllH4an6OTNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eajf2cgYkV4zBIzSXI360U3uixZ/s9oFeUQzoGizrwpx/XtYrO2JOiYacRh8gEbt3
	 GT4sG4HuHMpEi0arycKC8gGuDdPNPGqR8d1YHOEZOC36Z21E+vy/2/YMk1pAgzpPvB
	 /zMUGRrvRzdlqxnsy3CNuKc/xILvJbzsbCr7KR9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/123] arch_topology: Fix incorrect error check in topology_parse_cpu_capacity()
Date: Mon, 27 Oct 2025 19:36:36 +0100
Message-ID: <20251027183449.491500278@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -290,7 +290,7 @@ bool __init topology_parse_cpu_capacity(
 		 * frequency (by keeping the initial freq_factor value).
 		 */
 		cpu_clk = of_clk_get(cpu_node, 0);
-		if (!PTR_ERR_OR_ZERO(cpu_clk)) {
+		if (!IS_ERR_OR_NULL(cpu_clk)) {
 			per_cpu(freq_factor, cpu) =
 				clk_get_rate(cpu_clk) / 1000;
 			clk_put(cpu_clk);


