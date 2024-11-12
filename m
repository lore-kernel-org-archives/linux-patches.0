Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8D121503E;
	Tue, 12 Nov 2024 10:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407697; cv=none; b=uGlJr5ExFR+kuszsSx8GLmesETO9qAEHOImDlSc9AO72QYtOfLwcw8Rl+5C+d/XLRD5ZCJw3cicvDaKnM0zo9ctW98shin+4FHRLdkbfvbiPwDK2zpYpZ1/UlMc9samHUzMje2YkWKLTk8N62XjyVBNvIXoo3bgBAEFnHBNpv5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407697; c=relaxed/simple;
	bh=4h6utmM2dWnDCGutz6V91F76dXFo55QX4TziDTONx/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er5MHaU8XtupcVb7evtyA976/yid+IXk9VimkniQxJbw3EOceG2tH0bjttutnFgD64YzXw15HhHFlLQ+pqx4bulz48wUk72iBtWPhvPmhOWlEFOS4T6qR7LyOFst03C7dtduBzrzib6jxZGB0gZmRqd2RU24be92FJsVITLFpXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01YCSqQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01YCSqQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8B8C4CECD;
	Tue, 12 Nov 2024 10:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407696;
	bh=4h6utmM2dWnDCGutz6V91F76dXFo55QX4TziDTONx/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01YCSqQD6iHx4jSKYg1JbP6s4li/UO3tNhRf60LQ+qxTgBuy8R4WYElb+C8dcStyE
	 6/gkJMafuj9Inup4DbNTRQmbZgSKs/JJi8a+Pg3fYMFwtmBnqQSR3i7dWjbZBGv8Ds
	 jKzJqYZ7FKydqCXmpQUEKhHJDlY1mLDYd6LMTRHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/119] media: dvb_frontend: dont play tricks with underflow values
Date: Tue, 12 Nov 2024 11:21:01 +0100
Message-ID: <20241112101850.743483291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 93d3378a0df4b..344dc9dc6613f 100644
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



