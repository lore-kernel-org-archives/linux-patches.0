Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE465154C15;
	Tue, 27 May 2025 17:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365288; cv=none; b=mw4uR2zAV/nxKc+nbTiE5/nENh2ldFyA52HePBVKnWUTjrznOsxY18ap2nMfc1xDMgEO4jv9c/23TIyCydnajYWWcQPwb/Cp5VrsEqUP9nv1jjE0LIZHouZL2cnHqt5JnKnvPO+WgevpyPRQNiqxtR+tP9TFHeX3lJeerIV9EC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365288; c=relaxed/simple;
	bh=BIzMJ43MQsxD6mgHsJJk4kYJ1eteGKSLYE7nN4gzWVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9h6GdQ3P6bEHXJTN6mHdCX65K/KcziuqvyqCwoy9kPd/AqtevTvtT06IppR9mnFpvi1Ky+T+cg0dbD2g7beSN/p2enhciCJZgx+8dqJc64Oz53PybZDeMjA8p8Y3Ud0d5M0wk22YcXHUcy9qat6LszfBvWD6sqi0Gd2GyFwHa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpAuf8Wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpAuf8Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C78DC4CEE9;
	Tue, 27 May 2025 17:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365288;
	bh=BIzMJ43MQsxD6mgHsJJk4kYJ1eteGKSLYE7nN4gzWVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpAuf8WvpNTWmeWUDA1Yb91KcVuVsZO3uOmy6xBotrgIUGF+GG1+uyOfbWD4V/uaG
	 jod2UueiOYq7CP9bIEo4VfH9p5xSD1h/tO7+tZ+OAdVrlwzDz8J0Otk7oHM4iuIMBn
	 s6UoxTBXNGlbUUDx+uUjVxaTpm3URyjOMjRorOUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/626] i3c: master: svc: Flush FIFO before sending Dynamic Address Assignment(DAA)
Date: Tue, 27 May 2025 18:23:41 +0200
Message-ID: <20250527162458.357404072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a892ee4cf22a50e1d6988d0464a9a421f3e5db2f ]

Ensure the FIFO is empty before issuing the DAA command to prevent
incorrect command data from being sent. Align with other data transfers,
such as svc_i3c_master_start_xfer_locked(), which flushes the FIFO before
sending a command.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20250129162250.3629189-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 6ffe022dbb5b4..62913feae45dd 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -860,6 +860,8 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 	u32 reg;
 	int ret, i;
 
+	svc_i3c_master_flush_fifo(master);
+
 	while (true) {
 		/* SVC_I3C_MCTRL_REQUEST_PROC_DAA have two mode, ENTER DAA or PROCESS DAA.
 		 *
-- 
2.39.5



