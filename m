Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D6F1448E5;
	Thu, 13 Jun 2024 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279900; cv=none; b=bBRdYXjSjkWUTwRUrKVlEW+Y7TsW/Aa7xpZYNCZt/u20OsROsESbqJu68nD1G+8rcFGig69iyoZ0UNJtfnDW6KSq+GxWUnrdJXyNvGL9FAEugoAPa8wkj8+WBxiO44ylH38pX+0oAgsD1QWcaq+6yeI5Gmx3jJkKGxVlJkfbOl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279900; c=relaxed/simple;
	bh=AgwQ1aNIuXOZ+HrGd6hsMW4Y9BjSo+p31RXeUAlQB5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1tKj1yjsDqe4S/ZJAp/t1CilByicE0p5RCMgpNiRs65hZgQh6uvp9j+dib6IHo3VaNkmwGxLXE6fzScQOSBFcasV6BE6GmzFAH2aKev2TTLWeiTQ3xU4OSe0YTQ9M2vE+PbfsK368ayBm1Ck06Q1araVD/q82lyE6fxUuusvd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOf9uwlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOf9uwlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6010C2BBFC;
	Thu, 13 Jun 2024 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279900;
	bh=AgwQ1aNIuXOZ+HrGd6hsMW4Y9BjSo+p31RXeUAlQB5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOf9uwlKEgGtB3itQiXwiCLvSN/uYMKCrg0aZAiBZVyEkqiC7Q0W4zhoHc9IgnoC2
	 O+gWmJ7YCf5lJz3zJ7KosjsqkrGHZZ/TRcuYZzVM5mwVlLMYA6FLLAM213LasGJFxv
	 yxOSfIfcyDhtVpZSrRjTczphO21xHETXEoTDkins=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/202] media: ngene: Add dvb_ca_en50221_init return value check
Date: Thu, 13 Jun 2024 13:32:52 +0200
Message-ID: <20240613113230.630400988@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 919b297e645c5..622b2d2950a77 100644
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



