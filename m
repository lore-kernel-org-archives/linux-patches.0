Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211524;
	b=eCCfqnSpz2J5d0jSZLhAsmPNQ+r2XA5rD9tkT7MoAT1a+B64y/9tENdPC67y+Mycidnh
	 hkrC4FoI5aVwbfBSthK5WDdDhqt8IM0JqjRKO7VXzGTGT4BZWHLIEniXdDmic/akr+qjk
	 CcwGOCf1TlzoeVLbZklCF/ZrauiH+3PYzHe74tOTP/AEaZvG9gTHp4vfgHWPz2yMOCs0R
	 gpy2GOgepiYZXUz5xaat8SriBpSavpuTIfXtCA2Tojzycx02eiMQvVoQKqTcUdw6MIBss
	 I0d3gYuXO4EarxJKZNc8txBDxuFb627I/msslkZsYrlN1ANwehuUxKX2AWMyD6+at9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SWl/1mxosH8rV+OUvepW8Wg46quPR5HqbN3S4rrwlG0=;
	b=biByu2gc6fAtt2XRWLsPKTc9vw0L5NOTLGnYIAsKFh7IqzK00j+ejiVynxJbpjhW3kyR
	 NZ1S+/waJ0xpBvnMhaa+oRWaifX6L0/ib8lEoUdYsOgrEV9sNLdRh19DavyGzTc0cy5F2
	 p9vMXB7Ntuq7oy9JY5njZyhQfXyusLwiSdPCk1r1f1KsqHNAGmsEZTe44w1Cpb714vgnZ
	 WRCUtpWfR2kSdrXlQYA9IzTeKvTTb1L9PQdFvXu5bD8+2VnlCFvECUOBYri4yJ9nel0GK
	 jNeI/rYLLq0uEiO5qIRyfNc14TVNZcCq+BPHBTuHTDgwRNGYkswoCYNGgyIjMVQv5dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4jHstjX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6CF606A31A;
	Wed, 28 Oct 2026 18:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4jHstjX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9DE1F01825;
	Wed, 28 Oct 2026 18:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211524;
	bh=SWl/1mxosH8rV+OUvepW8Wg46quPR5HqbN3S4rrwlG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4jHstjXoEbbsibZfo9ywSRAslTVNtOvVnSvpO3bf+orOm/cQdU3Do36LvOjocJ2T
	 U6O/9jY57946mAMK1TOHADpxgaFnq1cHM3sBgdy25A0t3eGSL+vUgOMbOQexRv9Lpc
	 LS9KFxhn4PsMN0Yib51E2j51ZpWRFLWh5QXLjtkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 406/571] mtd: maps: vmu-flash: Fix the (mtd core) switch to ref counters
Date: Wed, 28 Oct 2026 17:59:13 +0100
Message-ID: <20261028170017.645676841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a7d84a2e7663bbe12394cc771107e04668ea313a upstream.

While switching to ref counters for track mtd devices use, the vmu-flash
driver was forgotten. The reason for reading the ref counter seems
debatable, but let's just fix the build for now.

Fixes: 19bfa9ebebb5 ("mtd: use refcount to prevent corruption")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312022315.79twVRZw-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231205075936.13831-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -720,7 +720,7 @@ static int vmu_can_unload(struct maple_d
 	card = maple_get_drvdata(mdev);
 	for (x = 0; x < card->partitions; x++) {
 		mtd = &((card->mtd)[x]);
-		if (mtd->usecount > 0)
+		if (kref_read(&mtd->refcnt))
 			return 0;
 	}
 	return 1;


