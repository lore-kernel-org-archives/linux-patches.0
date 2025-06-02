Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A494A1E;
	Mon,  2 Jun 2025 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876409; cv=none; b=c7d6RjUrpVE4+lsRn13v2mpCyeZs8vEEc7MTNts7Da57ijzopOYQAH4OcVxNkb6EsjlkS3mGeto994wjGDhnXy4UgkCJpYvu8gbsKDnV7hD64hwXZzULPPVrTRts7gm9IWpNJl1e9CL42i9vlnD2uspymOBRkRRVYGbXjwnUyHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876409; c=relaxed/simple;
	bh=ITfOYycW1RfcJdeauSEHePcCgDUBNsGls00waJw8ozg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZvG+ZFIpkRwQHQdfB20n5/Fd+YcZiyncbkX1k4TQ2RioklNw87XmPkPuhegh45fW1ARrRqX1nFvGgwdYczlNr6SveRZtbuVhc3VLUUUYTAoZeg0w/BNG+9MQb739OJIApU2BUnqTpELfOrfZ/IBQBy9N6/lOlkDpgmhIj+FQ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSLZ+d/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSLZ+d/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48954C4CEEB;
	Mon,  2 Jun 2025 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876409;
	bh=ITfOYycW1RfcJdeauSEHePcCgDUBNsGls00waJw8ozg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSLZ+d/1gjaA30uMuQVVDXp0gu9MtuXRiLu5T/cHuK5mATWzOTjrEZskSk5tsrw1P
	 QusVsZoz2eJrXDFd7TWE+kMvLyeg48sQEc9xTP9bptbj2aFW+LHjjOxDKheyuW0mfv
	 PRo45RvvVj4S8duWm+jKyNIe2feHseAuJH9hw2JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/207] wifi: ath9k: return by of_get_mac_address
Date: Mon,  2 Jun 2025 15:48:43 +0200
Message-ID: <20250602134304.635093009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e9a36dd7144f1..bbc9d570c4e3d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -639,7 +639,9 @@ static int ath9k_of_init(struct ath_softc *sc)
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



