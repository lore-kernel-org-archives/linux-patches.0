Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C9178CDE;
	Tue, 10 Sep 2024 09:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961567; cv=none; b=p233utAwfbrykmBKK65/uSIDrC9Zg7ljC/3w/0Qac2AIgZss5yZaHePGAIaPdVNRFROu28qXGDyP/J88LbvZxjj0D5V8B0JuEbeA4FzaIBoAjaLJF3u7LS35wrgXavteu51KhFXSNVXTM6o/lVO9C1ozug6H4DtykifnvgK7dos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961567; c=relaxed/simple;
	bh=0p7ARhCSusPrGUp504QZUCjVK3dnArs3H7EOGmMct5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKXWSOiQtBCXalJ7lyebIR49xX0UtcrX93G/4wgYOLGaFrmzp7WeWzv8dMkotgOwDaMnjkbH4rDNNJ1uWMh4tQ4GKiIkO1ZVHxkOjpGrGYz1OUVAWgcTgAFqo6lSaMTRhJocaGA72CA+cR6JTdNta8HmX2aE5gtScqWnZ/3+s+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlsMePs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlsMePs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C880C4CEC3;
	Tue, 10 Sep 2024 09:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961567;
	bh=0p7ARhCSusPrGUp504QZUCjVK3dnArs3H7EOGmMct5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlsMePs0WZcX5LpHW7v1G4R00u3WbhGA4O3GQECeAV0haUIWD3PF6/E3N7VqpSXRL
	 Txp2q56cP8a8DEJRrCBSVC69ucwescRXmcneX+4aHNtxlXacNm3llVrfn/bSSo0Ves
	 ecRFX9sJyC1CPl4DO2R8IYip+BK6OVfGSdPklusg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 114/375] fs/ntfs3: One more reason to mark inode bad
Date: Tue, 10 Sep 2024 11:28:31 +0200
Message-ID: <20240910092626.246873837@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a0dde5d7a58b6bf9184ef3d8c6e62275c3645584 ]

In addition to returning an error, mark the node as bad.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index ded451a84b77..7a73df871037 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1601,8 +1601,10 @@ int ni_delete_all(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
-		if (roff > asize)
+		if (roff > asize) {
+			_ntfs_bad_inode(&ni->vfs_inode);
 			return -EINVAL;
+		}
 
 		/* run==1 means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
-- 
2.43.0



