Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0421DE3B5;
	Wed,  6 Nov 2024 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897453; cv=none; b=SUN2AfJVG4BUHBTLKHsWPNyAhy4s9gJfyAiFJfTa5qZ48ZccFhPTbOgQra0AmygGV/3Z3rptVLWHqzKu+ZW9YlVi/HnAQHH4dbu/UTjqZAQNV/IzLPLwizURYTT/s6WcDpu/Rn3FzxRMSefJVsUNgpYNvbwfAdcsSD+qeeh3wQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897453; c=relaxed/simple;
	bh=efzGh3KD+P3vRWmbM40jCSU1QDnn6lhn6/fMtbicId0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTXZ0tYAjXOcaxDtFzBJ4lakWJbUwxM8QrhDY3DM5cia2L/B2si5Xs+2vZbEagSPUkrTRRb4ELLCq2il8H79qpcM1Vz6KJCIrb9ky88G/CL4h4qQus8KYjQ3lBAhdDswbtsYaCvOzJftO9TF3EPA5Wr1kF8K+AaXuryPF7CMk3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwTOGDay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwTOGDay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B5C4CECD;
	Wed,  6 Nov 2024 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897453;
	bh=efzGh3KD+P3vRWmbM40jCSU1QDnn6lhn6/fMtbicId0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwTOGDayEjCnF7WZUQqfb+tmh/a3X7pPWISUsQicXlCi4yPhC/HB/+n6mJuYQOcoP
	 V3r6svD0rQom18JGsY9Ccm0R1ZPKo3hUjE0ReY5pB38MuE9lKe0TlNCZ9y0TdpBCDn
	 c22MND4qYm2kpl+HBZTG46cOsnokUVQTtCrA6F1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/151] fs/ntfs3: Stale inode instead of bad
Date: Wed,  6 Nov 2024 13:04:06 +0100
Message-ID: <20241106120310.434675455@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1fd21919de6de245b63066b8ee3cfba92e36f0e9 ]

Fixed the logic of processing inode with wrong sequence number.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 1545262995da2..20988ef3dc2ec 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -532,11 +532,15 @@ struct inode *ntfs_iget5(struct super_block *sb, const struct MFT_REF *ref,
 	if (inode->i_state & I_NEW)
 		inode = ntfs_read_mft(inode, name, ref);
 	else if (ref->seq != ntfs_i(inode)->mi.mrec->seq) {
-		/* Inode overlaps? */
-		_ntfs_bad_inode(inode);
+		/*
+		 * Sequence number is not expected.
+		 * Looks like inode was reused but caller uses the old reference
+		 */
+		iput(inode);
+		inode = ERR_PTR(-ESTALE);
 	}
 
-	if (IS_ERR(inode) && name)
+	if (IS_ERR(inode))
 		ntfs_set_state(sb->s_fs_info, NTFS_DIRTY_ERROR);
 
 	return inode;
-- 
2.43.0



