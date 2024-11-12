Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67632101BE;
	Tue, 12 Nov 2024 10:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407131; cv=none; b=LECvCz1IS+oj1bKvN5+bbjnor02P0VRrxkbS+ZlRKB5U53D6qM398ysKrv6Y44tV86w+8R+sv+qYEP6nEg6woMLpizLdlu5F0UPjrlttnrz1qP3M75C5mXug85sVwqsNHI2kkVT1pJFtX+8CRm+NtUyMeTLFdr3uevKoXWyf5rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407131; c=relaxed/simple;
	bh=PqspOwxT3SgRETjd7tEVMWZfPo8BHdEE0cu4y0DevKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdywxoVpXP3Qc2avAak0sEfqP/uFuIabigAvP5kj7W7FgmZIMOAA0wq2VRrwXn9TjSRI08N9K9nuqpCntT5uMgej/ejIzQDpOiCHjjM49WkwZ92tQBJk/K914rJYhsHXBj4tJ4iLh8yfzEWslaTjp6dugzKtsJPZ7TpmYvd8zD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VthABOkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VthABOkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AEBC4CECD;
	Tue, 12 Nov 2024 10:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407131;
	bh=PqspOwxT3SgRETjd7tEVMWZfPo8BHdEE0cu4y0DevKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VthABOkBY5xnPyiRDyDWrCZpT7L6gjORrU1xt/dayHxa6Hfe9g6xLgkIh3YAb6umf
	 ard15yoP6UjR2o4WUGL0Cry31rV2AnqmAo83HwJ+dToBnaDF/ouWTj6xKBsXtJF6JP
	 nxug4Mxhcl4yT0BivQTkP+i4cw0L9kt8SFoKD0TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/76] media: dvb_frontend: dont play tricks with underflow values
Date: Tue, 12 Nov 2024 11:20:53 +0100
Message-ID: <20241112101840.859070447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d76ac3ec93c2f..762058d748ddf 100644
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



