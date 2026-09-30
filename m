Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C72E4CA784;
	Wed, 30 Sep 2026 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787204; cv=none; b=kmgZ0GFWu3yMRs4xG2gt3wNderE9VYQFmayvf3w/7K9kGrhbQe0GUXt5e7mxotZnQjC6pmdjqMKLmMZ1LJBsRr+DrVkW0Y7Vb9IkM0RJo39S92VWEWDVtTzNM4YEs0S8xPd4enS4OM4H+T7TKDdt+Sk7tMXWwmDX8hPNBIbi9ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787204; c=relaxed/simple;
	bh=YMVUd/XKcfaZQSHVuUCjo4te/hAFZt6XYFHahT3mopU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSwdKa1E+taaSYGIa2oWu59N0M7r85NYjjKgbGzpE9BwcgMY556e3xRmBlkPafjJ7m86YugqfNKJBrcQ0PQyyFIQhK5vBHHk3lpS2sn3nqkVQa6xxcDgpUtdYRZ7mZFvIupuJ2xT+nVhT3tyCdhSO5xdOr3qSkN8OlOIwhr98T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seN6YFkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seN6YFkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB991F000FF;
	Wed, 30 Sep 2026 16:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787203;
	bh=Df7g21wz+9+re/I2/e7k+58UxbQnCZ5piK/t13OSQ20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seN6YFkDa0VOnBihKgNPOG/X3aePXzzbMib5NO4zks660r8RfF+a3amYjm1n/U7Y2
	 G+9yYm2FbQvYaovmP5rLkqqgc2+5PpmSD1iwsQAOMRY2f9Koj7BdVd/Ng1/DQDmeTo
	 vLboNfds5KSFUHhGl5fY8XylqZEIrRFH4WlNWMVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coia Prant <coiaprant@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 146/457] net: pcs: xpcs: fix clock reference leak on xpcs_init_clks failure
Date: Wed, 30 Sep 2026 17:24:11 +0200
Message-ID: <20260930152349.204622390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coia Prant <coiaprant@gmail.com>

[ Upstream commit 9892d71cf0ce3ff3d4fed2d9a3968fd4feb1c918 ]

xpcs_init_clks() takes references with clk_bulk_get_optional() and then
enables them with clk_bulk_prepare_enable(). If the enable step fails,
the function returns without dropping the references.

xpcs_create() handles the failure through out_free_data, which calls
xpcs_free_data() but never xpcs_clear_clks(), so the clk references are
leaked.

Add the missing clk_bulk_put() on the enable failure path. The
prepare/enable side is already rolled back by
clk_bulk_prepare_enable() itself.

Fixes: f6bb3e9d98c2 ("net: pcs: xpcs: Add Synopsys DW xPCS platform device driver")
Signed-off-by: Coia Prant <coiaprant@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260919172021.2336748-1-coiaprant@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 0337e2bcc0125..b415b93d77c15 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1545,8 +1545,10 @@ static int xpcs_init_clks(struct dw_xpcs *xpcs)
 		return dev_err_probe(dev, ret, "Failed to get clocks\n");
 
 	ret = clk_bulk_prepare_enable(DW_XPCS_NUM_CLKS, xpcs->clks);
-	if (ret)
+	if (ret) {
+		clk_bulk_put(DW_XPCS_NUM_CLKS, xpcs->clks);
 		return dev_err_probe(dev, ret, "Failed to enable clocks\n");
+	}
 
 	return 0;
 }
-- 
2.53.0



