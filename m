Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061687;
	b=vzNEH4Ha2VehPQ1aT8+MXh7LhTIkl4fOXP6dYhaxa4eKpyJtK+yU70L4S0/m84ZJDPkA
	 ON/t9tYMx0aSgtPGjy6jY6urPbiDNnq096HjNx6q1hCyJeCII3L1iqH+BzMDjH/btRZnu
	 8Q2oPSgh11bfempnP/NbCA6G4qHBPjK/c/aLJn8UADi5NLg7PYnVO7Zy15AQyY1ciWg2l
	 FUSe/6HTPwYfweQAdtMq+AnCoRur5HJTcOL+SLOF608vU5tBL6pULLacwbNH2ve2gPsJo
	 RhHSA2FanKpgrPaZEkuY4voa2a3+mbjp2nqf5jd64YUI4M8mxa8S9yFmb+VosiYguFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=teCvVRChWbulfxhM/4stTkcB9t+vybpo+42Td+BIdxs=;
	b=uj+3D981hOFVgiMyx9I+eGbcowG+F3xZfAd6nqFxkoLhgbmFfxLBQz3+78L/GfzxxDzF
	 y5cR1mXPl614Kp1awtzUTU1sUci+/drJfeAkf9DTSmJxBp5h7Qd2Fc0lTu44b6d6VmU63
	 QvES8a08jEeCPN4JuvDrX2Kb40TUd88k74RvTkZ3wepWVF8oSStxEwWM8QOJl8cU3PV59
	 KpvICM9m0WLmvZWlj4w6zFPYpefSCpZulojD0TgNYQdKitvJHpE0oqLpp6DF7iwfjTGTa
	 j1tCVq010oTH7uMYwiPAsnVtMUsaTkYsXxwS1woLPHEzQ2AQp/FIYvhXyd205/14z3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQTu4NH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86A3606A32C;
	Sat,  7 Nov 2026 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQTu4NH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D6B1F0089F;
	Sat,  7 Nov 2026 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061686;
	bh=teCvVRChWbulfxhM/4stTkcB9t+vybpo+42Td+BIdxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQTu4NH79ZRWxPHfYF5IAN+0Ww2VhxzoiCSfEK37r+CIzbTGu6bF0bWRTAY+9jTNB
	 w2zV1J4g9dZdxUumuGfogoPFLDY822oqDaroS1IKMAwbqzRmG8fR5h7zlL0Er9YjDA
	 Up8EDGHatlQebDJY362+FVt7Pb7WxfCU6sDcKTYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0737/1536] xfs: dont overrun incore inode when cleaning attr forks
Date: Sat,  7 Nov 2026 08:45:53 -0500
Message-ID: <20261107135018.216116587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit c28b4b48deac17749ed1ebe4289a4ba73541ddc6 upstream.

LOLLM noticed that xrep_dinode_check_afork doesn't check for a
di_forkoff value that is so large that the attr fork would begin after
the end of the inode space.  This causes afork_{ptr,size} to be
nonsense.  What we really ought to do here is zap the attr fork.

Cc: stable@vger.kernel.org # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1071,6 +1071,8 @@ xrep_dinode_check_afork(
 	if (XFS_DFORK_BOFF(dip) == 0)
 		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
 		       xfs_dfork_attr_extents(dip) != 0;
+	if (XFS_DFORK_BOFF(dip) >= XFS_LITINO(sc->mp))
+		return true;
 
 	afork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 	afork_ptr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);


