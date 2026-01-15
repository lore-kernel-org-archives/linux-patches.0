Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB693BC4D8;
	Thu, 15 Jan 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499556; cv=none; b=H/irwZWQP9A5v4ucHuEN8b3OwHw7mu0W/UWlSM/FfU7UN9WGv06XNmXPePhJVeeXUA56PfU3hVSVDlVU31W0VGtjuJOVV11+J+JXg0csnz78OPhd/WYHtYTvnX/hY7yrKp5pxYryxGy8gsED+nONLzC/6534e8NqnmYaCzHDiRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499556; c=relaxed/simple;
	bh=KzK91GU4c0TaLKduIY5jYHysScQCfseEXaKZU54idPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDMMsYCIMf8WsYYnA9tp2nkgdkLsVelfYlsgOaprL7AJUAWRXXTkvVT6HaQO6Ul87THTz3RNjjvuXr8XHhnjUrGlcGYjzReKO4kM/20w/cFrt4KV1VjF3WQZ0z620w4FKtnTdMDUwcovrvKZGKw7Xlrc5IVUbPwE25957QgqIiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnA5HJjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnA5HJjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BC6C116D0;
	Thu, 15 Jan 2026 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499556;
	bh=KzK91GU4c0TaLKduIY5jYHysScQCfseEXaKZU54idPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnA5HJjUFM4SeM2WfQADCa7aiSfVkLVdQlTMQM10SGlFeHZBfrRNDQCO3l+a0uCME
	 8VlM9yAyZDQeL6ER4MnJMMEWY8bQxjsKT8/UnIWb8lfLblFKRu/XGnAhmf6ZEe2n8v
	 89IzQ7Edb0vtHcwDMnBVmHdlHnBj1jWc2I5CzRHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 235/451] usb: dwc3: of-simple: fix clock resource leak in dwc3_of_simple_probe
Date: Thu, 15 Jan 2026 17:47:16 +0100
Message-ID: <20260115164239.395592412@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


