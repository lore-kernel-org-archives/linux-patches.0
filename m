Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD8254873;
	Mon, 24 Feb 2025 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408457; cv=none; b=mFYH8meIwtt8EoBeE1I34suXfFeO+FT14e6Bc5pWZGAkgVPQ8Jqu2XPuyld/uDNVYnslskcXAhDM8PplTbexDS/S/XbTyedkvJpTUnuuyDs/tB0Tma704hi0dvWeChOOrLmq8OsTM40djlavGoRYFIRpEjNfR49+wcRoYMXGDFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408457; c=relaxed/simple;
	bh=lrWt3OWdAW8Yf5GaMv6KsPVlml2WoW7gPx2630hA9W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwvFfsPOFDE2NBKhj15nt6pwkcraneYTbuTCNpMNBibBOOmmDfU+NJ89cdPM8rxLOvLGVGlgaLvFWg24OZPNyJChPKC6O+SYazM44Xd9kzlk4R9w1lUAZwxwLlcVoEDpWepORfdtmt5cJVE98t8B6mNuAZVYyRPZQ9sKM9/JORY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjVHWrK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjVHWrK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A58C4CED6;
	Mon, 24 Feb 2025 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408456;
	bh=lrWt3OWdAW8Yf5GaMv6KsPVlml2WoW7gPx2630hA9W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjVHWrK1zwIW2JsVKNszxcCCE2F0oKqLE2iOUNa2jyb+suWJoL0cey5XRSa7qIF6V
	 4NhqgIVfj6Ldw+V+qoDC9TKgJzMZqu7iuzTCHa+Ebm/qFAVCRNfii7jtxDh29yRez4
	 r0nFoe7kmhFOD47F6HccQQZ6+DBQSKmBVLR+NsmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/154] net: pse-pd: pd692x0: Fix power limit retrieval
Date: Mon, 24 Feb 2025 15:34:23 +0100
Message-ID: <20250224142609.587711079@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit f6093c5ec74d5cc495f89bd359253d9c738d04d9 ]

Fix incorrect data offset read in the pd692x0_pi_get_pw_limit callback.
The issue was previously unnoticed as it was only used by the regulator
API and not thoroughly tested, since the PSE is mainly controlled via
ethtool.

The function became actively used by ethtool after commit 3e9dbfec4998
("net: pse-pd: Split ethtool_get_status into multiple callbacks"),
which led to the discovery of this issue.

Fix it by using the correct data offset.

Fixes: a87e699c9d33 ("net: pse-pd: pd692x0: Enhance with new current limit and voltage read callbacks")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20250217134812.1925345-1-kory.maincent@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/pd692x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pse-pd/pd692x0.c b/drivers/net/pse-pd/pd692x0.c
index 9f00538f7e450..7cfc36cadb576 100644
--- a/drivers/net/pse-pd/pd692x0.c
+++ b/drivers/net/pse-pd/pd692x0.c
@@ -1012,7 +1012,7 @@ static int pd692x0_pi_get_pw_limit(struct pse_controller_dev *pcdev,
 	if (ret < 0)
 		return ret;
 
-	return pd692x0_pi_get_pw_from_table(buf.data[2], buf.data[3]);
+	return pd692x0_pi_get_pw_from_table(buf.data[0], buf.data[1]);
 }
 
 static int pd692x0_pi_set_pw_limit(struct pse_controller_dev *pcdev,
-- 
2.39.5



