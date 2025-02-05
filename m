Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AFB376;
	Wed,  5 Feb 2025 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767822; cv=none; b=GvjQA2/VkpqxiVthVyajemd6jaVdXL49KrOpdKF9Y/ZS17hEPpXJH2w/heTiUIRnyG9UhvLnMFr58PTagFNZhv64hbtAFiZD1iWPxFvOc2ta5mUS7hvas6I/X8a4Xw4Nl2UAuMUD9/qIXIErGDj81HAfzBvRzMQMpIzCWPCpKrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767822; c=relaxed/simple;
	bh=L58wPtmvvMhySqaO9ghqMYaC7jSvcH25HLCccPkX7Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn+qGCsSQTAqCpbnG+GJba9xV+ld8JQu26Yf8vlemInIbS+LwogsBuTPKNxmt2HprHbuFdbga6e/7gPqfyWWeLuUZ5k7bK+WbV/e4ObHrlgzNbOCoqwRc/EqK/MzJ3ssbWObYc6x3g/asQCdmB9+YgWZ/cTRbHomALTGoWnVSg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPDXxveA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPDXxveA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D38C4CED1;
	Wed,  5 Feb 2025 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767822;
	bh=L58wPtmvvMhySqaO9ghqMYaC7jSvcH25HLCccPkX7Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPDXxveAyaZeArZZYV2YLS6T4aVHHG/4XVESfMOLUBs9V//AjzKIVjGO7+Q6UfKlg
	 lps5Z2BU/Zd8ivlVQt+wkmFKFnJLpOobRF/joP6vxIV8dh1TWHuf8DdE5Wu1K5ihes
	 lTX7ypBi1h/X1pRzDKyieNm3ohYNHHcWhtTkPNWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 458/623] watchdog: rti_wdt: Fix an OF node leak in rti_wdt_probe()
Date: Wed,  5 Feb 2025 14:43:20 +0100
Message-ID: <20250205134513.736218035@linuxfoundation.org>
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

[ Upstream commit 143981aa63f33d469a55a55fd9fb81cd90109672 ]

rti_wdt_probe() does not release the OF node reference obtained by
of_parse_phandle(). Add a of_node_put() call.

This was found by an experimental verification tool that I am
developing. Due to the lack of the actual device, no runtime test was
able to be performed.

Fixes: f20ca595ae23 ("watchdog:rit_wdt: Add support for WDIOF_CARDRESET")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250105111718.4184192-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rti_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index 58c9445c0f885..255ece133576b 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -301,6 +301,7 @@ static int rti_wdt_probe(struct platform_device *pdev)
 	node = of_parse_phandle(pdev->dev.of_node, "memory-region", 0);
 	if (node) {
 		ret = of_address_to_resource(node, 0, &res);
+		of_node_put(node);
 		if (ret) {
 			dev_err(dev, "No memory address assigned to the region.\n");
 			goto err_iomap;
-- 
2.39.5



