Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060731;
	b=orz+eWKZF6RGuTsK1FnAtofe3Fi52c2afRqLHxty0dEt//f14GY2dY8dFtxz+aYGdCqk
	 z3wuRc3UYLoRp8C9u8iEzF3wPloPFlyDDcja6BJ0eaRC9K8IBLd5Rgh/VxGrT/IvMkP3u
	 j6mBziBzghPvL2Mgnw4QgBdWIwbvN3Vd2ceAqqZaW6IoTL08OfiShj/ddmG4jONcp1+ZT
	 06ZsS46Qto39sgExYorKQr4Zlo+cfkvj7XI4oHCuYYXASvBD3Wyd3sUcaUCRksg1ZG5I7
	 iS8Mw5PV3JZ+SAWf2reJy6LoqCc4wgqqA8HbJED7VEfjoIBQZlaQkc+i4uHBhYST57g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7EKrrVzsnfTAp0fFqVt8fvUzUD+sTdZOtn8PBfSNBnQ=;
	b=FYxSMDUplWKMJk9yYhcOiJ601K5HXwzaTj44236fxEvZwN4HCkB7SbrDFFb3OKWYGwXt
	 tigwXUwz99OYBv/axfUuArjyTFGt92bF+FYGn3cdthzVeWkG2wNeib+f0E/Nhv957wq4t
	 qs9khp4NnVm99dV9HnQiAx0lIwxGxenBaw/r03EFnwMVJzy426zISHrxQpSfccAqcFaSG
	 et03mAuhPx4XCG98F+PWaH7QuJdgbvnd/pT5tCcOyO5xLGI6b6IIaSyv5tcfRi/l85u/L
	 sSwsAu/+6JoqKw+78F4Z7ATUhaP1hHQ9iiB3z7HJmITrpBIXqL5B6bZDbG1u6te1zIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCVXkHID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24676606A320;
	Thu, 19 Nov 2026 03:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCVXkHID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FB71F000C4;
	Thu, 19 Nov 2026 03:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060731;
	bh=7EKrrVzsnfTAp0fFqVt8fvUzUD+sTdZOtn8PBfSNBnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCVXkHIDujWsZ+ftz7ce0uAsihxfecddcNb5iWH+XOPA9mYTkufHLIjB+Qgy8aKCz
	 NGY0TcWME2G0XUazPuUoxUCwTV4CIj7BrTvirgfrd36fy+fYOBzVfphhRsaLb9IedR
	 VGFLdcl8mrdl7AYSv+BoQRoX7HNAPzG3XTrtipck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1304/1848] swim: Dont disable drive after every sector
Date: Wed, 18 Nov 2026 15:55:42 +0100
Message-ID: <20261118150014.083542330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 05a7c4b197279cfb3ec3df26146ce085a2438aec ]

This fixes multi-sector reads on a Sony drive. The Mitsubishi drive
doesn't seem to care either way.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/fc511e72753ae18b6f021701aa00d480335b0caf.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index b65e781a2bda6..59dbd2734824a 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -471,8 +471,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	short i;
 
 	swim_track(fs, track);
-
-	swim_write(base, mode1, MOTON);
 	swim_head(base, side);
 	swim_write(base, mode0, side);
 
@@ -488,8 +486,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	}
 	local_irq_restore(flags);
 
-	swim_write(base, mode0, MOTON);
-
 	if ((header.side != side)  || (header.track != track) ||
 	     (header.sector != sector))
 		return 0;
-- 
2.53.0



