Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9366C3195EF;
	Thu, 16 Jul 2026 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211487; cv=none; b=HEeupPvTFMTnPZjmkfut49KuIDinq4wUUrL1R/lrzFWW6HTCUx9F9oLGWi5Zwn0Kv+EP3icY24uTzRxpGNCFmDDhMWyOBwNL3zQ/1x0/ARFuQRpd2mIuOPrGVTENnusItAsU71thW7lt66D8hLmiHHDYtmpQx4F2oTaLTAo8BqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211487; c=relaxed/simple;
	bh=Wl4aGeP35TEQc1okbVVofyhX/kUwY1IW3SFJ3NzQ2as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7MBQoDvUWci0BTPqUrwtIPHKG7kvwzd6K1z3jy1vzLIx/T9wejUgqV3gI4zEW1ZmqDPAlBbQshhYh/7Yi88OYwScwu98HeHpG3fYxCtTKO+/Dos3P/X61db33H6f2xs/tcD3tOeBCI8P4Lc7O3dXkPC/lFWQaWt0eXRB2JWFfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcqO3Rxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcqO3Rxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CFA1F00A3A;
	Thu, 16 Jul 2026 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211485;
	bh=OW5tKwm2Xpq3HidBrDaqKhfbxbBcn9quMMdfPUIHhUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcqO3RxsgD7cyRPQMOlmCmG+I+/sKr+jp+7ty85cCHJCGZZO4yxkkhEAlguSAWlOm
	 h47VFTgaX50TduhwAhffH+9uGcHM83IZJMu016Br8lnIspSIUtvH6DxztX2S6AnCfF
	 MkhXelpp1s51IPGL0Nx/2P9bSgCS0Aaa6KIjYN5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 445/480] Input: synaptics-rmi4 - bound the F30 keymap to the GPIO/LED count
Date: Thu, 16 Jul 2026 15:33:12 +0200
Message-ID: <20260716133054.448530863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d577e46785d45484b2ab7e7309c49b18764bf56c upstream.

rmi_f30_map_gpios() allocates gpioled_key_map with
min(gpioled_count, TRACKSTICK_RANGE_END) == at most 6 entries, but
rmi_f30_attention() iterates the full f30->gpioled_count (device query
register, range 0..31) and dereferences gpioled_key_map[i], and
input->keycodemax is set to the full gpioled_count while input->keycode
points at the 6-entry allocation.

A device that reports gpioled_count > 6 with GPIO support enabled
therefore causes an out-of-bounds read on the attention interrupt and
out-of-bounds read/write through the EVIOCGKEYCODE/EVIOCSKEYCODE ioctls,
which bound the index only against keycodemax. This is the same defect
as the F3A handler, which was copied from F30.

Size the keymap for the full gpioled_count; the mapping loop still
assigns only the first min(gpioled_count, TRACKSTICK_RANGE_END) entries.

Fixes: 3e64fcbdbd10 ("Input: synaptics-rmi4 - limit the range of what GPIOs are buttons")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260614-b4-disp-818d6bda-v1-2-cf39a3615085@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f30.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_f30.c
+++ b/drivers/input/rmi4/rmi_f30.c
@@ -233,7 +233,7 @@ static int rmi_f30_map_gpios(struct rmi_
 	int button_count = min_t(u8, f30->gpioled_count, TRACKSTICK_RANGE_END);
 
 	f30->gpioled_key_map = devm_kcalloc(&fn->dev,
-					    button_count,
+					    f30->gpioled_count,
 					    sizeof(f30->gpioled_key_map[0]),
 					    GFP_KERNEL);
 	if (!f30->gpioled_key_map) {


