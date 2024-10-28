Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4826418FDA7;
	Mon, 28 Oct 2024 06:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097346; cv=none; b=r9lojam234O7ayAuarxBoVno3SI4vmS4V5+OoiAR5Qq6x3J7PCVFXgt5/4owMRnmv7W7/X7T8r8mry3A+fgwm5byyr+Bb3yCI0V3sBKfP1B/r2QacWFmGqCje0G0i0xfVaDafn2Iuaw9jzZRFyZ+RrVGsbDktKrfWRyAOJK0wK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097346; c=relaxed/simple;
	bh=H1tttnmm0LRvw8fGTkkZ1+zlj/zVqfMb+oJHbzAX+LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsHUue1Ltl0BEeEbR9gp+KUdn8DXHNzJ0JmiHfVzZzIHcAogx0rAxLnDREAVt72PFwQewHheaEWT0aS6zIzuOt/lB5UCyvokFaUYsRoKvVHX4qe1UeN1gVWs8474upmCK58+Qpe+4D2puqMoSQNroTif9ZiTXU7T1MkrJx1eMD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grXTp2JN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grXTp2JN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A6DC4CEC3;
	Mon, 28 Oct 2024 06:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097346;
	bh=H1tttnmm0LRvw8fGTkkZ1+zlj/zVqfMb+oJHbzAX+LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grXTp2JNH93CG+O6giakcBq0YMPHLWfxvsRxPQCFHBwlgsRiO28CwLfW/V910S7h2
	 MOE/XOkmwX+ZX1hHrAmBkRe3lqjDnExSJMCeAJrwCys6JV5uRFxIDM/wYbuJSlDJ2t
	 1Gge3WvwNzAU0Hl7NLZQczvoxnZuLNQvmOm3BbS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Boehm <boehm.jakub@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/137] net: plip: fix break; causing plip to never transmit
Date: Mon, 28 Oct 2024 07:25:27 +0100
Message-ID: <20241028062301.240185641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Jakub Boehm <boehm.jakub@gmail.com>

[ Upstream commit f99cf996ba5a315f8b9f13cc21dff0604a0eb749 ]

Since commit
  71ae2cb30531 ("net: plip: Fix fall-through warnings for Clang")

plip was not able to send any packets, this patch replaces one
unintended break; with fallthrough; which was originally missed by
commit 9525d69a3667 ("net: plip: mark expected switch fall-throughs").

I have verified with a real hardware PLIP connection that everything
works once again after applying this patch.

Fixes: 71ae2cb30531 ("net: plip: Fix fall-through warnings for Clang")
Signed-off-by: Jakub Boehm <boehm.jakub@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Message-ID: <20241015-net-plip-tx-fix-v1-1-32d8be1c7e0b@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/plip/plip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 40ce8abe69995..6019811920a44 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -815,7 +815,7 @@ plip_send_packet(struct net_device *dev, struct net_local *nl,
 				return HS_TIMEOUT;
 			}
 		}
-		break;
+		fallthrough;
 
 	case PLIP_PK_LENGTH_LSB:
 		if (plip_send(nibble_timeout, dev,
-- 
2.43.0



