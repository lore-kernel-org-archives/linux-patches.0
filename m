Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6148285CA9;
	Tue, 26 Aug 2025 11:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208757; cv=none; b=hMIXKhwr9SsKswiBvxlFP5aMtdVbI/t/QQXciSKsD/uLuHLLZwIRpLn5PZale+rOhSeKiyS65wBYhHzUdq7h5BG853kKgdthO6ObN/nPMjV3Wk+mo2Gv+Z5pnCtivVXaYZFSlZj/bD7TUx+E6R/7PiM5Q2rC3l9/G7McuGRg9wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208757; c=relaxed/simple;
	bh=WjH5Ct8V6Yj7YEQ26TiJDJgUX7jfZy/DNKk2Pi911zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKjrXk+tv3/b3/094iwVHr7M9oEHbTKFZRVwusePd0aCJHGM8qDVH+LGtxH1BnaG9wHyxxShpI6C5fLZXibEQ3TbdVFddZDvgapW8yLlzbV08SJjb6/90qA/n/r/4BFjaEQyu7kqdyL6vzmwT9O3yHGU3E/ixT70rlzxQJfHKA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUUsxSU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUUsxSU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015F2C4CEF1;
	Tue, 26 Aug 2025 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208757;
	bh=WjH5Ct8V6Yj7YEQ26TiJDJgUX7jfZy/DNKk2Pi911zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUUsxSU8vlhTl0w+t1SQITMDL86Vloh0RbS5IxVppZmPKy+NNrqcPPBTRF1M5sabe
	 Fhbg9oNpf5tBdz04Il68pXvZ/YIqD8CPxUV4Ux0NjNqvIzE7dmMD05qnSpgWq9rt1t
	 jwC91vd+mVyoBbD/kxFJPNS2JGPVnDV6da/3QBmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 233/322] usb: dwc3: Ignore late xferNotReady event to prevent halt timeout
Date: Tue, 26 Aug 2025 13:10:48 +0200
Message-ID: <20250826110921.656914256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuen-Han Tsai <khtsai@google.com>

commit 58577118cc7cec9eb7c1836bf88f865ff2c5e3a3 upstream.

During a device-initiated disconnect, the End Transfer command resets
the event filter, allowing a new xferNotReady event to be generated
before the controller is fully halted. Processing this late event
incorrectly triggers a Start Transfer, which prevents the controller
from halting and results in a DSTS.DEVCTLHLT bit polling timeout.

Ignore the late xferNotReady event if the controller is already in a
disconnected state.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250807090700.2397190-1-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3707,6 +3707,15 @@ static void dwc3_gadget_endpoint_transfe
 static void dwc3_gadget_endpoint_transfer_not_ready(struct dwc3_ep *dep,
 		const struct dwc3_event_depevt *event)
 {
+	/*
+	 * During a device-initiated disconnect, a late xferNotReady event can
+	 * be generated after the End Transfer command resets the event filter,
+	 * but before the controller is halted. Ignore it to prevent a new
+	 * transfer from starting.
+	 */
+	if (!dep->dwc->connected)
+		return;
+
 	dwc3_gadget_endpoint_frame_from_event(dep, event);
 
 	/*


