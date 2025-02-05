Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A915198D;
	Wed,  5 Feb 2025 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764121; cv=none; b=FBrReJoFUlrwPtTS+ucuNtg8slh4yJIFMaUDUaQuYlMkk/q0EN6XO6PNhgkRy2qxBYNeQxjtj1U9AGWea56IDlmdfBJGQLq+Gtsvl8b/5cwcXqIFe1cv2o7u+AP5OadPr+CcXrnvQJQGyDDDZg7tD8r3yQ8KunsIOyH+ggdC5oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764121; c=relaxed/simple;
	bh=d62vLzTxQm0S8L5lPKCyMfh1doMa5NbPvy9Iwf0BFGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj6HZpxJUOu+zRkpG6CZR4QYb5DT6/C6+SEDXSwLnP2ZEa8WtDOEfbtGGla/KCTpOlFXZ0GlzbXKABjDIqVBKaRs9kPKQyiiJBYlsH6v7SN/XjEzgZq6KdGo5HOG5+XriZEUwBRH/QSG8MEXY2CW/m4bS3Rm9zch84Yx6WA2CEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaM0ssOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaM0ssOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A05FC4CED1;
	Wed,  5 Feb 2025 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764120;
	bh=d62vLzTxQm0S8L5lPKCyMfh1doMa5NbPvy9Iwf0BFGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaM0ssOr+F0KJjLOuis0j4F7ZlLKuzkLiZLcA2ZVOe5f2yVC37stM3fhIYdEzd02r
	 Oqeg+/E0oMBjv8sG7dJBlENCQ8EeYYK7N+RQop/it/FE6V2RXz+WP4sRbBN+qVeORi
	 4dvxC2et/bf+XhLaH+KxZy5X/UucwLiE6EiLDVaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/590] clk: fix an OF node reference leak in of_clk_get_parent_name()
Date: Wed,  5 Feb 2025 14:37:26 +0100
Message-ID: <20250205134458.733940174@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 28fa3291cad1c201967ef93edc6e7f8ccc9afbc0 ]

Current implementation of of_clk_get_parent_name() leaks an OF node
reference on error path. Add a of_node_put() call before returning an
error.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 8da411cc1964 ("clk: let of_clk_get_parent_name() fail for invalid clock-indices")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/20241210130913.3615205-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index d02451f951cf0..5b4ab94193c2b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5391,8 +5391,10 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
 		count++;
 	}
 	/* We went off the end of 'clock-indices' without finding it */
-	if (of_property_present(clkspec.np, "clock-indices") && !found)
+	if (of_property_present(clkspec.np, "clock-indices") && !found) {
+		of_node_put(clkspec.np);
 		return NULL;
+	}
 
 	if (of_property_read_string_index(clkspec.np, "clock-output-names",
 					  index,
-- 
2.39.5



