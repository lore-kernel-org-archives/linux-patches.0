Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027118;
	b=kAkSy0Xr5zsWSJ4LLeJZP5RvARr2Ahuy5NvpWlAyEx9yCYA6mCrrBBA0K+PnrHjHY0F/
	 fdQu7EeMltkhJALI65u6dCavBO494gAXbCsXQOzzgtEqBFgiaHZBXUWjlmcrCv6Bxr3Kx
	 Zu9NoVMuICWa/ntECpkcvs8FkM4MxFDpLuAtYP9UJbvs9Vk5SStfsSbMCNr97nyiYk8Gx
	 WuEeL2vNIycGs10Owbteaz2nHXjUAzdjG8G9e1fFWlV9+foI5pYeCxhsT6AImESE+hs28
	 xm6QyLLlUTTyiu4o3GHXKYF1cxEpCMZ55OzR/ouVurZS1X4bQFYS6/nuicjxuM3QUNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NxaxfaNVNbblEH/FzkjDjzaO1Ohk0gAhmHB3WMzhm3c=;
	b=V5Ru5za/QfBQlhPdD6s84hKBGw9NNNsw6YK/SwpMb1np4PHzlKzMLnPnlbfC0sBdCrYa
	 /0GnZag8hp6Ob7fgx88CW6dHWGU1FmrNQXF/uFh+YP23sP2CzDFFOKqP+AT1I31Qny0T+
	 3XyT79uvZiLlEbE8OAktFOoNvqEO8QmzqnQKg6AgYkoFNUivmG3ctqyt8ee/sDSKcJNaR
	 MbnL/lcbA8/YQAx/jtPRbmP9sqmZaXgOlV5aKK6eG32l5yI9gHWyfCRewZc/UwevPa2uV
	 peUXTg05RJsc7ab5j6UG1cP5m1gNRf4s5n7F/LqNSaSuJgTrUCD/cAsclqlOC+O7y4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtsHmKXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5437D606A31C;
	Wed, 18 Nov 2026 18:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtsHmKXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE831F000C4;
	Wed, 18 Nov 2026 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027118;
	bh=NxaxfaNVNbblEH/FzkjDjzaO1Ohk0gAhmHB3WMzhm3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtsHmKXDBbqHa41xfEWNPo2W26bwjsMD96T6V1lmWHT2bTJ7Ca7stfQ28rBcG+ZRC
	 8C7+jAsqKZaCN1eu6ieGg2LWi8khqwI6SwadRLLBG82Uy8BISI8pSjg/GjnMMmNyms
	 Jgm/iLJm5JogOX49B6upo79XjNIO90Vt9eLqE0go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1675/2151] fuse: validate folio state before pipe_buf_try_steal() in fuse_try_move_folio()
Date: Wed, 18 Nov 2026 15:56:50 +0100
Message-ID: <20261118150222.848059801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 15c20483d91589f868fe7a72aec4b97dc68b931b ]

In fuse_try_move_folio(), check that the pipe buffer's folio is not
hugetlb, swap-backed, or already mapped/anon before attempting
pipe_buf_try_steal() and inserting it into the FUSE inode's page cache,
preventing VM_BUG_ON_FOLIO() and page cache state corruption.

Fixes: 394244b24fdd ("fuse: support copying large folios")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 69d178c9b3949..0f9ef3ca9824f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1024,32 +1024,32 @@ static int fuse_try_move_folio(struct fuse_copy_state *cs, struct folio **foliop
 	if (cs->len != folio_size(oldfolio))
 		goto out_fallback;
 
-	if (!pipe_buf_try_steal(cs->pipe, buf))
-		goto out_fallback;
-
 	newfolio = page_folio(buf->page);
 
-	folio_clear_uptodate(newfolio);
-	folio_clear_mappedtodisk(newfolio);
-
 	if (folio_test_large(newfolio))
-		goto out_fallback_unlock;
-
-	if (fuse_check_folio(newfolio) != 0)
-		goto out_fallback_unlock;
+		goto out_fallback;
 
 	/*
 	 * This is a new and locked page, it shouldn't be mapped or
 	 * have any special flags on it
 	 */
 	if (WARN_ON(folio_mapped(oldfolio)))
-		goto out_fallback_unlock;
+		goto out_fallback;
 	if (WARN_ON(folio_has_private(oldfolio)))
-		goto out_fallback_unlock;
+		goto out_fallback;
 	if (WARN_ON(folio_test_dirty(oldfolio) ||
 				folio_test_writeback(oldfolio)))
-		goto out_fallback_unlock;
+		goto out_fallback;
 	if (WARN_ON(folio_test_mlocked(oldfolio)))
+		goto out_fallback;
+
+	if (!pipe_buf_try_steal(cs->pipe, buf))
+		goto out_fallback;
+
+	folio_clear_uptodate(newfolio);
+	folio_clear_mappedtodisk(newfolio);
+
+	if (fuse_check_folio(newfolio) != 0)
 		goto out_fallback_unlock;
 
 	err = lock_request(cs->req);
-- 
2.53.0



