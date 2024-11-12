Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB220D4E3;
	Tue, 12 Nov 2024 10:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407314; cv=none; b=K9MFwtjN22wGtW3rasROGheMUnVTi+G/2l1CfRpBg/KCqhCLtgd3p1SbIJnYWcKDQ2gk10HBBnnyCyp6geBZvzg9XerhrgN7235PRRaqZzWsfp8uTaT8MbWWzKg3ViqU+0p/zQ1sQR0gr/WrhQ7sbr5vif+zYtfQjDtm91DvfYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407314; c=relaxed/simple;
	bh=5XWWtCIdaN4NO2m2JwiMZTwSIjXhCPrNcqlzJMipU4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDQ6p0K3tR6EnVOC4PoPmh5ryzt5zbL8O1t9guZJuGFA6KwAVvne/5cT6mJ8E9aixx22KvKeU5y8i38E2Xtzop1/hdNNTFkjrdBlcFJq4+kU0X0odl92o4DeVVpurZWuIpztON5h9B9Ow9RXQutW/50LLnbbaxwFdBHFCmUNjC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVp5p2hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVp5p2hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C804BC4CECD;
	Tue, 12 Nov 2024 10:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407314;
	bh=5XWWtCIdaN4NO2m2JwiMZTwSIjXhCPrNcqlzJMipU4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVp5p2hvVd1p+4tSZ/TmqPh0eIE/sOWr27T0rkTUVHc1QzEQVs+xfcTEr46aaSoYB
	 a460kmM/bo+uFc0tN+TrmpmQvLE/QfmW9vW3YSBO/5o6YiE05Zo95hRyRu4p6nfeje
	 OdU48ix2FarboY1+l42M4EFvSDQjB9dUn5QlsZsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/98] media: dvb_frontend: dont play tricks with underflow values
Date: Tue, 12 Nov 2024 11:20:52 +0100
Message-ID: <20241112101845.686589658@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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
index a1a3dbb0e7388..a997cffbc8ea2 100644
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



