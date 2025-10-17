Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC09C33290A;
	Fri, 17 Oct 2025 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714087; cv=none; b=TOcKIun2OcIXC8B8uEJgrwIsAbNyLDfkPktvAX/4gZTpG9/RnwtQA0zu4cq/pHQnvVpP5ROS97P8xdZPaM6zL+qGmZC8Jbfsmiasvk24EiK5dJRZ5ncbidRQYxHjTJBYjkhbg/1KFQ0v564zoANHAEicHeNbPtq1Fzo6DUOo4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714087; c=relaxed/simple;
	bh=9o8onKy85djYA8fQ28dNnqKWHTDZcHUi6Wawh2p3XSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ErK+FSgzOG+GW5SwoVkj0hf3aYRyVFENt39XraUUX+p69a/Az41IQVlyEn5kLgkHdteY7x7b/8ZLapDy8oNJMIeWxBIwrUWq3yd2CKMYJwuQj1aAa6PdWe40JklWnBCGQBt4GsTflYdrNZp5B8ODOAH0j9z+IY1BOybP9rxBrIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypAq8MTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypAq8MTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DF4C113D0;
	Fri, 17 Oct 2025 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714087;
	bh=9o8onKy85djYA8fQ28dNnqKWHTDZcHUi6Wawh2p3XSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypAq8MTLTHW5U/J9kmgxoul/qv7U5NUQuZZP9TMyGWtOJZA9q5DXsoQ/Ed1zoAmyZ
	 LTyRjwMVY25IQrq4pPxE6sJTq9bMW4YjVg+7oZQ/4qWyXV6zxaYAS233lg7549ZBxi
	 DuAnSWnLvjCEdqq7fnWGoJfgNlxPdH0mtU1G1RdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/277] rtc: optee: fix memory leak on driver removal
Date: Fri, 17 Oct 2025 16:50:29 +0200
Message-ID: <20251017145147.959460208@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit a531350d2fe58f7fc4516e555f22391dee94efd9 ]

Fix a memory leak in case of driver removal.
Free the shared memory used for arguments exchanges between kernel and
OP-TEE RTC PTA.

Fixes: 81c2f059ab90 ("rtc: optee: add RTC driver for OP-TEE RTC PTA")
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Link: https://lore.kernel.org/r/20250715-upstream-optee-rtc-v1-1-e0fdf8aae545@foss.st.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-optee.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-optee.c b/drivers/rtc/rtc-optee.c
index 9f8b5d4a8f6b6..6b77c122fdc10 100644
--- a/drivers/rtc/rtc-optee.c
+++ b/drivers/rtc/rtc-optee.c
@@ -320,6 +320,7 @@ static int optee_rtc_remove(struct device *dev)
 {
 	struct optee_rtc *priv = dev_get_drvdata(dev);
 
+	tee_shm_free(priv->shm);
 	tee_client_close_session(priv->ctx, priv->session_id);
 	tee_client_close_context(priv->ctx);
 
-- 
2.51.0



