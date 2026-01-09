Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703B235C1AE;
	Fri,  9 Jan 2026 12:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962995; cv=none; b=kcOfB0fZEYNEeeCpygeJGZgA3i3m6eXzcCWXWp8rjlKVjpPP45mojWJQH/ikrvcNBbOub5GjpdiPraXuzqeVV+twfvi3+rgipkT7RLjCYdfVp2p7VjjmgUY1iAAz1DxMapbVBbwXPnnHK0gWOJU64lXZ4tuyJb29DdZ4BZ3LQrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962995; c=relaxed/simple;
	bh=/9VL1ZNkA3lAfLjE39x1Ah0Cq2gjCc83pAe3erkgyfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmm70jvSgbryrYy7+g+R0O6/1NK1AY3nSEBh91o9wMqJskO3N9KkMh9cTx+utLunAO56dlqN2ke7IG3cZhql0OZhIuW8+Cb3m7dXrPsUdg8K/4glF1ucnPjND3lMBrcOGbp2r3XkX9UJ/lebG9JROtht3A5yGYYdL0AOo+I8FSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kF1+vP52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kF1+vP52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1817C19422;
	Fri,  9 Jan 2026 12:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962995;
	bh=/9VL1ZNkA3lAfLjE39x1Ah0Cq2gjCc83pAe3erkgyfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kF1+vP52FzhjhYRhmWpJJFhcMfG0604pV7npvF9TgypenSUaZ926RGFtbCp4cMsD4
	 lqAdfcMIx3V7nKTB99A3N2JsfIhONIvsI3koxmPgE3or9TnkhiD7IKzz8gKG1OglHh
	 rFYnyLANQTiMdqD88WH3gsqT8FUin1iWwfa2cVXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Chen Yu <xnguchen@sina.cn>
Subject: [PATCH 6.1 528/634] net: dsa: sja1105: fix kasan out-of-bounds warning in sja1105_table_delete_entry()
Date: Fri,  9 Jan 2026 12:43:26 +0100
Message-ID: <20260109112137.434508105@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5f2b28b79d2d1946ee36ad8b3dc0066f73c90481 ]

There are actually 2 problems:
- deleting the last element doesn't require the memmove of elements
  [i + 1, end) over it. Actually, element i+1 is out of bounds.
- The memmove itself should move size - i - 1 elements, because the last
  element is out of bounds.

The out-of-bounds element still remains out of bounds after being
accessed, so the problem is only that we touch it, not that it becomes
in active use. But I suppose it can lead to issues if the out-of-bounds
element is part of an unmapped page.

Fixes: 6666cebc5e30 ("net: dsa: sja1105: Add support for VLAN operations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250318115716.2124395-4-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chen Yu <xnguchen@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_static_config.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -1921,8 +1921,10 @@ int sja1105_table_delete_entry(struct sj
 	if (i > table->entry_count)
 		return -ERANGE;
 
-	memmove(entries + i * entry_size, entries + (i + 1) * entry_size,
-		(table->entry_count - i) * entry_size);
+	if (i + 1 < table->entry_count) {
+		memmove(entries + i * entry_size, entries + (i + 1) * entry_size,
+			(table->entry_count - i - 1) * entry_size);
+	}
 
 	table->entry_count--;
 


