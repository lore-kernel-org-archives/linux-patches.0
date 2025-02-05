Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704C9DF59;
	Wed,  5 Feb 2025 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768571; cv=none; b=smKTfp6LgH6+/WNWCmk290DxjieeSe+cO6XWK6H97lfk4RmciCp/fx7gTRPsVJlUZF2qNrODR3sLMaQZDifft3K9DUQOmVO0ORXA7Nq39p4Va2IObBdx5bNfxxrFkZNXq/aE/QakaecImC5gTalA+sWGD+gz1AX11lrKtfDprc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768571; c=relaxed/simple;
	bh=/EM4gDgD5ZPnxkS8sO3H6WWyUJbc61sWtOBQXdNjGi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mr6bgUpZ0cwJTxswCogAUCDVetTnaguj9rqeLYsJtO4iamuniKpJV5Q1mM+IuArU8SND/ZuPpjL8aTvvvM+liKGUSM+2RQse+fvXOtBhD8+/YOaMbWX2LfkSG3qC/sYlY9+KreLPnqrWA9IhWFhfaGy/DjasUtasYIdtJg8M46o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QluKZE1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QluKZE1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2B8C4CED6;
	Wed,  5 Feb 2025 15:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768571;
	bh=/EM4gDgD5ZPnxkS8sO3H6WWyUJbc61sWtOBQXdNjGi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QluKZE1xLscmmB/XvFc5h/MpNaWC0qOPk1n6P4j//JvXDcUgYEUTSV15YbwgmFAbx
	 a6SN3VMxZtO9UAzuuuZ5Pi5ez7AJL9yLIakZy6jPq7ZHyM2K3A5H2cQtNXxu5aHpq3
	 hrsTcPIvOTcHFT3Lbm/unHC3Hb2VmDgKJF0hue/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ray Chi <raychi@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.13 595/623] usb: dwc3: Skip resume if pm_runtime_set_active() fails
Date: Wed,  5 Feb 2025 14:45:37 +0100
Message-ID: <20250205134518.987197042@linuxfoundation.org>
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

From: Ray Chi <raychi@google.com>

commit e3a9bd247cddfb6fa0c29c2361f70b76c359eaa0 upstream.

When the system begins to enter suspend mode, dwc3_suspend() is called
by PM suspend. There is a problem that if someone interrupt the system
suspend process between dwc3_suspend() and pm_suspend() of its parent
device, PM suspend will be canceled and attempt to resume suspended
devices so that dwc3_resume() will be called. However, dwc3 and its
parent device (like the power domain or glue driver) may already be
suspended by runtime PM in fact. If this sutiation happened, the
pm_runtime_set_active() in dwc3_resume() will return an error since
parent device was suspended. This can lead to unexpected behavior if
DWC3 proceeds to execute dwc3_resume_common().

EX.
RPM suspend: ... -> dwc3_runtime_suspend()
                      -> rpm_suspend() of parent device
...
PM suspend: ... -> dwc3_suspend() -> pm_suspend of parent device
                                 ^ interrupt, so resume suspended device
          ...  <-  dwc3_resume()  <-/
                      ^ pm_runtime_set_active() returns error

To prevent the problem, this commit will skip dwc3_resume_common() and
return the error if pm_runtime_set_active() fails.

Fixes: 68c26fe58182 ("usb: dwc3: set pm runtime active before resume common")
Cc: stable <stable@kernel.org>
Signed-off-by: Ray Chi <raychi@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250106082240.3822059-1-raychi@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -2601,12 +2601,15 @@ static int dwc3_resume(struct device *de
 	pinctrl_pm_select_default_state(dev);
 
 	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
+	ret = pm_runtime_set_active(dev);
+	if (ret)
+		goto out;
 
 	ret = dwc3_resume_common(dwc, PMSG_RESUME);
 	if (ret)
 		pm_runtime_set_suspended(dev);
 
+out:
 	pm_runtime_enable(dev);
 
 	return ret;


