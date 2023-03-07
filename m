Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACD8BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C96C433EF;
	Tue,  7 Mar 2023 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210418;
	bh=8Th9SNsa3znit+7Mpy1+XVSxSJzG0pSvQ6lxtUA4fA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phUo6mLLcP7WhyREjaMYpivGnHDB8EsCvhWCbduhW9z4djhKGIXrXYjj8XhoM0yfs
	 M6fb7dqyPDxacYKzWnU+19t612yiNpX+K1nqMZlq/MBM1ORz4IhQGqYQYbS+MhRI6g
	 Tz0O+uzpGXxR2t6qxYF94K0r9Z7MOTaPht3mnAVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0535/1001] usb: early: xhci-dbc: Fix a potential out-of-bound memory access
Date: Tue,  7 Mar 2023 17:55:07 +0100
Message-Id: <20230307170044.669603117@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a4a97ab3db5c081eb6e7dba91306adefb461e0bd ]

If xdbc_bulk_write() fails, the values in 'buf' can be anything. So the
string is not guaranteed to be NULL terminated when xdbc_trace() is called.

Reserve an extra byte, which will be zeroed automatically because 'buf' is
a static variable, in order to avoid troubles, should it happen.

Fixes: aeb9dd1de98c ("usb/early: Add driver for xhci debug capability")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d6a7562c5e839a195cee85db6dc81817f9372cb1.1675016180.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/early/xhci-dbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/early/xhci-dbc.c b/drivers/usb/early/xhci-dbc.c
index 7970471548202..f3e23be227d41 100644
--- a/drivers/usb/early/xhci-dbc.c
+++ b/drivers/usb/early/xhci-dbc.c
@@ -874,7 +874,8 @@ static int xdbc_bulk_write(const char *bytes, int size)
 
 static void early_xdbc_write(struct console *con, const char *str, u32 n)
 {
-	static char buf[XDBC_MAX_PACKET];
+	/* static variables are zeroed, so buf is always NULL terminated */
+	static char buf[XDBC_MAX_PACKET + 1];
 	int chunk, ret;
 	int use_cr = 0;
 
-- 
2.39.2



