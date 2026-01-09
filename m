Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74DD1946C8;
	Fri,  9 Jan 2026 12:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960351; cv=none; b=O82heRW6OOsXbGK7m05H3g2ND0jfCEFRTp+fZUtZKp04gDJa3ThSnTh/2WenPUhNONp2Tgpf2kpWAjKTwA/k7qjJRmxcwzuCPhTw6qacgrm6DspDx4FnUsDJ2C/mA4TGmo4z4b7ptm8azVmSVeRIXv3BcW/z2qE03/arZlbIZ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960351; c=relaxed/simple;
	bh=ltTlgIGZhHEe1VLgRAlpU0lgLSC6j/vjPE/ACAd+/BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFfIi1oJ8hlQ/dUJnk756YkyqvF1dBgO5DwTSQbJDhiTwboDV1KuQ9+WXFwKN7e7UCDCCgk7MM2Pa9hIIY7aM59KPPfPN6LP3mEj7AgRK9aacJnYNhcJeV8HeX2apfXHIvRcyI+UG164CpAny2Sc/UykPEK/rDCZyIA6CkotVxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPuZVn/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPuZVn/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342AEC4CEF1;
	Fri,  9 Jan 2026 12:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960351;
	bh=ltTlgIGZhHEe1VLgRAlpU0lgLSC6j/vjPE/ACAd+/BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPuZVn/XMhsSH0fJUgyJbaicw+7Y6K2TNqjcgrmZf7tHX1FxzZ1THjZ9rednb5qeD
	 rbEo51MFBqoEYq3j2MksquZpNsf4nNZtduL/h+e1G5nRjs2ygnvz16sAZnp8O+SVkM
	 9zdmX5quLklC5NHvuGX6VFwD//x5EVQD4XVu6N+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 373/737] Input: ti_am335x_tsc - fix off-by-one error in wire_order validation
Date: Fri,  9 Jan 2026 12:38:32 +0100
Message-ID: <20260109112148.025148173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

commit 248d3a73a0167dce15ba100477c3e778c4787178 upstream.

The current validation 'wire_order[i] > ARRAY_SIZE(config_pins)' allows
wire_order[i] to equal ARRAY_SIZE(config_pins), which causes out-of-bounds
access when used as index in 'config_pins[wire_order[i]]'.

Since config_pins has 4 elements (indices 0-3), the valid range for
wire_order should be 0-3. Fix the off-by-one error by using >= instead
of > in the validation check.

Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Link: https://patch.msgid.link/20251114062817.852698-1-junjie.cao@intel.com
Fixes: bb76dc09ddfc ("input: ti_am33x_tsc: Order of TSC wires, made configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -85,7 +85,7 @@ static int titsc_config_wires(struct tit
 		wire_order[i] = ts_dev->config_inp[i] & 0x0F;
 		if (WARN_ON(analog_line[i] > 7))
 			return -EINVAL;
-		if (WARN_ON(wire_order[i] > ARRAY_SIZE(config_pins)))
+		if (WARN_ON(wire_order[i] >= ARRAY_SIZE(config_pins)))
 			return -EINVAL;
 	}
 


