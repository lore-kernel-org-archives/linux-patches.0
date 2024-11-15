Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8A41632DA;
	Fri, 15 Nov 2024 06:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653093; cv=none; b=boQv6CYA0kzPwe6NDujo++7nDOibN/LcpPhEr5jwJIz43CE/20lPn4GoYwfrtba8SOarG2PKNKWf6KAsDjX2yeYdDwQVssxLeMPwkt5S+Pxt2+vOhRdjfLxMxIH5eASvYzoZkVjnd13pPmbraJ8CbYth6sdyeZYfo0InUV9g/Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653093; c=relaxed/simple;
	bh=Du1OSXhdSP346y2/hO6QCI9fF148JcUuujsU++LIneM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBhyjhEqplgjJ3mxvYQ3SMD6UXvPS+GgboRNvU203m8XQQvI/v9Vj3sLGldiGEJ7HdKrytyIa+mRTLB1R3T0fj18iDlf1nG/qi80tPi/c8SFBI47zAThoGgWNxVIVfOJW4b8T6DBZj5q1E/Fq9vV6UPT79rJxtcAZoL+nBMoTKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGuMr0Id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGuMr0Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9A5C4CECF;
	Fri, 15 Nov 2024 06:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653093;
	bh=Du1OSXhdSP346y2/hO6QCI9fF148JcUuujsU++LIneM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGuMr0IdzqzT7wSVGNX/Wk10iHPz3D7HKI6WkIzgdTW5EJFKb1vbzpIQTP2lqgQr9
	 8G6x8bzFw9h4E84S+Wf1LwO0nkR5ZmQA3jVIR5Gt/MedR2XiukH2kN1OrJ3QHqIpQY
	 YP3nQ3MDZDlf60PAVoAzxcqsz6y003Hrm9YH+73o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/66] media: dvb_frontend: dont play tricks with underflow values
Date: Fri, 15 Nov 2024 07:37:27 +0100
Message-ID: <20241115063723.500886455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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



