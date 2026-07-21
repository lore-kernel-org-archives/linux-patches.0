Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1055446A61C;
	Tue, 21 Jul 2026 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655083; cv=none; b=eXNSsf4yDGBYN3GU5oJfkjB6B5wJr8qi+uh8IHXgDsimGmfqwqnFlefrNwjapYBgjX1tANr6zeqKDZB4Kc2sfyXkV6h/CxDFh5ssogoPWzFufZG+QUTJrtjC62B8rQ890UsdqJv+lnG9ImbyycWNP2qtlQdeQIBNyaN6rPCDopM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655083; c=relaxed/simple;
	bh=nrI7b2AGsYs4JP8jhXd+iYl/Bwjk89UxVzsbLun+9fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmxKY7Ot4ZNVkTuE01Id7vdmu2Bk8/cLx2xoP4OgEtdAp/32W8RRNavQXIp+O6jhDn8BvBGpAG31SAxQmyQLbALwlpUR7Drj4wBHEIO3jE9Bd1jqjmQEJpWFIQaVJX/uWM9pRilpUuikmKpzEfwax9W+j2Ia6SP4B2+erkvlMZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uw2QJqFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uw2QJqFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7727F1F000E9;
	Tue, 21 Jul 2026 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655082;
	bh=pmFZGf6tws0u13XKOKvV8a/F6HlJyjNarDHwrEN9qMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uw2QJqFSx3AbdaDuD6pmgza925E4lRx2KS6cm0BiKmlJkO6casjgpNRVCBPA/l0GL
	 dkNxAxHlgQY84DlxzB/YFUe3mAgXXeIHBoWhrXjXLgF4zUstgY7lAn1CxgsMz+m6WN
	 D44opnP3PVB9+p90Eph5FuWVsEBpJZiA502NGwS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 1950/2077] ACPI: TAD: Check AC wake capability before enabling wakeup
Date: Tue, 21 Jul 2026 17:27:03 +0200
Message-ID: <20260721152638.704406881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 8522d806d84e2c3816c275ae6dd79e124c1b3dac upstream.

ACPI_TAD_AC_WAKE is a non-zero bit definition, so testing the macro
itself is always true. As a result, every TAD device is initialized as
a system wakeup device, including RTC-only devices and devices whose
wake capability bits were cleared because _PRW is absent.

Test the capability value returned by _GCP instead. This keeps
RTC-only TAD devices usable without advertising a wakeup capability
that the firmware does not provide.

Fixes: 6c711fde3a1c ("ACPI: TAD: Support RTC without wakeup")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/961A84FF37B50665+20260625132903.2840457-1-raoxu@uniontech.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_tad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -856,7 +856,7 @@ static int acpi_tad_probe(struct platfor
 	 * runtime suspend.  Everything else should be taken care of by the ACPI
 	 * PM domain callbacks.
 	 */
-	if (ACPI_TAD_AC_WAKE) {
+	if (caps & ACPI_TAD_AC_WAKE) {
 		device_init_wakeup(dev, true);
 		dev_pm_set_driver_flags(dev, DPM_FLAG_SMART_SUSPEND |
 					     DPM_FLAG_MAY_SKIP_RESUME);


