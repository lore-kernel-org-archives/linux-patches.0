Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043319;
	b=t9lZ3lXvqipNNBRt9RvAivUqwaGZwUNH76AQYL6QLppFpRUrDKoFrjOiSge78wUoI6UX
	 Xq0nKXSkGIO+eRWeMk79Qaj1Cd736VkEQYkkFQy8AIcgPxvSdoU64pdqzgTLAbIv9fJAX
	 uX2LnN8idllHpJP8fyztFT9daykiOHDgXpaHo5EJnIlF0gHKPKLlhNPnvv9ldIWfVBZdK
	 5NuNRxLAY0Xeq3OTxr02I6pxu2fTOwacOhmlX6YmLVI33DPM7bZiCRVNNmpowjjIaEIO6
	 6PCQ3NpfyXk5cqO/hwetGQVhbZG1SJKXHbboB7IY+gwFa6U4sSnv3JIcqnMrf2gMKOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BR4MbKp+rN/1YrKAXiZu2t9lcJslurk031be3rjXWmo=;
	b=meT4nZ1935FJ2amcyUQZygSqj6pcp/ZeAo0D+LRlP2FwzaLf96mG/0KLO+4hvVV2RXmI
	 cSlbJlwQbLA70+DQ9KdYp93PVK5Pu9KXV+gF1EJvfyjo2KcupMh6yNhXpG7U0FHrExgmy
	 I/DoOfPlIfDIRDXgJrGZCKFQF1OL8Jf8fzpPJ9GEpHPvrH7ZKhhYiKw8gD3hU+iD02JX+
	 lRMuoz0aQ18B/a3o08CWKuJT8QuIqtYzb569hNZfWJBJgOM6lop2wSp9Im/wgk53ZH1V0
	 +rLVvZT5bLkF+9/WyD7jf6PbbRXQbusp8UhFf4k+6V9hkUTzutCPS2khNd3AoKfY+wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZP+J7+VM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649E6606A32F;
	Wed, 18 Nov 2026 23:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZP+J7+VM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9B71F000C6;
	Wed, 18 Nov 2026 23:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043319;
	bh=BR4MbKp+rN/1YrKAXiZu2t9lcJslurk031be3rjXWmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZP+J7+VMtrPs5Ek1EsjM7CD6A9YFCdZ/SNu28eBSNFgJofT101cjk+A/93J2SmgXd
	 vRU95g5s1oac7QAQN0TtJ/ePZT6ziPZ5wlhOqkZzb9Rdy2T4AjEhi9kHPVW2cNRTwe
	 YvfPQaNEGcR1RuPAoZRTqcHKD8TVVptrUHM+msLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0168/2857] fs/ntfs3: Fix memory leak in indx_find_sort()
Date: Wed, 18 Nov 2026 15:20:02 +0100
Message-ID: <20261118150207.402873005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 194491be54e1c9e4d29d3ee777b05ff031c4b670 ]

When popping a level from the index lookup stack, indx_find_sort() frees
the struct indx_node but not the index buffer it owns. Every call that
descends and then pops a level leaks that allocation.

Free n->index before freeing the node itself.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 8572453693898..875de16166e63 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1325,6 +1325,7 @@ int indx_find_sort(struct ntfs_index *indx, struct ntfs_inode *ni,
 		/* Pop one level. */
 		if (n) {
 			fnd_pop(fnd);
+			kfree(n->index);
 			kfree(n);
 		}
 
-- 
2.53.0



