Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062289;
	b=R3SSAetysQHz+5ca/mUO4N9/kXSCroRpHL0se9O1BCT0ubNQ9q5XXgvJ30cS3360Vu6v
	 ctapyBukEoMBZp6qoQl4JXFtw+2iNk1JKHQdxy5SXmaXLpB/GKdRKDx5LZFPnRWyko1fJ
	 VTkfNkDFbnunAHGsiAjFQ5OfK+P0NHljPyW+49URUIz10k34ZyR/v8Hhw3iSpa0EkMok4
	 j8j09KwyaN9NMgpTX0hrhfAPI94wra8H/bevHhVzpjGpX/euBEM0QjPZ9wgpZpdoHevvs
	 sDlbvp49SfEzu9C10vTo/MCwfK9OsTiWaW1FNh3cu8QcZrugTbcmFObsX1I/bDYDzJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yI9BSmkSo0lAGBb/Pgfa6lGxRkdVFEXDgLPR+ZuqO6E=;
	b=k8ur0/kdO8sf8czU7fswLUOoQhyYAb3jduV5a9p2yc8IPG8j+xjuq1VxDQePGXQYoAdk
	 BfH5JCzpFvAJhr6zAit/oR1iD6Vp+322PH9fYwlTFqkrGVKR2daH4iABdaHeHirmOtGxg
	 1CTIBzE/GyCbrnNiHGyXar3pzwoa9dj1qiv29lH5dRgAy7Qtts+D8oZMwrGL5fu6dZS2S
	 hv5HUalrbnMuVepLCdDhXOnn7lmRGgKlsBOmKxQWbSJx5qn4LL6DSKWyO9ehViN00wKP4
	 7EtICAeasqFL/SFvCI8n7kJ2rUdCHLz2KhHQeRhRREyGIV3gcjxqP3mG62JAsHmAfVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8Cihw7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A553606D816;
	Sat,  7 Nov 2026 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8Cihw7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA321F0089F;
	Sat,  7 Nov 2026 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062288;
	bh=yI9BSmkSo0lAGBb/Pgfa6lGxRkdVFEXDgLPR+ZuqO6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8Cihw7i047gUPJ9+vl4mJIMtsL6//EKenCvLnOaiHzeGVBkcX4aZm6BxjNC1xC55
	 xEBSmG8DjzdDF+RvUCez8AEgqLnuGh8/b4BBOxDn58qeMZ6LP5ZPBMjNr++YHrI340
	 EULIKfuVOlhG59fC90/4UT61M2aH9HmEG5n397ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1226/1536] mailbox: mtk-cmdq: Fix runtime PM leak in cmdq_mbox_flush()
Date: Sat,  7 Nov 2026 08:54:02 -0500
Message-ID: <20261107135032.191623388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 18e3e979826795b62e8916743bec4de660e7cb22 ]

pm_runtime_get_sync() leaves the runtime PM usage counter incremented
even when it fails, but cmdq_mbox_flush() returns the error without
dropping it.  The same happens when the GCE thread does not drain in
time and the function bails out with -EFAULT.

Undo the reference on both error paths.

Fixes: b0524f7c9635 ("mailbox: mediatek: implement flush function")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index f1159dabcd4e9..ab9dd3eb43db5 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -506,8 +506,10 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 	int ret;
 
 	ret = pm_runtime_get_sync(cmdq->mbox.dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(cmdq->mbox.dev);
 		return ret;
+	}
 
 	spin_lock_irqsave(&thread->chan->lock, flags);
 	if (list_empty(&thread->task_busy_list))
@@ -544,6 +546,9 @@ static int cmdq_mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 		dev_err(cmdq->mbox.dev, "Fail to wait GCE thread 0x%x done\n",
 			(u32)(thread->base - cmdq->base));
 
+		pm_runtime_mark_last_busy(cmdq->mbox.dev);
+		pm_runtime_put_autosuspend(cmdq->mbox.dev);
+
 		return -EFAULT;
 	}
 	pm_runtime_mark_last_busy(cmdq->mbox.dev);
-- 
2.53.0



