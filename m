Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915DA3043D4;
	Sat, 25 Oct 2025 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408949; cv=none; b=Kf5QtYcbScP0VkfYH1PiiDlxNvEI/+my1n2+b+H8sNGgd94HKX1/ZAYApA7TMVW4EHq1UYCTh9yZUOA8rCigenOBTJySmhA9w+hHJl9FRPvi7LlqZ8+tY4U5QlHFs3Alax99yr7FS2536W00BWgBCBABzg3OZGE/UY0MpFeFAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408949; c=relaxed/simple;
	bh=KbleRv2enS7SAoCobkifY4ua5pnyvJthEK1Cru43yoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XsoiBTfoMenR0QvAPkqH1j87OuZ5wYn1EIjED/6eQl81v6REptWuNCRuIma4ndlNSBKB3A8RhYzIqA+XgSFK0Hl2tTXP5QqTldH2DUcFLrxK8KfF1bat8HxeC+lFgo8KhNkkBfaWxtPr6MucYXaZCKaL3HQJxwXayIkDC72siyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVYaZ+aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVYaZ+aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D94AC4CEFB;
	Sat, 25 Oct 2025 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408949;
	bh=KbleRv2enS7SAoCobkifY4ua5pnyvJthEK1Cru43yoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVYaZ+aZewNy/hdKDleie7QiqO2byW41GsG0jTbswh4goFvae4AxhPgxPqHLHOOok
	 3r4hi7jPamklgCZbmmE6MsxB6/RunHS4D3SL7HLHuMKwhlomkZnHjBRA3lb3v2j7bP
	 uExa2C5DhYZyRrK4Tfs12wHiFygEVE/wR/3MF4HaxuQLp9mkuc7yVLvMEyrjxo0Hog
	 QhyHxtBAVLLgWM/54nTLjJIQL3AALGo2nrr1mmtX4jtkcc9yi0rzBtjMiSLUdDe/4h
	 vpAMJNzbl6xgf0qhpekWZyEBhMna7MW7eclDWv4LX4QQZWjgpb08RumRxWsfAUgJfz
	 eTCZmbKvVfL+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Yufeng <chenyufeng@iie.ac.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	pawell@cadence.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.15] usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget
Date: Sat, 25 Oct 2025 11:56:17 -0400
Message-ID: <20251025160905.3857885-146-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Yufeng <chenyufeng@iie.ac.cn>

[ Upstream commit 87c5ff5615dc0a37167e8faf3adeeddc6f1344a3 ]

In the __cdnsp_gadget_init() and cdnsp_gadget_exit() functions, the gadget
structure (pdev->gadget) was freed before its endpoints.
The endpoints are linked via the ep_list in the gadget structure.
Freeing the gadget first leaves dangling pointers in the endpoint list.
When the endpoints are subsequently freed, this results in a use-after-free.

Fix:
By separating the usb_del_gadget_udc() operation into distinct "del" and
"put" steps, cdnsp_gadget_free_endpoints() can be executed prior to the
final release of the gadget structure with usb_put_gadget().

