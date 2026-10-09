Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5D519F40B;
	Fri,  9 Oct 2026 14:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556889; cv=none; b=IspYsnHtra2m8fL5SFqcqd/B7O4ooojiaj7/Kw4v3hh61uSuJAH6hTG24tuZD64YNqqz0Dpy+AuS7YD0U+Xon5sG66Dd5XSKP++QDjvo+fAYNFFCj9g2TgyvO1eeEZt5e6ZM7M1O1lz+6cPim7/vtGSGftnnxQKMiJjA5otRr08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556889; c=relaxed/simple;
	bh=JQwxE3cgXveG6gcL0ihno7Co/kvFKSzEjCZvKV5NnQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbEp3egbTsR5EX7o5yYgi8+sg/0qHIyYiJFvwXxNqnb/VfaX9W+KlgQbh4cHvkdKCfnjC0DXsimYQIEJIALhNdRrrFClah7IiDq70tGmqEKucbyEfs28OAOjGGfyuRbL5AwxjFfiCB3BPl0I+Fkhxl0X2V/Aa6N/jue0b8wEuMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvZdttbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvZdttbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20B21F0089A;
	Fri,  9 Oct 2026 14:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556888;
	bh=axLaf98mDNHDhsaNjjdiUIhzgaRZilh0ydoFR4ykL3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvZdttbwTbsHTrbigQHZM1xa4egzDb2vUwgSARn4nrHDRYFVRx612OzmpqAtNmDRZ
	 3L6YmNMh7gcHfSb+jUcbv/OreQODK4ZLxuixINEElcPY51axZLifr/lVFVKcgRgKta
	 b7Ve8vn++m/16uRegsdnXpxfpNK8uip9YkHX9e3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 7.2 258/428] serial: vt8500: Fix clock reference leak in vt8500_serial_probe()
Date: Fri,  9 Oct 2026 16:09:55 +0200
Message-ID: <20261009140951.770435088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 9d8955281d9229a899e2041659a59b389027b711 upstream.

of_clk_get() returns a clock with a reference that has to be released
with clk_put(). If clk_prepare_enable() fails the function returns
without doing so, leaking the reference.

Add the missing clk_put() on that error path.

Fixes: 12faa35ae5cb ("serial: vt8500: UART uses gated clock rather than 24Mhz reference")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917155834.2161361-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/vt8500_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -656,6 +656,7 @@ static int vt8500_serial_probe(struct pl
 	ret = clk_prepare_enable(vt8500_port->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
+		clk_put(vt8500_port->clk);
 		return ret;
 	}
 


