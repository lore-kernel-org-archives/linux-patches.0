Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C61E0DC4;
	Wed,  6 Nov 2024 12:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897438; cv=none; b=TtyMWY/k4UHX6sTF7DHGifWSOFiZLyvzmVPufNV5AbdCbatlF37c/AdAqNthOigkbBpxoY3oJUP9EMY7GK8QS4ELjC4jrwF4Vs1m1M8iHANVaLsZiL/5JOHoyAqjCVHqpCAmvmgdmKCO7ydhRjZ5drQbHodq7iXkzI5/m1WwqbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897438; c=relaxed/simple;
	bh=GOAx3flgqlDKiEuysVtcu523slBOE901Bb8CKhHYcWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rkg/yW64EMLTws0ntzIYf+caY4mCqMDA4BcrDFXjeU+A1TSpNH8js2ijAcciPCpL3cFJTYTYII2L8I7VQqxCevH8rE9tDA/D+fExH/X2vdv33zjAnKtfoWWZkvFSkVsUgO36TVW5hkqr/10YHe6DMwMPn0VmMt82JtAdKo9f53k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xco2H+bJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xco2H+bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1D6C4CECD;
	Wed,  6 Nov 2024 12:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897438;
	bh=GOAx3flgqlDKiEuysVtcu523slBOE901Bb8CKhHYcWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xco2H+bJ+nWtKJQg3tqFjPz6htwfD2ROBWI4JVdOnqpLE3PaGXhnGf7OK4PYQ4bIe
	 AiBiL3X+Hw3okRIM/r9oC1529v1cjPj5PsfI2zkYvwNZ61gISHA44oXnqSIFft546W
	 FylhmvbzIfu8Bp4NOpup46tsV6OhQnR0wSTma7HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/151] smb: client: set correct device number on nfs reparse points
Date: Wed,  6 Nov 2024 13:04:01 +0100
Message-ID: <20241106120310.293679797@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit a9de67336a4aa3ff2e706ba023fb5f7ff681a954 ]

Fix major and minor numbers set on special files created with NFS
reparse points.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index a4e25b99411ec..c848b5e88d32f 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -108,8 +108,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 	buf->InodeType = cpu_to_le64(type);
 	buf->ReparseDataLength = cpu_to_le16(len + dlen -
 					     sizeof(struct reparse_data_buffer));
-	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MAJOR(dev) << 32) |
-						 MINOR(dev));
+	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MINOR(dev) << 32) |
+						 MAJOR(dev));
 	iov->iov_base = buf;
 	iov->iov_len = len + dlen;
 	return 0;
-- 
2.43.0



