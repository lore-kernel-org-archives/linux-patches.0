Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8533ACF11;
	Wed,  8 Apr 2026 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672219; cv=none; b=ab8if61mya7necw6MHY/CF3g1bdWZSxccIdAarrPQ+N1Iaeco3SV9HPnxSXAYz6FqagnTENnQW/bGz/RcO5yiEgAv4Zc7dum7UJBXOFSjK/yrTyoWvAox/pc8rEbYnqyII2OSIU+gRIuzjzJ85HyB5py98iBq6b244GNTjW/SUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672219; c=relaxed/simple;
	bh=MaWTuVnhcvf5XTGc9ygRpblr8W8gxVmctOHiNvJ02Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCqZgOfrTX4dW0d01lsE58/wWIpymaQn/RN+K3OXiRS8suxpQ+vJB/TYQ/A0XSuwBb/QsNnp5juCgsF1uMOpWXDnuMWHZjq2UIbsZw0FltNVZrrHHpFygIx3OSJuAlwdQFbcWA4YitwiOL7IjOGefBRO/5TiM7FqW2FyjogdcPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S058IPlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S058IPlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E70C19421;
	Wed,  8 Apr 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672218;
	bh=MaWTuVnhcvf5XTGc9ygRpblr8W8gxVmctOHiNvJ02Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S058IPlYo0swjSc+rk4aJ3UFGFwfMjVwK+ZgFwQUcHLADOjPFH+yWryARAnimpnsR
	 RiOeoqFy3TLZgatblmftZh3VswNwdAwjbbd0xx8AfMvzjGLPFuWw5HPYfb/E1F37ki
	 VKztUYops3r7CCEu7t+ECnCPnoTV9yCwgSXB6T5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/312] Revert "ext4: drop extent cache after doing PARTIAL_VALID1 zeroout"
Date: Wed,  8 Apr 2026 20:02:33 +0200
Message-ID: <20260408175942.565739515@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 9e79460b3aae6bbf33f5ccea6c44bf2eefa45daf.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 30b0b25aac9ff..da7414e84ead8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3304,16 +3304,8 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 			 * extent length and ext4_split_extent() split will the
 			 * first half again.
 			 */
-			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1) {
-				/*
-				 * Drop extent cache to prevent stale unwritten
-				 * extents remaining after zeroing out.
-				 */
-				ext4_es_remove_extent(inode,
-					le32_to_cpu(zero_ex.ee_block),
-					ext4_ext_get_actual_len(&zero_ex));
+			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1)
 				goto fix_extent_len;
-			}
 
 			/* update the extent length and mark as initialized */
 			ex->ee_len = cpu_to_le16(ee_len);
-- 
2.53.0



