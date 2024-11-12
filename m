Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF96D20E337;
	Tue, 12 Nov 2024 10:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408230; cv=none; b=Dzmke41GBNeGgEPAWj6EG9/5/5XVtlEd6k+TSwy+xyVOipMcF8q/2rcyym8UD7D91KoJMtIRr0d9mDhO6BUMt3j8/fSPAdpuwp9hXuIlbtWMQOTgW5NC9sYB9Bs0FapkIbooT0QNL+o9522ZhhW7BMx1HBuYqZ4k0WJZaQghR9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408230; c=relaxed/simple;
	bh=uxaG6q5CqT0Oh1dWd2ShCeTn5cHNdYy8VlBtsmOBzEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pu0jKNgP32LCmkp9Iz9VEQRmfXfHlE8k1Cyy6j5WHxbE50NOLrwLe7HyRxhWQ3Ny8he6yucO4O+rWhFnL1Hzv6bvgdXlEFSG6TrFStR+AagivqCz+A0Eb1mQvsti+if3M9zHluihGekaoUAR7lz9HYHZEk2Q38UEouAkv3HEOAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/JOSk94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/JOSk94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F48C4CECD;
	Tue, 12 Nov 2024 10:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408229;
	bh=uxaG6q5CqT0Oh1dWd2ShCeTn5cHNdYy8VlBtsmOBzEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/JOSk945aIHLYR4zmYOax3C0vyC2SwVXS6KxbeVkyRdVfLMWoivDsOj1c7P7xUvF
	 LaSvtgPCJ4HwB0rU/f+I3Ed3fJJBybQzDeK4E6FAOuJUuI1FWUzTke931f/gFvQ9vk
	 aTSHarFDwqDXiaj1lEV8QtOo9Q91Tq1VRmUfNeB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 067/184] media: dvb_frontend: dont play tricks with underflow values
Date: Tue, 12 Nov 2024 11:20:25 +0100
Message-ID: <20241112101903.432720171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 9883a4d41aba7612644e9bb807b971247cea9b9d ]

fepriv->auto_sub_step is unsigned. Setting it to -1 is just a
trick to avoid calling continue, as reported by Coverity.

It relies to have this code just afterwards:

	if (!ready) fepriv->auto_sub_step++;

Simplify the code by simply setting it to zero and use
continue to return to the while loop.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 4f78f30b3646e..a05aa271a1baa 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -443,8 +443,8 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 
 		default:
 			fepriv->auto_step++;
-			fepriv->auto_sub_step = -1; /* it'll be incremented to 0 in a moment */
-			break;
+			fepriv->auto_sub_step = 0;
+			continue;
 		}
 
 		if (!ready) fepriv->auto_sub_step++;
-- 
2.43.0



