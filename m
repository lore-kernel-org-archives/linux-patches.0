Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9485112D1F1;
	Mon, 23 Dec 2024 16:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969858; cv=none; b=oboDgXRBShkneM4DeHG9J7k4H2AQ1KLp6+jQgBOJZjb/y54IyzuUr+C2SWAAO3TIjVxGs822UrFcYColjMokWvdqMiYVXGy7lMkdgvVR+HmuGCYTfkmNMw6znCVli8jjTLM393yUKJ9tnfzg/goeIxFvfaHr2Z9EA1RwijbAuX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969858; c=relaxed/simple;
	bh=KZrhOPLOu4l41oix0Dt81NRuS1yUFhXigN0hMrdbltY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJ9lmDeg/d04iVpxhy0DwxbndsbQgPT7BJ0D6nlZovHNxUH75emD7o8/LHnysERb8/TJUo0TfHbkDpZXYrUljNMiFd+7aFspAyVeNJ8Y35/hQLDnUCUWqp27aYvkhrpY2LrBKI5VTv+4Gg6bGo5RYUINpbJrCD55/UajVJblVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb8bn1wD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb8bn1wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A89C4CED3;
	Mon, 23 Dec 2024 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969858;
	bh=KZrhOPLOu4l41oix0Dt81NRuS1yUFhXigN0hMrdbltY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb8bn1wDb06fiz1Tv5NfrBV21v3Jy/QM3zCVnhHaWhnZL8rtLrLGkwKNL0JAE4kfq
	 VtcCuVsYuO8Tt4tevC1djHccj4yqGrqk2axJM1E2XrNPasypx/jMauOIZtCcn5YQa8
	 dnX+ZJUFDxvEs7XM1hyvy05gIXvl+pnH8YfRjKi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 073/160] i2c: riic: Always round-up when calculating bus period
Date: Mon, 23 Dec 2024 16:58:04 +0100
Message-ID: <20241223155411.507576309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit de6b43798d9043a7c749a0428dbb02d5fff156e5 upstream.

Currently, the RIIC driver may run the I2C bus faster than requested,
which may cause subtle failures.  E.g. Biju reported a measured bus
speed of 450 kHz instead of the expected maximum of 400 kHz on RZ/G2L.

The initial calculation of the bus period uses DIV_ROUND_UP(), to make
sure the actual bus speed never becomes faster than the requested bus
speed.  However, the subsequent division-by-two steps do not use
round-up, which may lead to a too-small period, hence a too-fast and
possible out-of-spec bus speed.  E.g. on RZ/Five, requesting a bus speed
of 100 resp. 400 kHz will yield too-fast target bus speeds of 100806
resp. 403226 Hz instead of 97656 resp. 390625 Hz.

Fix this by using DIV_ROUND_UP() in the subsequent divisions, too.

Tested on RZ/A1H, RZ/A2M, and RZ/Five.

Fixes: d982d66514192cdb ("i2c: riic: remove clock and frequency restrictions")
Reported-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: <stable@vger.kernel.org> # v4.15+
Link: https://lore.kernel.org/r/c59aea77998dfea1b4456c4b33b55ab216fcbf5e.1732284746.git.geert+renesas@glider.be
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-riic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -352,7 +352,7 @@ static int riic_init_hw(struct riic_dev
 		if (brl <= (0x1F + 3))
 			break;
 
-		total_ticks /= 2;
+		total_ticks = DIV_ROUND_UP(total_ticks, 2);
 		rate /= 2;
 	}
 


