Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FC017E90E;
	Mon, 27 May 2024 19:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837109; cv=none; b=Ai5La0SkykQgsDWSq8f4le3BhuP9zyB4bxnfKXdqDD8AhmqDZFpfV6QSSyT+ZiJuHCj4cpt88XStr43UVHY27J/wesuP0Zstkg2q13EzXBDlARP3d8e1BPu7dxyFmM3X6+EIxMRFdHd6kf6YQR/Gl5BZMd93hY9zg2iCI8hrmmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837109; c=relaxed/simple;
	bh=mCBJ2vCj8Qi2Nm2Q3b3y+e4qszUK6MMXrtTjcCO2QAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyJwRbNoln4KrHJAGKetl8mWB6VmRvzsTPdYiP6Fqq/37z1W8kyrcfuMqrdUETTpKyrV28ozQ6651UqPlDj0MYuVwf0SV+VsUaxDgIE/hN4Q0wRTLaM1newbcdpzCyLI1j5FgG/W2sL0ZMaNnHkOo8J1JPi48qJKpBIpGT/mz6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edR0U80+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edR0U80+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E5EC2BBFC;
	Mon, 27 May 2024 19:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837109;
	bh=mCBJ2vCj8Qi2Nm2Q3b3y+e4qszUK6MMXrtTjcCO2QAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edR0U80+vEsycn+K1OAhUnMoPrTNsqfnMNeUrEjM0oJXZyZwR8nTT7/dpNlvpDYaF
	 QNtsDAjcaWz8yrWlCMAgciu0ItXJabrCDg74sLhg3U6ynicwcUdG11ZNYDqTF3EG/e
	 O7FLy1bh7RjQ5ehGg5U0w8nvH1keXaVP6+HAJuAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 312/427] media: ngene: Add dvb_ca_en50221_init return value check
Date: Mon, 27 May 2024 20:55:59 +0200
Message-ID: <20240527185631.012995343@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Burakov <a.burakov@rosalinux.ru>

[ Upstream commit 9bb1fd7eddcab2d28cfc11eb20f1029154dac718 ]

The return value of dvb_ca_en50221_init() is not checked here that may
cause undefined behavior in case of nonzero value return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 25aee3debe04 ("[media] Rename media/dvb as media/pci")
Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ngene/ngene-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 7481f553f9595..24ec576dc3bff 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1488,7 +1488,9 @@ static int init_channel(struct ngene_channel *chan)
 	}
 
 	if (dev->ci.en && (io & NGENE_IO_TSOUT)) {
-		dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		ret = dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		if (ret != 0)
+			goto err;
 		set_transfer(chan, 1);
 		chan->dev->channel[2].DataFormatFlags = DF_SWAP32;
 		set_transfer(&chan->dev->channel[2], 1);
-- 
2.43.0



