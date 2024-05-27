Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D817727;
	Mon, 27 May 2024 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838427; cv=none; b=ZJRmpFBBvB99nkk7YXSF2n2nR0n8x2zHV1vkYR0MGA/ElByaIpM8apIYhUSToOOL6BFfVcY/ibdQzp3l9dnjxQFmGWkgBO9Y2UMEGPattnOnAotE0Qxe3oD0u0MTW6U6PgHtYPERxzCsdRViyzpU896i5LPi2v72DfFxDq/J2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838427; c=relaxed/simple;
	bh=LUI19TU1cv0WNqlJQQ8saStdtZDTBF7pFKiQExkayAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYANayKz9qrKrLg9/L7I3qswzHXWaVCvGd2jDqpXHW/ItXun73VmBhIPk3Bbz+Efuxb8KEHyszmUAMWJD+5ejs2JdJ0y/vMlKT4M4s1rRLDVGRocTsMgS764wfEHVu6brf80d18+1D1kmpW8c2fpbpIHxC5p7yXk4gaTOoPU0Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3i/oWOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3i/oWOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4F0C2BBFC;
	Mon, 27 May 2024 19:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838426;
	bh=LUI19TU1cv0WNqlJQQ8saStdtZDTBF7pFKiQExkayAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3i/oWOS+Vc0eFLwhxsVxYZcpTSDRxu6XXoDwnBcxAK06PLo71Ub+mLXoT8VGq35e
	 TlqGyzMGqVnuDhVyUwGGwjAitEhfY2iagcAXwWCSrNyTdrGI9jVTpXkaxBQ1PvTApK
	 XDYn+5s1svbrhrMI6dwkuUPo647JeU25eIktXV/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 387/493] media: ngene: Add dvb_ca_en50221_init return value check
Date: Mon, 27 May 2024 20:56:29 +0200
Message-ID: <20240527185642.926070556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



