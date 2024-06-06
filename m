Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C85196DB4;
	Thu,  6 Jun 2024 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683350; cv=none; b=M71cMJ0bXs9E28HAdVDE2b0Z/sou9gjajPRTb11NslZg9WIQmLMnf8VjQ2hBdscrAMsZsgxWj0JAandTAxuRm1Qr18kzlyp8c2LsgoC/oRxx7DZVqqB1fYA3hiJYSy2kCuclHhcn6bnVYVc+1xZK7pRXHVNVVRdfkB6fSLANwz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683350; c=relaxed/simple;
	bh=y9hZyr8XY1Soxqk1yVgf0UQKapC0qYt23stIcbG26sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCouLsnCFfctqeRIlTYW5imq7heH+2plG4M7oiGzJUDQRaw+SYACdRNqxYYjaMx+9IJo13BgNDGrkRLVsXwZETKF7QePZ1KCRzo1UAqccVmFn39gNXwGz9a5isUhzpjTD3vM+4puIWzsvgRfP3ijInD3tMBM8MWjIdKGSi0lwUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQWAu0eU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQWAu0eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59543C2BD10;
	Thu,  6 Jun 2024 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683350;
	bh=y9hZyr8XY1Soxqk1yVgf0UQKapC0qYt23stIcbG26sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQWAu0eUT40MC5p8IeAhwOCl2I8j2kBSifUejnGXROvCTesgsvS4VpHTO4KhnSqyy
	 U2aiKqTOFiZFMpsTDTd/uRf6TBENBWC3EKKJ43Fk8v9cJp7Sy+NSr6v2LecA7aFGh2
	 z8RAUW72pLBmVedxO5NxhC7AQpUNro8T9c0Ajwws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/473] media: ngene: Add dvb_ca_en50221_init return value check
Date: Thu,  6 Jun 2024 16:02:18 +0200
Message-ID: <20240606131706.830634344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



