Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD73A367B8F;
	Fri,  9 Oct 2026 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556258; cv=none; b=KwGhLMvCW1PCaquOzgNC2FHWv0QeOgeb7G9SnwR36LmjiDsZaRp7ySvtzs7m39qjOy2j05RN/MQ8eXqmWBwYvqc1q0WMvZ8T9VJ+I1PUlmfYLKk+sKKZPBHUEFbKke1yEvmVDF2GkzZtrwAljVfKqNJl2+bsu+y0XWl4OlJx1OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556258; c=relaxed/simple;
	bh=QSJBik4Q+DNq2jjHqAvfI2Gm1PhCxygb7MdGuY/m/QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NR74xrd9IW5L2Fg4RfqDmTh1B/2XE5ktBhBF2PeV8K+UWi6CrasP0HwP9QelmPqwnj0FFIcLey0/bfsW1B4anAYTtYewBOo0D/AHWC935yhRfCVle6C+8/Vp4IoXW+UPB/N0YVnZQ93+2Bgm+GtjfHfBPO2P9MBL0v+D5eq+jCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qeDndrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qeDndrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC561F000FF;
	Fri,  9 Oct 2026 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556257;
	bh=EvIgYSZEAxpApaFtuq4BRB8J6/DHB2azmgnBbMxD9g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qeDndrGuxG47UDpDqdDt9MrIOvvhAk/qi5VZySz+aSMO0N6G+o+JU00kSJXm/aIV
	 sHG+JeR3YvhK9OlDmP2DikRrsymJ6RZlaAcKpMKtSCbtjWxSWBUb9zkulrEmGKYKr0
	 lqz9yyHcyfQ0qTynOfdRb6VAgm77YezbanmQ7gNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 6.18 205/403] serial: vt8500: Fix clock reference leak in vt8500_serial_probe()
Date: Fri,  9 Oct 2026 16:09:26 +0200
Message-ID: <20261009140956.931928661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
 


