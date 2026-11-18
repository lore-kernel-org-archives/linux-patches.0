Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020683;
	b=IhehvMhzbBjZEsDq7rhj975YLS6Ggq1CAS0bYS9D0tACP/J4AMQ8FccyGUVXPvdw515y
	 VHFvksOgYdM2KTcPin0MbiCz3wpU1DoCE/oBTymETOr6hjbkRkuPtds0rnXq8Lt5XZZtf
	 pJ+H5PEG8BNw4RUXTmnA3yDrhNqJdazm4TGjSqe3CqNsnlrEcFhF4Wt3LbVUReWXiiw9C
	 x/tevLAMIAy9YfE06AvX0B41AxnmfgsZb93F601vovjpBHiRK5yuVQmg1ncCmGdoIzG5v
	 9j4avGHDxzqML8yV8uEgAfyVSMuHMexPPCxaXG2cCyJLnP/6RPnZbZG/VqE98pw9L5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rv0376eGTEZh/Uunw6K8vYgCgMTccRXM64PoYNaQBZY=;
	b=KUcbA9VCL8YKtSwCSWfxDKMS5m2I9pwZ+PlsFkXJ2lUD+2IvAb2shP6XfcO/bcTbBzEO
	 XGTmQUTr2+ewDrsrCwrf+gG32FF5a86KYNXe40uKjG6S1ZT0VueImu5S7OEL4Rkkd1Qxn
	 MerlAAA71ya+kg/ud+zmBdm7/JAjOfkQ6iIz0+/q7aM/iKHhQeQSAbfkPyQoFh3q6A8uB
	 cleUN3Jv25TDvh1Phh7T2SN7gzaSo/e1Gxq7pVwFoiNS/mimvLz4D3be1O1eJE10uncB8
	 3yZPPRX+ZVielGxjnlfstb3zeGyu7/f7/Un5CjG8Rfr0/a8kf3C8itRzquUICbiPCZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVKUfG3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D1760A380F;
	Wed, 18 Nov 2026 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVKUfG3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301B31F000CD;
	Wed, 18 Nov 2026 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020683;
	bh=Rv0376eGTEZh/Uunw6K8vYgCgMTccRXM64PoYNaQBZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVKUfG3HoJmWPhpEqfR3/ep/085CqV39ZmhmT5b4rwB/PvUdLu3iQoM1rH0XWu8q1
	 7Jw9Zt+y2cQTPQcYUHq4m3k1v0Mc+WvwPrrMfvfvJ4YNrzRgtyHj5o7Oq4zKppe1mr
	 7IHutEd2P6zCZ9LWQxJZfORihLH1nNGdPUdJkiWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2038/2651] fuse: validate folio state before pipe_buf_try_steal() in fuse_try_move_folio()
Date: Wed, 18 Nov 2026 15:54:38 +0100
Message-ID: <20261118150359.474659398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6e565d668e066..6227d5e62a0c2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1151,32 +1151,32 @@ static int fuse_try_move_folio(struct fuse_copy_state *cs, struct folio **foliop
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



