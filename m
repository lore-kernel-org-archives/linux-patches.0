Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E06D611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE73AC433EF;
	Sun, 28 May 2023 19:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303016;
	bh=UlKBe9JdPpRlQ6pW4qAlSVvezPtjcalcGgOT7fGe+Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO0iQ6SnhrJxzN6ZBA1noHQvwU1+smCv90dcPz62W6XPmO1+ns3iDIeZaLWFqA+kf
	 fud5l5WzDAZlkW+vlpi5bX5GArIZoacS3+OrW6xym7yBPhdqWZaXwDtJD4JmsVLEPc
	 6rg0QTyNU5ghCUowttEW/MJq7OvfFYRI7u8JvSls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ning <qning0106@126.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/211] mfd: dln2: Fix memory leak in dln2_probe()
Date: Sun, 28 May 2023 20:10:04 +0100
Message-Id: <20230528190845.685259054@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiang Ning <qning0106@126.com>

[ Upstream commit 96da8f148396329ba769246cb8ceaa35f1ddfc48 ]

When dln2_setup_rx_urbs() in dln2_probe() fails, error out_free forgets
to call usb_put_dev() to decrease the refcount of dln2->usb_dev.

Fix this by adding usb_put_dev() in the error handling code of
dln2_probe().

Signed-off-by: Qiang Ning <qning0106@126.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230330024353.4503-1-qning0106@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/dln2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 852129ea07666..fc65f9e25fda8 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -836,6 +836,7 @@ static int dln2_probe(struct usb_interface *interface,
 	dln2_stop_rx_urbs(dln2);
 
 out_free:
+	usb_put_dev(dln2->usb_dev);
 	dln2_free(dln2);
 
 	return ret;
-- 
2.39.2



