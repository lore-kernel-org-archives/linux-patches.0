Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82AA223C4D;
	Thu, 12 Dec 2024 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024927; cv=none; b=iBLWonbfS/L0IPU7yUVV7141ADgFgdzKL7ptUYbdZx6e9m8wqbwKkUo3pUwZJTo6MAcKmdVNsfzAtpnAJ3GlllW98awf9vvHUdlvGoJES+ADHzAZi5HwwtmlM5F/6PE8tPQDVYwEw5LDp2YN1fYCUMsfZSZfhGvEZEXZwqijr9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024927; c=relaxed/simple;
	bh=p+RPVygtviPffRqSfD31NyezxNiVPd93uoRvpM7rR/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoH1CaO8X1Ok8oBRuSWNMjdwUb6+x8xSm1C4xQ6L+OZvAYKleSn3wr2if4ry+8K/YYTMAIgu9TcO7s8TYe88wluk3j4vM52P0pweL0VGqpDbx0sDD6CuMvCM/9413mib0tXo9zU39gchnaSuxjrQQyBaS72VJoQUbitJzGYwZs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c2cFNBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c2cFNBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBF1C4CED0;
	Thu, 12 Dec 2024 17:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024927;
	bh=p+RPVygtviPffRqSfD31NyezxNiVPd93uoRvpM7rR/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1c2cFNBtaj7Y7noQ7Q6cFOxkrGxmHyCc6z1mMG/CZgxL/hjw7qkaTMhP4imjBfSCc
	 s3v1dqpec6wI1TgypU5qoGEaB1wGay7aCc5yGnEZ2ldJOAphEvwV71lpkuSMdbiIlz
	 3PQH0EKMnTJ6z9w3F1vwIn/6PDsDtj5aMhSb63zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 459/459] octeontx2-pf: Fix otx2_get_fecparam()
Date: Thu, 12 Dec 2024 16:03:17 +0100
Message-ID: <20241212144311.899327994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 38b5133ad607ecdcc8d24906d1ac9cc8df41acd5 upstream.

Static checkers complained about an off by one read overflow in
otx2_get_fecparam() and we applied two conflicting fixes for it.

Correct: b0aae0bde26f ("octeontx2: Fix condition.")
  Wrong: 93efb0c65683 ("octeontx2-pf: Fix out-of-bounds read in otx2_get_fecparam()")

Revert the incorrect fix.

Fixes: 93efb0c65683 ("octeontx2-pf: Fix out-of-bounds read in otx2_get_fecparam()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -805,7 +805,7 @@ static int otx2_get_fecparam(struct net_
 		if (!rsp->fwdata.supported_fec)
 			fecparam->fec = ETHTOOL_FEC_NONE;
 		else
-			fecparam->fec = fec[rsp->fwdata.supported_fec - 1];
+			fecparam->fec = fec[rsp->fwdata.supported_fec];
 	}
 	return 0;
 }


