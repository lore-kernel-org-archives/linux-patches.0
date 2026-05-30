Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6830E2FDC5E;
	Sat, 30 May 2026 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165998; cv=none; b=GlrArMoACfBu0ngELAK9PaQMdEKh8QH4TJ0B9lP5PUlszP9ycA/aBc8ODALqQXh6NfbRJmXjpZPMOw80z0vHwe0d0y3DbU93xjUO3yA53DKobCKVqHzpxIzexb3iR3757mWqBgyHm0YtBhE+IBkf22CvMUkk6JKOSt6nGqVT9io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165998; c=relaxed/simple;
	bh=Xxc/+N+5yQyKert0roJlcxCJSlajve5dykK120sX1wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0mT8nGarTBt0eGogk9eeojmkt1G1RxSjKavMPiomGWt1VUCgMRvm7JD1/7siFbyLuLS4p/mmobm+SRRP1PLtxvpoxV0adYlSbRZbE1xYeZMV4hrxa2Wnm0ThL/1zoGffI2+sjitu8oQnymCPEjcnnmxeSEX9dgY209tD++phT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWYHRd3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWYHRd3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABADD1F00893;
	Sat, 30 May 2026 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165997;
	bh=w1cYTU6WZ7IsiSYBOgC1Ak3iY70TG2v1BUyXxCd5Cqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWYHRd3eYRSG4J3i5pGQwQigc8uTo01R3NcaAD7lVKZmV6viIju6QFN2l2b7r3TpH
	 hArntNfzQwG6myidU/UuHMvLv5cfPvVUD+mw94Zqxsm0vzrV2y4VNPxzC+sSDH0f8D
	 By3xAudDoR0opLpXtvsXxHdrcYfuDaPRbFmDG45E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/589] ipmi:ssif: NULL thread on error
Date: Sat, 30 May 2026 18:01:36 +0200
Message-ID: <20260530160230.622907022@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Corey Minyard <corey@minyard.net>

commit a8aebe93a4938c0ca1941eeaae821738f869be3d upstream.

Cleanup code was checking the thread for NULL, but it was possibly
a PTR_ERR() in one spot.

Spotted with static analysis.

Link: https://sourceforge.net/p/openipmi/mailman/message/59324676/
Fixes: 75c486cb1bca ("ipmi:ssif: Clean up kthread on errors")
Cc: <stable@vger.kernel.org> # 91eb7ec72612: ipmi:ssif: Remove unnecessary indention
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index e93846f8f2352..4cbfe1858ab4f 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1910,6 +1910,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					"kssif%4.4x", thread_num);
 	if (IS_ERR(ssif_info->thread)) {
 		rv = PTR_ERR(ssif_info->thread);
+		ssif_info->thread = NULL;
 		dev_notice(&ssif_info->client->dev,
 			   "Could not start kernel thread: error %d\n",
 			   rv);
-- 
2.53.0