A patch similar to bb9c74a5bd14("usb: dwc3: gadget: Free gadget structure
 only after freeing endpoints").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
Link: https://lore.kernel.org/r/20250905094842.1232-1-chenyufeng@iie.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real bug (use-after-free) that can crash or corrupt memory
  during error paths and driver removal, affecting users of the Cadence
  cdnsp gadget driver.
- Root cause: endpoints are linked via `gadget.ep_list`, so freeing the
  gadget before removing endpoints leaves dangling list pointers.
  `cdnsp_gadget_free_endpoints()` manipulates `pdev->gadget.ep_list`; if
  the gadget is already freed, this is a UAF.
  - Endpoint teardown iterates and removes from the gadget’s endpoint
    list: `drivers/usb/cdns3/cdnsp-gadget.c:1725`.
- Precise failure points addressed:
  - In `__cdnsp_gadget_init()`, if `devm_request_threaded_irq()` fails,
    the old path did `usb_del_gadget_udc()` and then
    `cdnsp_gadget_free_endpoints()`, risking UAF. The patch splits the
    del/put so endpoints are freed while the gadget is still alive:
    - Function start: `drivers/usb/cdns3/cdnsp-gadget.c:1900`
    - UDC registration: `drivers/usb/cdns3/cdnsp-gadget.c:1963`
    - New error path ordering: `del_gadget:` →
      `usb_del_gadget(&pdev->gadget);` →
      `cdnsp_gadget_free_endpoints(pdev);` →
      `usb_put_gadget(&pdev->gadget);` → `goto halt_pdev;` at
      `drivers/usb/cdns3/cdnsp-gadget.c:1978`
  - In `cdnsp_gadget_exit()`, the old sequence similarly freed the
    gadget before endpoints. The patch changes it to:
    - Function start: `drivers/usb/cdns3/cdnsp-gadget.c:1997`
    - New order: `usb_del_gadget(&pdev->gadget);` →
      `cdnsp_gadget_free_endpoints(pdev);` →
      `usb_put_gadget(&pdev->gadget);` at `drivers/usb/cdns3/cdnsp-
      gadget.c:2001` and `:2005`.
- The change is minimal, localized, and follows established core UDC API
  semantics:
  - `usb_del_gadget_udc()` is literally `usb_del_gadget()` +
    `usb_put_gadget()` (so splitting is functionally correct and
    intended): `drivers/usb/gadget/udc/core.c:1560`.
  - `usb_del_gadget()` unregisters the gadget without final put:
    `drivers/usb/gadget/udc/core.c:1531`.
  - `usb_put_gadget()` is the final put (inline):
    `include/linux/usb/gadget.h:500`.
- The fix mirrors the proven pattern already used by other gadget
  drivers (e.g., DWC3): `usb_del_gadget();` → free endpoints →
  `usb_put_gadget();` in `drivers/usb/dwc3/gadget.c:4816`.
- No architectural changes, no new features, and no ABI impacts. It only
  touches cdnsp gadget teardown and error paths.
- Regression risk is low:
  - Releases UDC before endpoint list manipulation (prevents new
    activity), but keeps the gadget object alive until endpoints are
    freed.
  - Adds `goto halt_pdev` from the `del_gadget` path to avoid double-
    freeing endpoints; other error paths remain balanced and consistent.
- Security/stability relevance: UAFs are both reliability and potential
  security issues; fixing them is strongly aligned with stable policy.

Given the clear bugfix nature, small and contained changes, and
alignment with core and peer driver patterns, this is a strong candidate
for backporting to all stable trees that contain the cdnsp gadget
driver.

 drivers/usb/cdns3/cdnsp-gadget.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index 55f95f41b3b4d..0252560cbc80b 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1976,7 +1976,10 @@ static int __cdnsp_gadget_init(struct cdns *cdns)
 	return 0;
 
 del_gadget:
-	usb_del_gadget_udc(&pdev->gadget);
+	usb_del_gadget(&pdev->gadget);
+	cdnsp_gadget_free_endpoints(pdev);
+	usb_put_gadget(&pdev->gadget);
+	goto halt_pdev;
 free_endpoints:
 	cdnsp_gadget_free_endpoints(pdev);
 halt_pdev:
@@ -1998,8 +2001,9 @@ static void cdnsp_gadget_exit(struct cdns *cdns)
 	devm_free_irq(pdev->dev, cdns->dev_irq, pdev);
 	pm_runtime_mark_last_busy(cdns->dev);
 	pm_runtime_put_autosuspend(cdns->dev);
-	usb_del_gadget_udc(&pdev->gadget);
+	usb_del_gadget(&pdev->gadget);
 	cdnsp_gadget_free_endpoints(pdev);
+	usb_put_gadget(&pdev->gadget);
 	cdnsp_mem_cleanup(pdev);
 	kfree(pdev);
 	cdns->gadget_dev = NULL;
-- 
2.51.0

