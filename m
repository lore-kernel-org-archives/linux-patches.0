Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AA71DE2B5;
	Wed, 19 Feb 2025 09:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956543; cv=none; b=Z5kIxa73ppkiOkc345fxBnPygacYNhq7vV8PQQZHFDUMimAYBZ5dOTqpKmc0JcpoGjMHEopmx5Ouz+lPaSG5fwJqnkS4isKgu6VshIPgtTdDehPnORUgVUNclhM3vB8dkvdqv1ZK39CdPgSfoqqLx9fRHW+MNymRwjeRb4+WG14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956543; c=relaxed/simple;
	bh=5qUqspjFD12gUEd2Nu/w4bikEvIs+5B82XpXwky+zU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9Uw6U9UFy3MjoRr5rAw9huKvFiLkQZRcUwtd/9bJQpFkonaqsRg6LNRTPdb3YVu5ZcCZbPwBBiWqukEh0IAc8eqRRYBaRLO8/u3clVTP9jLnr40QTjVefoaeEWt0l220CRA59aH/fHi5SIxx4vB6rxE4xs9wJVkjUS03Po8sQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWqbpviJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWqbpviJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C6EC4CEE7;
	Wed, 19 Feb 2025 09:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956543;
	bh=5qUqspjFD12gUEd2Nu/w4bikEvIs+5B82XpXwky+zU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWqbpviJGK5y7Q8R6ZQ5Q/DrwP6YTwRLM74id63OCyt3FOeRORvm1eBSCXXtVqWA/
	 w7PGaBWUXfaNmukseY+imU2NktaqNJ4UpLz/d0GKfOD4WdAT5IBV6lN3zoIydc3hu7
	 ywMV+smLlFoXQrNs5yiDkBR0q/J1Pbg38c8yth1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/578] fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
Date: Wed, 19 Feb 2025 09:23:06 +0100
Message-ID: <20250219082700.124185946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit de124b61e179e690277116e6be512e4f422b5dd8 ]

dss_of_port_get_parent_device() leaks an OF node reference when i >= 2
and struct device_node *np is present. Since of_get_next_parent()
obtains a reference of the returned OF node, call of_node_put() before
returning NULL.

This was found by an experimental verifier that I am developing, and no
runtime test was able to be performed due to that lack of actual
devices.

Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dss-of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c b/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
index 0282d4eef139d..3b16c3342cb77 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss-of.c
@@ -102,6 +102,7 @@ struct device_node *dss_of_port_get_parent_device(struct device_node *port)
 		np = of_get_next_parent(np);
 	}
 
+	of_node_put(np);
 	return NULL;
 }
 
-- 
2.39.5



