Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611FBE571;
	Tue, 21 Jan 2025 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482478; cv=none; b=eQbKVTjqJAxz57jJpAP3BuHHe3nWspW9TXLq4QrR5gZoOb1s89Y0cRUMAeDf8sSWVKBXyj3Aifg7V1dfQ85QAVNNiK4PJkQYwqKLThZpcfmrCWN7dBiLQR+4wxuRAHJkzpfcT88XMAy0oRlQEt7TLctcFteZUXaSQgzvLi1jalg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482478; c=relaxed/simple;
	bh=93x8IljZ4mZ/m8kirPSz+HDWr7bEF1apA7heGn9PPe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYVQIvKu7+OpiabNBCd3Zrrcvj5CYv8XJ929GKzeLW4z5ySzTjlzbtNc/mpZGby4JchuvWt28XUZoP1azIXfiRtKuGWtqWyEZTe1mIf8GYyZtlhpCQSJjm+tvyQw39Uqa91Ma/FVtmeCg7Y1U4IixUaBl19213uBQeDBUUEXV5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyjKmWMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyjKmWMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD125C4CEDF;
	Tue, 21 Jan 2025 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482478;
	bh=93x8IljZ4mZ/m8kirPSz+HDWr7bEF1apA7heGn9PPe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyjKmWMcsKS+VVeV9Gbsp3UDbS1+O3yKSS6sxwe+5Vu0v2hj9t82NCjK0tyUgn8Zx
	 ZWfThgAApubS68/xkBaGaQi+GXYmp52UXgvT5ta9RrG/4BGALN1nieHdEE/HV3Wys9
	 tG2iF/HwAjWhEgIfhm9HD8k5BHR2Q8EX1muOuiHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 090/122] drm/nouveau/disp: Fix missing backlight control on Macbook 5,1
Date: Tue, 21 Jan 2025 18:52:18 +0100
Message-ID: <20250121174536.490371351@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 35243fc777566ccb3370e175cf591fea0f81f68c upstream.

Macbook 5,1 with MCP79 lost its backlight control since the recent
change for supporting GSP-RM; it rewrote the whole nv50 backlight
control code and each display engine is supposed to have an entry for
IOR bl callback, but it didn't cover mcp77.

This patch adds the missing bl entry initialization for mcp77 display
engine to recover the backlight control.

Fixes: 2274ce7e3681 ("drm/nouveau/disp: add output backlight control methods")
Cc: stable@vger.kernel.org
Link: https://bugzilla.suse.com/show_bug.cgi?id=1223838
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250102114944.11499-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/mcp77.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/mcp77.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/mcp77.c
@@ -31,6 +31,7 @@ mcp77_sor = {
 	.state = g94_sor_state,
 	.power = nv50_sor_power,
 	.clock = nv50_sor_clock,
+	.bl = &nv50_sor_bl,
 	.hdmi = &g84_sor_hdmi,
 	.dp = &g94_sor_dp,
 };


