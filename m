Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2745C1F4165;
	Mon,  2 Jun 2025 15:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877241; cv=none; b=eckewpkicBgnXpEtZYBxt1oqBsk4ngFTvlneu9V+Tv02fNv2sXL+M5w2Oz8EZafS6fh/mwCc+En1cDzZ2ak4jfPtcyx0SAAdsDGjcDIKrQ3bYFOFQ39a48+D31+iAJ7/pL3NUA8w6YR2D3JCOXLLdEHJD+KG/9ZM/R6vcQNrM3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877241; c=relaxed/simple;
	bh=8047DHaIOEHNoEkhaElM5lRjVGBJnomkQBIGPlsvSJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIU/sUvQH0gyKRVQ3FBsFezGIp2GRN3bKSeDN08zRl2wrFqEQGAPpopBa0aVmUSi6lJrkDL4PmjIhVkYGTbaRbB1uxtvL9kKuDOuCldpuyaQ4BNVKuT9SpT0K+vg3jWg2tnT9INVdPcwH3A44QUBdUmP6Z1oPjfkKhsegjmH0lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0849UCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0849UCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AF0C4CEEB;
	Mon,  2 Jun 2025 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877241;
	bh=8047DHaIOEHNoEkhaElM5lRjVGBJnomkQBIGPlsvSJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0849UCG+orL2RtiqGBtKYcf1Pgh7Wmq0kTkMQLatqgQX3CiLu4jV93QyosijDMpu
	 tGP4X3SFip88r1IdvFke1B/b8NAg42y4iV0RswtF2N0lrUC/YT6GXCTFFo6bPj7g+8
	 TvjEAOhbyOko+KYy43SbZBn/MAD5QMpJFaicF8FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/325] wifi: ath9k: return by of_get_mac_address
Date: Mon,  2 Jun 2025 15:48:12 +0200
Message-ID: <20250602134328.571298640@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit dfffb317519f88534bb82797f055f0a2fd867e7b ]

When using nvmem, ath9k could potentially be loaded before nvmem, which
loads after mtd. This is an issue if DT contains an nvmem mac address.

If nvmem is not ready in time for ath9k, -EPROBE_DEFER is returned. Pass
it to _probe so that ath9k can properly grab a potentially present MAC
address.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20241105222326.194417-1-rosenp@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4f00400c7ffb8..58386906598a7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -691,7 +691,9 @@ static int ath9k_of_init(struct ath_softc *sc)
 		ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
 
-	of_get_mac_address(np, common->macaddr);
+	ret = of_get_mac_address(np, common->macaddr);
+	if (ret == -EPROBE_DEFER)
+		return ret;
 
 	return 0;
 }
-- 
2.39.5



