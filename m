Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EE5497394;
	Thu, 17 Sep 2026 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658929; cv=none; b=WJIWAsbsKeUo08qDEAp4m+lGgjmG5N6rvMlbunTV7hoF+HcClfIHm2PZt3qO0x9ekMor1/wDuoA2eGo6FyfBCWsngbL+puc4CzqwZDW2zytbXtLBTxdwZiyLZ4Z1Kj75PgSpCwgAOv1j9IYLQ/i4krEGlLfAAPYz8vyag6ssa3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658929; c=relaxed/simple;
	bh=acxADpIfR11UfvVAgFcTLJfXtXZgh1gxHOqgrUhnyIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCaJOQ+i0FCToHvoyPEGO/ptWu65ibmPixQelGuDLiSka370DgXWQeMukamFKc/wXSduSd9BxlofWQ7jx+oB2ZYQ6hxehGKdBUOdK2ya9GTN6BcOty0cNx4uAaBcnmuCI0PiaYctbPdncU8K8lzb7rWzKRYGWhpfmpLg/KZts6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O04lfPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O04lfPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F5D1F000FF;
	Thu, 17 Sep 2026 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658919;
	bh=Mfw9K2z28DsBspuj/BZF8sHOQ3pQUqHpzNWVoznwECk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1O04lfPBtHCzOmw28juCMAT5vEJRyHYfw2XOFBUu4VVP3SkulpTpNVSBC4uZpyMhq
	 xy2/VjQGpyksdRPK+/pBE5EtlbKZxYWmcldRL4F2yr5c9c2ECHGUpOTCC+arNi33Dm
	 Df3SwQUB360/HnczWLMsLS2Ea+Mn9RmTYK4CG15A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Tighe <dennis.tighe@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 045/733] ntfs: do not mark the volume clean in sync_fs when errors were recorded
Date: Thu, 17 Sep 2026 16:05:53 +0100
Message-ID: <20260917151351.892530800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Tighe <dennis.tighe@gmail.com>

[ Upstream commit 0e4c839905418d55bafe571a92533a1d1ac7b0a8 ]

ntfs_put_super() and the remount-read-only path both clear the dirty bit
only when NVolErrors(vol) is false. ntfs_sync_fs() clears it
unconditionally, so any sync() on a volume that recorded an error marks
that volume clean. A volume without this set is then seen as not needing
recovery and it does not run one, so whatever went wrong is never repaired.

This change skips resetting the dirty bit when there are volume errors.

Reproduced on a volume whose $MFTMirr does not match $MFT, which sets the
error flag while leaving the mount read-write: after a write and a sync,
the on-disk volume flags read 0x0000 with this driver and 0x0001 with the
guard in place.

Fixes: 6251f0b0de7d ("ntfs: update super block operations")
Assisted-by: claude:claude-opus-5
Signed-off-by: Dennis Tighe <dennis.tighe@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index cd8fa2c133700..d287140b3fc61 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1862,7 +1862,8 @@ static int ntfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 
 	/* If there are some dirty buffers in the bdev inode */
-	if (ntfs_clear_volume_flags(vol, VOLUME_IS_DIRTY)) {
+	if (!NVolErrors(vol) &&
+	    ntfs_clear_volume_flags(vol, VOLUME_IS_DIRTY)) {
 		ntfs_warning(sb, "Failed to clear dirty bit in volume information flags.  Run chkdsk.");
 		err = -EIO;
 	}
-- 
2.53.0



