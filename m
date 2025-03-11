Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CBB25DD0B;
	Tue, 11 Mar 2025 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706026; cv=none; b=lgfvHK8qxG4I887axrXUu3kS+INkWmgtRKYMPVu465Xnf39dRL9XIr4xeoMVB2WnnK9QWDX6Yd13ASVyiUIU5PaPBDdIrhOd2mew8yHc8H5gv9Pclv+7ZvbJKXhRl87do1oaTjg4QvqLcI8f7qM9PDhjeRwjaXWR9Lq2BUzMS+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706026; c=relaxed/simple;
	bh=qZT6dBoinqN56obgAUsacymYQeVbgsaiWtCDePdiOnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cckW5NwPMAq1IM29zGPnj53UOjGMtu7ivAtdSpebwOHX+L4aTlNg2T60RsLtZpjg8JJ8hUF4y+iniy3a7tUtTjoQDiWsZDhZuA4uJbDbTw9csZWNIB8yfyy24SFsVh2rHkX6F53IZCLB+KgM+3Wl2gVUXbxbqY0GU+jOzIgh2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMjFiLCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMjFiLCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2836EC4CEE9;
	Tue, 11 Mar 2025 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706026;
	bh=qZT6dBoinqN56obgAUsacymYQeVbgsaiWtCDePdiOnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMjFiLCL5aHiDd1WaEsPqJ3y+hmyQYWDn8/t0D212LU2v2DfPdRAP/4Khv7U0DOUK
	 GbyB8LOs0Bv+UcVzAvHX7Tj+2gxEUGu2+tl/7W++E9OscrCqHxjTb7FfMH2vh0fJpV
	 oDC4VbVwROL0WkbDBaDGOcEvcGudVv/UxAa4q+oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Perier <romain.perier@gmail.com>,
	Allen Pais <allen.lkml@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 237/328] usb/gadget: f_midi: convert tasklets to use new tasklet_setup() API
Date: Tue, 11 Mar 2025 16:00:07 +0100
Message-ID: <20250311145724.333472371@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pais <allen.lkml@gmail.com>

[ Upstream commit 6148c10f6b62a6df782d26522921f70cc8bf1d7f ]

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
Link: https://lore.kernel.org/r/20200817090209.26351-5-allen.cryptic@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4ab37fcb4283 ("USB: gadget: f_midi: f_midi_complete to call queue_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 54a09da8a7384..71aeaa2302edd 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -698,9 +698,9 @@ static void f_midi_transmit(struct f_midi *midi)
 	f_midi_drop_out_substreams(midi);
 }
 
-static void f_midi_in_tasklet(unsigned long data)
+static void f_midi_in_tasklet(struct tasklet_struct *t)
 {
-	struct f_midi *midi = (struct f_midi *) data;
+	struct f_midi *midi = from_tasklet(midi, t, tasklet);
 	f_midi_transmit(midi);
 }
 
@@ -875,7 +875,7 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 	int status, n, jack = 1, i = 0, endpoint_descriptor_index = 0;
 
 	midi->gadget = cdev->gadget;
-	tasklet_init(&midi->tasklet, f_midi_in_tasklet, (unsigned long) midi);
+	tasklet_setup(&midi->tasklet, f_midi_in_tasklet);
 	status = f_midi_register_card(midi);
 	if (status < 0)
 		goto fail_register;
-- 
2.39.5



