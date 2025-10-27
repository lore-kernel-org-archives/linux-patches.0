Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C42C3749;
	Mon, 27 Oct 2025 19:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592878; cv=none; b=c5GD00K1ZjBQhxl/ZdYXSFmotcrSJsIXY6CRKRnnELyOjRjzROPyKdZfILhllrO7xg2l+d7vgyNjPoOy+9y38M/tLuH28K9pbX6qcxXwvQDFIUlu6pyGnb7lCd0VHlVbNmo/G7TJN6m2BjtzATXIqceFNtSIFdwaPuftKL4YZuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592878; c=relaxed/simple;
	bh=jj7zBhKcSf0AAKiml90kbpWswvSE7nlU9iRTdrCGSws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHUAR8J/9OdATHWWEMfwsHm2DdL0/6yOeuE+yXtOUrlv4CTeSMbcVKdb2bWKGXUyWduSUICm6oucd+Lbcne8LgHyvPODGSGD08l+UMGqP97/+104AsFk3208R4b/YT9+u7NFQMXsf8dtT5j2JQ42p+bXxh9WigMVpoS0G2ExkEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrTz7zVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrTz7zVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFD9C4CEF1;
	Mon, 27 Oct 2025 19:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592878;
	bh=jj7zBhKcSf0AAKiml90kbpWswvSE7nlU9iRTdrCGSws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrTz7zVrwsTmyXufyWQ+uxE/1+6Gyh4iSKU63LzsmPuZW5wnElG3ex0yDLGg00exK
	 XaGs+VmawhNtZi+GZO4fjuwt8918uWD/pEbT0xOiQOUIKaR7SfMb/I8+TmAAu7GxUe
	 PPWmLQ3eVsTpPGlf5pFLx00qmRH0zLYB/1Ax3Yac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.12 047/117] arch_topology: Fix incorrect error check in topology_parse_cpu_capacity()
Date: Mon, 27 Oct 2025 19:36:13 +0100
Message-ID: <20251027183455.266119807@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

commit 2eead19334516c8e9927c11b448fbe512b1f18a1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/arch_topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -341,7 +341,7 @@ bool __init topology_parse_cpu_capacity(
 		 * frequency (by keeping the initial capacity_freq_ref value).
 		 */
 		cpu_clk = of_clk_get(cpu_node, 0);
-		if (!PTR_ERR_OR_ZERO(cpu_clk)) {
+		if (!IS_ERR_OR_NULL(cpu_clk)) {
 			per_cpu(capacity_freq_ref, cpu) =
 				clk_get_rate(cpu_clk) / HZ_PER_KHZ;
 			clk_put(cpu_clk);


