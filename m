Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AE21DE4CC;
	Tue,  8 Oct 2024 12:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391837; cv=none; b=hkZhPvhwbNxA0wN7LT12DSoTo0Oq3ooq2YW22GDYFTmAGZMq9WyOgOEci2TvyJrls49wcOCe1hpN7ikZHqhoSVvISnDTon9/lwbf3qFZ2ahu6CGSDRY1danK2p3ZaOx3+ZsPYJxhQF6i+26i1bRDm30BKgPee8dT1sJAn85RmU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391837; c=relaxed/simple;
	bh=avslA3lY13Vb2DOQ0HIWdqXrjFKYbhZiCjuctv1w9u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsREjf0qqDHdye/6TVlGcaahrnfQO13JsCn7TpDWO9ueZb16hOp+ZSC1umwX2qDN+lkuhXYIRBNjiaz1eyJsF84L5Xk4ArHCyyUepLsexU8zuitHPoI37nCthQx5Y1dYbX3F4+jr0fU/K879vIxLU4zs72TwM24vLeMXgyGYH6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ccf6oxlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ccf6oxlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7EBC4CEC7;
	Tue,  8 Oct 2024 12:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391837;
	bh=avslA3lY13Vb2DOQ0HIWdqXrjFKYbhZiCjuctv1w9u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ccf6oxlcw6OhFtkN+JuAmIFNhJAvP9yMuh1NbMohG61EIDWzw7e3jJ6MmHL2IvIkx
	 sC7mRkamilevvdjJYjHeGXx8boNbJezT3jkpAH6aMiuVisuooG0TbmV8+T6pnP8btF
	 zYUNgxI3OjjxtQ7JH/V7UlExEKJcfgzvZ+oIjIus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 236/558] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Tue,  8 Oct 2024 14:04:26 +0200
Message-ID: <20241008115711.630480041@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remington Brasga <rbrasga@uci.edu>

[ Upstream commit b0b2fc815e514221f01384f39fbfbff65d897e1c ]

Fix issue with UBSAN throwing shift-out-of-bounds warning.

Reported-by: syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com
Signed-off-by: Remington Brasga <rbrasga@uci.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 0625d1c0d0649..8847e8c5d5b45 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3022,7 +3022,7 @@ static int dbFindBits(u32 word, int l2nb)
 
 	/* scan the word for nb free bits at nb alignments.
 	 */
-	for (bitno = 0; mask != 0; bitno += nb, mask >>= nb) {
+	for (bitno = 0; mask != 0; bitno += nb, mask = (mask >> nb)) {
 		if ((mask & word) == mask)
 			break;
 	}
-- 
2.43.0



