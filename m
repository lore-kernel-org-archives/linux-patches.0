Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122703BBEB;
	Fri, 15 Nov 2024 06:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652777; cv=none; b=EoWU/bYfrDEHR+Aa7pHlmnFTzHrZyzLnSXIOKjcUDYGWukPyQ8RbBSy7ejMBamfpmefRGccbtfA92RwyIOHbgi5RoW2MB+NyDLBaRFDZlZAAeV1YYrwPERHXAP2QxL9tZEYrs9a4dPE9ByZL4BLVLHqv/cYgHA4A14z7kkO+moY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652777; c=relaxed/simple;
	bh=CJn03oE6x6/JZZrWq6LdeZWyyifEbJJtPf7F5Sm9NOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0Gajx1NqVrDIHSPMvMEmO33vJYWm++FwJ1po3gmDPjhlMDatoOuhP1E8/Fy1pVTYprkiKU94k/0TtlbRFy4MDhCXQ9puxniX/r0EWj9Hh3AOMalELDOte9fBFyWq/kwdx6CgnOVkojxg1xpR0IasS3+kaxowY1NI+af9E8CeIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8OXEHKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8OXEHKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAB2C4CECF;
	Fri, 15 Nov 2024 06:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652776;
	bh=CJn03oE6x6/JZZrWq6LdeZWyyifEbJJtPf7F5Sm9NOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8OXEHKyliQP7nT1OyeCS3KIyNBLKZmwcnMAsY2p7xHjvq5Yz4wVebVoE296ZWVwl
	 hlm+FXLTe+iGU3xucJGKgpIzKRe0CzXgGPrw8OMvT+ujboWudxHxsWfAO3pRZBDvah
	 KPv6RHEXuusglBEG/FW39pY5CKIxuoRsCNIHmJzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/52] media: dvb_frontend: dont play tricks with underflow values
Date: Fri, 15 Nov 2024 07:37:25 +0100
Message-ID: <20241115063723.296057793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 90acf52cc253c..6082a8019c151 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -454,8 +454,8 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 
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



