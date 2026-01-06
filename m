Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F87F35505E;
	Tue,  6 Jan 2026 17:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720276; cv=none; b=HEKTUc3853ZGe9uFZQD//Is7MxjEilzPzlKI+/8n2I6KVlAZL2HUNfn9ipLEVGHh2SvYnsSnHVYtYq8aYo+CjAEc69+L0r5rVYi9XB3NmRTppwmtj8hmzXCDxoQxjac+IzjBB/ZbwRqgdqaHlXTCCE92WTCrcLyVHdidUP2PnlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720276; c=relaxed/simple;
	bh=F2c5K9OaifnhNgJcTTeA5vkOdVk0G15Z5pqOAg+gHbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IozsxTNTNLl/fLJ4mtC0YwgabgtHtJuahJDnv7JXoOzgjGKSiewqyMRROWR3r292AgrZ1c5qMy/qxyNzCENLAqAs8xdU3u8ikGY42yByI3T/kOA3NQ9wqsCSdU2WXDvOWVjlvn+50I7DxB7VeZAY4WcLrmi5kUrHqN/+bCbraTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G75u6H0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G75u6H0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693C8C116C6;
	Tue,  6 Jan 2026 17:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720275;
	bh=F2c5K9OaifnhNgJcTTeA5vkOdVk0G15Z5pqOAg+gHbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G75u6H0XT+K0JENArHsyN+PdQmg29gR4lWYykmEa1KoBEX7jS23qIu2Q1j4VggJDg
	 JxZHju3oOpSc3SvAGUIpZCbSczTALo/9FHmmx/FSFdupGRYu9o2hwsL/yYxWo2gF9q
	 yd8EpsaokkclFd20cOiLzcoBlnnehEU6yPMRYBA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 188/567] usb: dwc3: of-simple: fix clock resource leak in dwc3_of_simple_probe
Date: Tue,  6 Jan 2026 17:59:30 +0100
Message-ID: <20260106170458.283132193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -70,11 +70,11 @@ static int dwc3_of_simple_probe(struct p
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
@@ -82,8 +82,9 @@ static int dwc3_of_simple_probe(struct p
 
 	return 0;
 
-err_clk_put:
+err_clk_disable:
 	clk_bulk_disable_unprepare(simple->num_clocks, simple->clks);
+err_clk_put_all:
 	clk_bulk_put_all(simple->num_clocks, simple->clks);
 
 err_resetc_assert:


