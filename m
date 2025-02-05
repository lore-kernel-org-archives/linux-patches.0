Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBDB2AD22;
	Wed,  5 Feb 2025 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764930; cv=none; b=ba/k/ngxTchtnd8ac6Zz8DrEx9xnYVAM4hFMQJja9rsn8FaPciVv9H3ZXvRByR0RTGf2dfo3RpJS7muhC32mwhBKqQ15p303XOE+tAQT52q1byhJT79xpAIve35n4/c0MhOwDz6S02242QRZFWphR+PhrvZMVWp/HmqN4zhBAZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764930; c=relaxed/simple;
	bh=T3JpHSrqpJUHHqgszCmE0Bm2arH1ChUaQldn42eq0fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx/3oIjC6dw1ci7awNEdkko3LnB5CnGPvEsLyrVGarGaP8FR/11KmQfIS7x/5Q4EP8VwgRVQHd7RyvtIYGxJ1L8wCbvNz4U7ijOv2KrJLCACGr7Kl9tJKa211XxHLHQVoYOr8Q5XLPigQCV52gWfvsElx1qx0kBQ6z6ndE2+LBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvJT8+Y6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvJT8+Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2157CC4CED1;
	Wed,  5 Feb 2025 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764929;
	bh=T3JpHSrqpJUHHqgszCmE0Bm2arH1ChUaQldn42eq0fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvJT8+Y6k6qGwu/QA+JH1bwtp0KIqpSw67Las3Nw84a1uwut4yM4zXSmw5slO1bZC
	 vDPACwCm9pTXOGqyDDBlnmE8I3KJuN2t+WV3AtribLTirtMX47HhE7rmLfL0FvqT2z
	 47V0bx4AcwWDlUhnymguCEy7qJ9PQ4QJtDhTkp+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 102/623] clk: fix an OF node reference leak in of_clk_get_parent_name()
Date: Wed,  5 Feb 2025 14:37:24 +0100
Message-ID: <20250205134500.119773591@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 9b45fa005030f..cf7720b9172ff 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5385,8 +5385,10 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
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



