Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF6215FD13;
	Fri, 15 Nov 2024 06:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653895; cv=none; b=XSQ7fBAdVob4VbQecloyOtYCvZ6/OhoUXsPTQ4NIfgbBxdjEt/Q6Uz1x1Qo2qq2j09VFE4da18pCxoBR8ueVwR0gfQSpB621gJSF+dFJ5UVHkUoLpr7ZQU864U3apZCgirqSYm18icbwNFOyc2swfiMVsMBuhGNFjU0YZoCR+e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653895; c=relaxed/simple;
	bh=za9oGLypB2cNlL25tNMmiO273REKIdidwMlhvnfoh5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtOmpr6lRCzsQNQKD2V89w/PnJafO2IRRx7UHV0iYeiNQQ4A7y3798+PlF39LBuXKBewB2bQ/rjI0x4zW4/0RVvRkVgxQukqkAXsNdjAFUvpINLutK1eBTpzB9WHVzvPMk44oUDrlpO1iU393O+Vcpj5JSc1Rl/A0MPRubiSszA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrTBrP6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrTBrP6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C56C4CECF;
	Fri, 15 Nov 2024 06:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653895;
	bh=za9oGLypB2cNlL25tNMmiO273REKIdidwMlhvnfoh5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrTBrP6PocwJa0jmkCrRxU2N6AJiuq/7y118MyWmYiHHgKlKuRxuv3M0hmc1CJERI
	 bpVYvUI9+2QOgc8hhEhQucu2qJQiyKVttz1eVX34l9OjGJsfVtq/2e2ymDdG0Qt61k
	 PLAfrhs5ISC5xEHAZ2oqlXSvSq+Z82WaUEQbjmIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/82] media: dvb_frontend: dont play tricks with underflow values
Date: Fri, 15 Nov 2024 07:38:01 +0100
Message-ID: <20241115063726.435345799@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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
index ad3e42a4eaf73..01efb4bd260d9 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -442,8 +442,8 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 
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



