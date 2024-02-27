Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C38A1448F1;
	Tue, 27 Feb 2024 13:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042052; cv=none; b=SowF7umgf9sb7wl7vgfg7As6h7lYLKxFfZwRcGTvE5jkrXYg9256jAhqV/IoXnGa4aE2lW6Hv6p7UN2KL4KF+JOvaQn4UZnuWRCzJQxXGu8NRyKHEp9dMiLwMtb5cnxBURInfAzlNfxHBYc5blPAFfz/llaHKa2TnMPaPMAC5tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042052; c=relaxed/simple;
	bh=V/u1uscCmUy/I/qWyz1fBrs7KqkVhnOhKIjqAU2G6tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSYd2gfYoMaFnTCzqrFNwxlVnl5g280CLk0GPeUSG/KJMIs7wfxeHk2WIseLQEXJ1PZcQ88wSRwxzVFJkhfZa/2b5ma2oQj1RmLLsrCiJ7OuJcDCsX+UdMNILvi5EXUcAJqGTykP1PTrSLe894kXGB47eJxeWkZwzdvIA71tRoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGV9majF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGV9majF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD5AC433F1;
	Tue, 27 Feb 2024 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042052;
	bh=V/u1uscCmUy/I/qWyz1fBrs7KqkVhnOhKIjqAU2G6tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGV9majFVInVg4SfgBPM4ar2fCLQvYk/MkIR44lVIeS1FcNO2P3njv30DmZT6e/qt
	 rAAfOx3UkYsFtC0uoDcLWgaUIfEXz0EBreHd75et9l3gCIBciZoZyvnjblHK4MKHxo
	 qX4L9oK049B/fGbeci5BCOpKTQv1L2raWXQifl2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kobel <a-kobel@a-kobel.de>,
	regressions@lists.linux.dev,
	Arnold Gozum <arngozum@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 162/299] platform/x86: intel-vbtn: Stop calling "VBDL" from notify_handler
Date: Tue, 27 Feb 2024 14:24:33 +0100
Message-ID: <20240227131631.070692170@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

commit 84c16d01ff219bc0a5dca5219db6b8b86a6854fb upstream.

Commit 14c200b7ca46 ("platform/x86: intel-vbtn: Fix missing
tablet-mode-switch events") causes 2 issues on the ThinkPad X1 Tablet Gen2:

1. The ThinkPad will wake up immediately from suspend
2. When put in tablet mode SW_TABLET_MODE reverts to 0 after about 1 second

Both these issues are caused by the "VBDL" ACPI method call added
at the end of the notify_handler.

And it never became entirely clear if this call is even necessary to fix
the issue of missing tablet-mode-switch events on the Dell Inspiron 7352.

Drop the "VBDL" ACPI method call again to fix the 2 issues this is
causing on the ThinkPad X1 Tablet Gen2.

Fixes: 14c200b7ca46 ("platform/x86: intel-vbtn: Fix missing tablet-mode-switch events")
Reported-by: Alexander Kobel <a-kobel@a-kobel.de>
Closes: https://lore.kernel.org/platform-driver-x86/295984ce-bd4b-49bd-adc5-ffe7c898d7f0@a-kobel.de/
Cc: regressions@lists.linux.dev
Cc: Arnold Gozum <arngozum@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Alexander Kobel <a-kobel@a-kobel.de>
Link: https://lore.kernel.org/r/20240216203300.245826-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vbtn.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/platform/x86/intel/vbtn.c
+++ b/drivers/platform/x86/intel/vbtn.c
@@ -200,9 +200,6 @@ static void notify_handler(acpi_handle h
 	autorelease = val && (!ke_rel || ke_rel->type == KE_IGNORE);
 
 	sparse_keymap_report_event(input_dev, event, val, autorelease);
-
-	/* Some devices need this to report further events */
-	acpi_evaluate_object(handle, "VBDL", NULL, NULL);
 }
 
 /*


