Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD03CFC0B;
	Wed,  5 Feb 2025 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763598; cv=none; b=XL0cmi6OjXj5tr+hEKEP91QZtXNS7CfRcXK3o1+u0yvrHkoeXIrPofw9vy7ZBg6q4X2gtXJFh7WYeQTugHgsYKMKvxL5mKu19M501SsNyM/VO9T3GVNMnOuhez+mJf/+qR/0h9VEwsOb5c4PzwZuHhYPFGLKT9TBczIcrKhTerM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763598; c=relaxed/simple;
	bh=l9daNHC8NVXBnQLvIy7NnX7MsoiwaGw7BkXXb8JAc8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gioCI7RluuC9lf3nzUoYjDue6IG6ZYLBbNqBytDxVK/vVFdsE0TYfP7AaB1aRqsHyKXh0nAvobh2us6e+da+M1tLvMW1H5ErC82Bt6QGEWcA4HSXpxBAl822/AXHJSuTb+ix1AjCc+28o+wKzO5qtFJb2/MJFmGvBIUgh9Fn1B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhErT/hZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhErT/hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D467C4CED1;
	Wed,  5 Feb 2025 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763598;
	bh=l9daNHC8NVXBnQLvIy7NnX7MsoiwaGw7BkXXb8JAc8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhErT/hZgp08B3YaSFu9od+1NDuxvvMFQfDmbWugwHwVuPHGLZejXI3+gxZyDETtH
	 354ggggKY/vejWMAwXEvtWRQ19AS22uurpZpydZEnIFEsWCnA6YZOIw3Ftdy9q6Tkm
	 oKRP476TGEoVgLqUyoyoaEEjZHV11VI6FQBMHI5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/393] clk: fix an OF node reference leak in of_clk_get_parent_name()
Date: Wed,  5 Feb 2025 14:39:43 +0100
Message-ID: <20250205134422.747167947@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index f795773b322a3..5bbd036f5295f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -5343,8 +5343,10 @@ const char *of_clk_get_parent_name(const struct device_node *np, int index)
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



