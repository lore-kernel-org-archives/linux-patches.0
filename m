Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE057359F9C;
	Fri,  9 Jan 2026 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960533; cv=none; b=G/p0wRJlwk4owNJizucf0kZXth5e+S7SEe2Vh8QTuKBLnol6G5tzwXx7kl+KYAmESMb9ntdExHCyB4L2o6kNlncFRv7BsOjrGHVifx/KKHifr3U0XJrO8FcXnqMQrUIy9A9Kc4xIzqddmiqpLfT0EIurzjL+nZ6Y9wtxtMiS7sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960533; c=relaxed/simple;
	bh=paJMIcSNHTXcMRUbVAb63czW7zJ5nmKqL4BkPjYePGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMiVBE7uYSHezssl2/uLkeHNGFGCtXRYm6ijmzwAaeNJIrwRRQG/lrm469yXDzEZVQc7MoH4b3CjWiANUGS4VVorGXuTg/OWraAas9lTGfGpXiOqJBRMpAXe8ecylmsIIpMH4Rwg8WVuyuAwQQ3kWfdohK3Zx6ANF8/BvwK6L78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m92byjcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m92byjcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326BEC4CEF1;
	Fri,  9 Jan 2026 12:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960533;
	bh=paJMIcSNHTXcMRUbVAb63czW7zJ5nmKqL4BkPjYePGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m92byjcTr5OlE9Kd9x8ag5yBmkxY8lJFOLYf9NPtExZIAPpG3ZekSl/uuACgok9WD
	 ypC3D2+KW6nYA5/4e6xTUvJuqvBM7Y50uv8uPFxmuB+qQSVGA7ny4jdYGB+kC4G7Qi
	 UVfPpmXuqwSJat80dqtqmv2e5WvdTwB3AxyNWS1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 438/737] usb: dwc3: of-simple: fix clock resource leak in dwc3_of_simple_probe
Date: Fri,  9 Jan 2026 12:39:37 +0100
Message-ID: <20260109112150.467563348@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 3b4961313d31e200c9e974bb1536cdea217f78b5 upstream.

When clk_bulk_prepare_enable() fails, the error path jumps to
err_resetc_assert, skipping clk_bulk_put_all() and leaking the
clock references acquired by clk_bulk_get_all().

Add err_clk_put_all label to properly release clock resources
in all error paths.

Found via static analysis and code review.

Fixes: c0c61471ef86 ("usb: dwc3: of-simple: Convert to bulk clk API")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20251211064937.2360510-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-of-simple.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/dwc3-of-simple.c
+++ b/drivers/usb/dwc3/dwc3-of-simple.c
@@ -71,11 +71,11 @@ static int dwc3_of_simple_probe(struct p
 	simple->num_clocks = ret;
 	ret = clk_bulk_prepare_enable(simple->num_clocks, simple->clks);
 	if (ret)
-		goto err_resetc_assert;
+		goto err_clk_put_all;
 
 	ret = of_platform_populate(np, NULL, NULL, dev);
 	if (ret)
-		goto err_clk_put;
+		goto err_clk_disable;
 
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
@@ -83,8 +83,9 @@ static int dwc3_of_simple_probe(struct p
 
 	return 0;
 
-err_clk_put:
+err_clk_disable:
 	clk_bulk_disable_unprepare(simple->num_clocks, simple->clks);
+err_clk_put_all:
 	clk_bulk_put_all(simple->num_clocks, simple->clks);
 
 err_resetc_assert:


