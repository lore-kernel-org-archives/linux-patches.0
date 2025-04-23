Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1922D2980C5;
	Wed, 23 Apr 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421661; cv=none; b=gnXNjIqe1L6uttioI0//ZRwlKqhI/SvaAalzgXuR2QxYbqHGx3hu7LHDmzD/p5s6+hTibYisY79p5ICwgucDc5CHDcx4MqGSY+/Y/j0FEdHuAHvAUWfFjUwYJeMAQTtQs2i+9JPEJrFoCIhjXAXUgI+wQcKbMxK2p1CrLUOytkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421661; c=relaxed/simple;
	bh=9BOvzPXvxNTyv7vxJTdmr7f7bv9Tw/ZAgSvnfGxzUIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPBU5VbK6EEDmPUP2mvgIZ2ylyJh1+I4k85+dD2r2a+ckkXcCgTq9cM++caArW4YxIDo9nNBBdi9NmiW7uagLu4E6lus2Uki0TV1gNU9BQZfaBWPLSWdqVbkbHOe2AFgNj5tvTE/M056fHvlZ2uF5vCEojd3tdYMUTYFh0oHozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgYmqtzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgYmqtzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1296C4CEE2;
	Wed, 23 Apr 2025 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421661;
	bh=9BOvzPXvxNTyv7vxJTdmr7f7bv9Tw/ZAgSvnfGxzUIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgYmqtzlx3R7nyYR60ezZ6ykDwJ2OnsF/Wn8x2oLbXaA3u0A6vVNcgOT9ooNulNNj
	 +D99JUlC9Er1Ea2MYrGoPc5zU55aubMC9hv03nJdmUyfwQse/D0/oB5922BZpkodmY
	 rFEYztzqIy7fpX6NyDiwdNE1UcsvD+E67DxNuYFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 205/393] clk: qcom: gdsc: Release pm subdomains in reverse add order
Date: Wed, 23 Apr 2025 16:41:41 +0200
Message-ID: <20250423142651.853408844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 0e6dfde439df0bb977cddd3cf7fff150a084a9bf upstream.

gdsc_unregister() should release subdomains in the reverse order to the
order in which those subdomains were added.

I've made this patch a standalone patch because it facilitates a subsequent
fix to stable.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250117-b4-linux-next-24-11-18-clock-multiple-power-domains-v10-1-13f2bb656dad@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -525,7 +525,7 @@ void gdsc_unregister(struct gdsc_desc *d
 	size_t num = desc->num;
 
 	/* Remove subdomains */
-	for (i = 0; i < num; i++) {
+	for (i = num - 1; i >= 0; i--) {
 		if (!scs[i])
 			continue;
 		if (scs[i]->parent)


