Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634AE31BC91;
	Mon, 27 Oct 2025 18:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591273; cv=none; b=OEy1gsOEDp41ofvxEE20B3OrzFMcF2oJ4iUCHszeY5abIaM1YqzEAmgvicWidmWgd8z1fizEQL4tCvRUNuSoCtDeByKB/GxBwZiOjcEHe1HXFF5jEPQgVQxtK5yN7Oswjgorr2DoviUiudJ9OitJe/mja7NJVI2uBoLB9bYTon0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591273; c=relaxed/simple;
	bh=L4b/F9EOZyJD6hh7oDwEd0BSO/3zMCCZBbOl25lX4QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4XuzuOaj3+w8yLc3ztjLZ+AZkRZPAZAziaqaZZoUlmNINp74Yb/GadChSDCX3oDJXe8dA95UCrcFAAakmI3BDriPqq6HaVjl1fCoxvNy+6t1jZ3X/cl17Xpw+aRyo4nbYkt4CqDD3orwWNwK6P+XSMOOPyZKOW0S22egmNFBBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6yvGwrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6yvGwrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8012C4CEF1;
	Mon, 27 Oct 2025 18:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591273;
	bh=L4b/F9EOZyJD6hh7oDwEd0BSO/3zMCCZBbOl25lX4QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6yvGwrwca/ifx3hLPmZ8XyYf+Mt1OPaEwmBCjyx1P2FVvQQA0G4SpLjpqoGMoesD
	 BhNAu9f9xWb7y16oqv0BwZkwhxlDIU/eoxXwIHhUr/fW1Ur0Jin2E54ibYok3XZGEK
	 ecPWUcHGQYJ9dkkrbkpeUsoPJ09d0SuErzoVo10g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Caione <ccaione@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.10 133/332] firmware: meson_sm: fix device leak at probe
Date: Mon, 27 Oct 2025 19:33:06 +0100
Message-ID: <20251027183528.143389101@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 8ece3173f87df03935906d0c612c2aeda9db92ca upstream.

Make sure to drop the reference to the secure monitor device taken by
of_find_device_by_node() when looking up its driver data on behalf of
other drivers (e.g. during probe).

Note that holding a reference to the platform device does not prevent
its driver data from going away so there is no point in keeping the
reference after the helper returns.

Fixes: 8cde3c2153e8 ("firmware: meson_sm: Rework driver as a proper platform driver")
Cc: stable@vger.kernel.org	# 5.5
Cc: Carlo Caione <ccaione@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250725074019.8765-1-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/meson/meson_sm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -225,11 +225,16 @@ EXPORT_SYMBOL(meson_sm_call_write);
 struct meson_sm_firmware *meson_sm_get(struct device_node *sm_node)
 {
 	struct platform_device *pdev = of_find_device_by_node(sm_node);
+	struct meson_sm_firmware *fw;
 
 	if (!pdev)
 		return NULL;
 
-	return platform_get_drvdata(pdev);
+	fw = platform_get_drvdata(pdev);
+
+	put_device(&pdev->dev);
+
+	return fw;
 }
 EXPORT_SYMBOL_GPL(meson_sm_get);
 


