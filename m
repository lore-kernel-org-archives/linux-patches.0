Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2737B41F37E;
	Thu, 16 Jul 2026 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211482; cv=none; b=VWVxUZXCGzh4n4vkelcSiYVsKVUaQxlU+9mSwBnJANOYovXmA8/SDrkcQBt5Tz4pivtz+ce6Fyib2XkKKE/yyfVRyYHzGf42N9/E1elFJFtWytfzVzgl96G7F3YllxI0+q/iLLnZJSeZelPK+tDdiUyR/JYVBIZZ+GkMBvF4vVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211482; c=relaxed/simple;
	bh=yP20EzS6V61PmdY6MkX3RbhpwxNk4y6pmUVHdB1/sWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYP16ZpJoO9B5c9+7bATYxVwfQP3GRjCsqJb0LsOX92qSKA9nvyxp/uZQMwPcMZxknknIIjBbnxc7J5/juJJD87iUXCP6pBRQbJ7/7a3qUatUUCXgnnTUWNDXXRw01QbT+qZqBbCAq+4USHXC6NrWgUUwfxB/LBbi+QDMaAEZ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuFqzHBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuFqzHBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889F21F00A3A;
	Thu, 16 Jul 2026 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211480;
	bh=SDRNZufZP5FxUUdrB+Ce9fQzan5VqykfPonGHquQ/FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuFqzHBzSzCLiUQ10VxwhWBdH448YqYN2hGk3QHZKxqN0achazu6iJFKtseDBRYO0
	 6Nlqu9lRHS5mpBVBmdgsxL4n1WSiUtUi9ok+0T5EnjzpPJ2+OtSohtJyuCs3m3s1UA
	 zmEQR9QDpQV2Q+vjexG+/EJ4H4Y5Jkrhna69Sqcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 444/480] Input: synaptics-rmi4 - bound the F3A keymap to the GPIO count
Date: Thu, 16 Jul 2026 15:33:11 +0200
Message-ID: <20260716133054.427235962@linuxfoundation.org>
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

commit 57c10915f2c16c90e0d46ad00876bf39ece40fc2 upstream.

rmi_f3a_initialize() takes the GPIO count from the device query register
(f3a->gpio_count = buf & RMI_F3A_GPIO_COUNT, range 0..127).
rmi_f3a_map_gpios() then allocates gpio_key_map with
min(gpio_count, TRACKSTICK_RANGE_END) == at most 6 entries, but
rmi_f3a_attention() iterates the full gpio_count and dereferences
gpio_key_map[i], and input->keycodemax is set to the full gpio_count
while input->keycode points at the 6-entry allocation.

A device that reports gpio_count > 6 therefore causes an out-of-bounds
read of gpio_key_map[] on every attention interrupt, and out-of-bounds
accesses through the input core's default keymap ioctls: EVIOCGKEYCODE
reads past the buffer (leaking adjacent slab memory to user space) and
EVIOCSKEYCODE writes a caller-controlled value past it, for any process
able to open the evdev node, since input_default_getkeycode() and
input_default_setkeycode() only bound the index against keycodemax.

Size the keymap for the full gpio_count. The mapping loop is unchanged:
it still assigns only the first min(gpio_count, TRACKSTICK_RANGE_END)
entries; the remaining slots stay KEY_RESERVED (devm_kcalloc zero-fills)
and are skipped when reporting.

Fixes: 9e4c596bfd00 ("Input: synaptics-rmi4 - add support for F3A")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260614-b4-disp-818d6bda-v1-1-cf39a3615085@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f3a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_f3a.c
+++ b/drivers/input/rmi4/rmi_f3a.c
@@ -132,7 +132,7 @@ static int rmi_f3a_map_gpios(struct rmi_
 	int button_count = min_t(u8, f3a->gpio_count, TRACKSTICK_RANGE_END);
 
 	f3a->gpio_key_map = devm_kcalloc(&fn->dev,
-						button_count,
+						f3a->gpio_count,
 						sizeof(f3a->gpio_key_map[0]),
 						GFP_KERNEL);
 	if (!f3a->gpio_key_map) {


