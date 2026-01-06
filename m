Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963CE34C81B;
	Tue,  6 Jan 2026 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719981; cv=none; b=FU2ZuCvHg6UsljuQuVMubOd38t0SOAArqxLpR2t0WIYO/yacYXdvhsEFcoossiOlac/hkIIcON+8cU/NaHENmsDewUZBUBnXNMQ/2K6VJIP8H2O6YyrpSoqwtFhD6pVV1P70Wn2tNK8BaRlbz0ueFRtDZ+XxrLQtcuwJ6QwSug4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719981; c=relaxed/simple;
	bh=07KiBOwBrrKX8JthCjkNN0I9Q32G3O/sRoA/H1fQ/BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m++z+j1jXGloQ2RUzR7//I8UMXXctCbHOiHLKyj3NWdB5wkeXteZzf4lWo6/ZGJ4NB3QolAAz4I1LLbNf3sTW1zcfki1y7Al7TWMs5RPZCaUYmEAC3lsQCEuXGfuZIoUG/KgibHh9LJkAD8Z07uDt8Awvbx1yCIS8zpNQZyGj2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHFzggoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHFzggoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1816AC116C6;
	Tue,  6 Jan 2026 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719981;
	bh=07KiBOwBrrKX8JthCjkNN0I9Q32G3O/sRoA/H1fQ/BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHFzggoj7FVjjCEISeEm9ZJOVuWUSODIqotE/8cksqJR8VAVVE7TwQhwZxydFAaNw
	 byvuP2ThW/Yqr3s+d74SJcZJytOgucQx99/0yQoRotfKM92q2ga/8kB6qrffkEvUZo
	 OOvWrmCV2ecoSMCYuphZ1W4bUXCnr9wQkRDhdSok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 097/567] Input: ti_am335x_tsc - fix off-by-one error in wire_order validation
Date: Tue,  6 Jan 2026 17:57:59 +0100
Message-ID: <20260106170454.916665300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


