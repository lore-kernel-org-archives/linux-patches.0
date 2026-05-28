Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C924677F;
	Thu, 28 May 2026 20:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998635; cv=none; b=W+FGuVvUHYu+AqnTCLmhuLMb3aAATVR/6+BbiVTGJXxa42CCUqp2BDpV18IGnGejVhpgZ1FsSytbMLZZI+a8YaqIPaASSmE1AmiWxJb5gUsVthhLTgjeya2lqt5SPmHFfnk29S3x/4dXmBJ/r2bmuTR75qQ1/bsHz4WnhxGA0gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998635; c=relaxed/simple;
	bh=SOI5kw2xMsX1VZ12/HEz5yXzcWKqjgmmidy7+GJk/Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEa4yIchTYAY52TrLBDg5V+VNLOYCbrdfhJuHodXWQIyaAXoGXYxL4hya32nI7TyOVBo0nTl5qMwNM4V641uEgC9jCtXrNuopZEHxw5kety7jZSIQJqnx4OSJk2C9RcmsMeAZYsSJVYa+T81F4haHdrLWG7neyeN4ROI5kffln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzwSgehT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzwSgehT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242D41F000E9;
	Thu, 28 May 2026 20:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998634;
	bh=+yewiXP6n/3j2sTyoaD93kjwMCr4yShRlxGV4IYHuRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzwSgehTkiBWFC446nEDbdtt68ArXTEeO92Wlt56tqJivMWzmbrFwteAExboCBZSc
	 ga7+sFNrFodEA6REKnBCiK93gV7xGFmtk1fHCCTktWK3cvHAW4QKnz2fzuur+vi9+N
	 dCH6Dun8480sMcGsAt/ZeQ7PfmZE/owwO1kuSAsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 244/461] zonefs: handle integer overflow in zonefs_fname_to_fno
Date: Thu, 28 May 2026 21:46:13 +0200
Message-ID: <20260528194654.208498504@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 3a8389d42bdf4213730f4067f8bfa78bae6564ef ]

In zonefs the file name in one of the two directories corresponds to the
zone number.

Here Alexey reported a possible integer overflow in zonefs_fname_to_fno(),
where the parsing of the zone number from the file name can overflow the
'long' data type.

Add a check for integer overflows and if the fno 'long' did overflow
return -ENOENT.

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: d207794ababe ("zonefs: Dynamically create file inodes when needed")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index e83b2ec5e49f8..d0976c874b74b 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -610,10 +610,14 @@ static long zonefs_fname_to_fno(const struct qstr *fname)
 		return c - '0';
 
 	for (i = 0, rname = name + len - 1; i < len; i++, rname--) {
+		long digit;
+
 		c = *rname;
 		if (!isdigit(c))
 			return -ENOENT;
-		fno += (c - '0') * shift;
+		digit = (c - '0') * shift;
+		if (check_add_overflow(fno, digit, &fno))
+			return -ENOENT;
 		shift *= 10;
 	}
 
-- 
2.53.0



