Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819A413A411;
	Thu, 13 Jun 2024 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281030; cv=none; b=ps4ctP0hk8uBSi6P8R/eYSoFs0asyBrJ+kWZy0Oy6z0/aT7kNruehIoh3K/k+nPKVa+oHNc1UTVBUjP05v0nAnIPxHoWBqtlwdy479wt7gGx4rfCMUGCJtntukKx7kuUgZ6Zb90ZVrJgnAb8ijQU8yfFjsSl5uxUj+UqU9R9Vgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281030; c=relaxed/simple;
	bh=RCviqpWGABC95qMDrncK7JFywwzymjdJu3zNZopbxow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGGwY60+yNQKn77drkOfLjHNn2XiKXzajenX/wI8UGTcskZLlsvfZpT85vYGD58Kd3eJ0N6g0DUUsibcUZjpqXVl76eDahVyPUynMJknZD3MnXW726yvvmrTxek2W22rrcdMgDJogTjVFRJP9P8v7ZYRYS/RrZsHmtBuk5k/7M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHeK/2fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHeK/2fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E822EC32786;
	Thu, 13 Jun 2024 12:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281030;
	bh=RCviqpWGABC95qMDrncK7JFywwzymjdJu3zNZopbxow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHeK/2flXCglI72hGMUL+7zjOy00BgyeVv+R/pUmT3+4tpzvwgatG+x+QuJsKwKce
	 JpkV6pjvcZmu9n7EKx0VPHCJwDS6BQdn0ZAjO/3V3tUWgpvOnYWqi0OqIDZoEvTqVU
	 fZZbMTARbW8PU2Z4RVCe57AqFVJKBcjUZc6irIfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/317] media: ngene: Add dvb_ca_en50221_init return value check
Date: Thu, 13 Jun 2024 13:31:57 +0200
Message-ID: <20240613113251.380732997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e1a8c611d01b4..97cac9770802b 100644
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



