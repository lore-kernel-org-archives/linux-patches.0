Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4CA14290C;
	Sun,  1 Sep 2024 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208184; cv=none; b=jeAep8WaBbx/+i3ERS8dsUW4+M+X/uJS2P6PorZ1OPByhGDXHo/Q00aVmNenarpx1ijz9UppRfkAs0d6lSM7bnCVXU+PCofTdNF3EAAxwqLyVdbIzHeThxo6PJ2hP1wVEt7Nm+CaFK/rUc7rozRK/jzGzKWhNMaICigA25sa8CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208184; c=relaxed/simple;
	bh=rJUXkhaQBrvuwYpNislF1gjtbTjB/dR9/eceG0+if+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9Uo2h7GpyBAcrMvmnVt8CJFRToQpKaJjjSdJIhkvEtbZdL7WXhV4advmj3BPKU6L53qoEIq4KP3wxrxeFpxAWKZ9TzxWkBZDjeGxO79DXWKTdJ4PoUCauIgnsDAblQbVHWqXPO7MI62ArU+8RNwld76D1ocm3Fu95YX0WB6bwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA7Mi4+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA7Mi4+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E75EC4CEC3;
	Sun,  1 Sep 2024 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208184;
	bh=rJUXkhaQBrvuwYpNislF1gjtbTjB/dR9/eceG0+if+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FA7Mi4+iZvthXMH2yVxSHPxz5ah25xMReA3TrOZi3/l3yYXarGiXTnofrIvZrBqCD
	 7uzMFVr+3Dw8KLKJmffUHkhsaySOkd1UEvdVS7H4qCxABezESSuOLb7KvKJHrJHHIm
	 fumsnHLVEFauYQoq6mUpB8GM9g6VVR2Lup6u+qXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 69/93] nfc: pn533: Add poll mod list filling check
Date: Sun,  1 Sep 2024 18:16:56 +0200
Message-ID: <20240901160809.961949750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit febccb39255f9df35527b88c953b2e0deae50e53 ]

In case of im_protocols value is 1 and tm_protocols value is 0 this
combination successfully passes the check
'if (!im_protocols && !tm_protocols)' in the nfc_start_poll().
But then after pn533_poll_create_mod_list() call in pn533_start_poll()
poll mod list will remain empty and dev->poll_mod_count will remain 0
which lead to division by zero.

Normally no im protocol has value 1 in the mask, so this combination is
not expected by driver. But these protocol values actually come from
userspace via Netlink interface (NFC_CMD_START_POLL operation). So a
broken or malicious program may pass a message containing a "bad"
combination of protocol parameter values so that dev->poll_mod_count
is not incremented inside pn533_poll_create_mod_list(), thus leading
to division by zero.
Call trace looks like:
nfc_genl_start_poll()
  nfc_start_poll()
    ->start_poll()
    pn533_start_poll()

Add poll mod list filling check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: dfccd0f58044 ("NFC: pn533: Add some polling entropy")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240827084822.18785-1-amishin@t-argos.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index b19c39dcfbd93..e2bc67300a915 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1723,6 +1723,11 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 	}
 
 	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
+	if (!dev->poll_mod_count) {
+		nfc_err(dev->dev,
+			"Poll mod list is empty\n");
+		return -EINVAL;
+	}
 
 	/* Do not always start polling from the same modulation */
 	get_random_bytes(&rand_mod, sizeof(rand_mod));
-- 
2.43.0



