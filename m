Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625462;
	b=1kOQTz6/UvRTvAUGyX9yy+mTwXyF1qqPxuP8kMViDqjp3zMB8LS6uvo06/RxCOK2kwdn
	 CJNgdH0Tql4NEh3S77PshlupFw3cIBpfUwJADkXIAmHRdHQ/eN80VI5ZXgwGwQ9iwgSdQ
	 Dq7/RYOznEsUOmmh1o4lLQJSeKjlKOQh72RXGG4/cUbOX/6FOSBTIO7TofVLxMqQvAqQH
	 l8M+LmHxqQcDvRI9TpSJ4C0Cj/7xuIrYcauhSHxo4HPM32iPsQgSltnot9s6kH4wOAmNn
	 tDWdTX8RDzUaFhn/pM7H8KEfR32tRWFkrE1UOdNU46oPz2EidANRsYMqcNlqm6XU0zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUKpYEH9TgwEL4gAmlV0Lawiqcnen2tDDuQm3/xZ4xU=;
	b=RVVcLN0aQKpEBTKrWjVkMqr0f8ttAeff/FfNvMGi9d3lK2IQjhRzf5pfRMBwEzR9CiUk
	 kVSZ4nU1LjCrq5PaUJVaxsMjavLEllmSvpOAMtITqFihEkv1bkTqL2jRcXu9XyLflknDP
	 Q/Q1eZsoGybCrwehJKwXGLfI3hFGo0T0vP/WGxVjQAzqHyFvymk4PD46TjF1pt4ThteS6
	 vdhoAme9qBT0dfV7ZMVsdW2S51P/hQhWzWK4mWLG4WQ8LWgysMqQ5VjkGYG7KAqQluYpV
	 DH0eYypsGE41lbOMJhHNjo9MOep0Pf8NyEVHhW1yTm2tdOvqmqPq6U1azG305DGLCRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mal93QD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A62606A31E;
	Wed, 25 Nov 2026 16:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mal93QD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6A01F000C4;
	Wed, 25 Nov 2026 16:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625461;
	bh=qUKpYEH9TgwEL4gAmlV0Lawiqcnen2tDDuQm3/xZ4xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mal93QD4/gern5I6vCBpxZOlAXgyVr9rRqVDmenVL91TJGDjKkuSsFLCFHfS22nP4
	 4mrpqMV3mydIPBdlkOmhuMgJSX6aGxCP/YeVtHYWBE1H7mXGAZNKFqk+0crHSvlvwa
	 DLxTCg5iycjZzNbesUtWPNwhhAkUQ7vmi0ihutyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 525/816] exfat: fix used_clusters accounting during cluster allocation
Date: Wed, 25 Nov 2026 15:34:33 +0100
Message-ID: <20261125143901.339134368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit cb9dbf8a4e34b4fdf311598835ab4d76ed7e07c1 ]

In the current exfat_alloc_cluster(), p_chain->size is incremented as
each cluster is allocated so that the partially allocated chain can
be freed by __exfat_free_cluster() on the error path.

However, sbi->used_clusters is still updated only after all clusters
have been allocated, while __exfat_free_cluster() unconditionally
subtracts the number of freed clusters from sbi->used_clusters.
Therefore, when allocation fails partway through, the partially
allocated clusters are subtracted from sbi->used_clusters even
though they were never added to it. This corrupts the free-space
accounting and can cause sbi->used_clusters to underflow.

Increment sbi->used_clusters together with p_chain->size as each
cluster is allocated. This keeps the accounting consistent with
__exfat_free_cluster() on both the success and error paths.

This issue is caught by generic/476 with 256k cluster size:

    Ran: generic/476
    Failures: generic/476
    Failed 1 of 1 tests

    *** fsck.exfat output ***
    ERROR: <path>: more clusters are allocated. truncate to N bytes
    ...
    /dev/vdc: corrupted. directories 331, files 526
    /dev/vdc: files corrupted 9, files fixed 0
    *** end fsck.exfat output ***

Fixes: d5c514b6a0c0 ("exfat: fix the newly allocated clusters are not freed in error handling")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Dropped the done: label from the context and removed this tree's used_clusters += num_alloc; line plus its blank line, where upstream removes used_clusters += p_chain->size;. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 2c3ab6313cc98..5cde58a4a503c 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -402,13 +402,12 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 			}
 		}
 		p_chain->size++;
+		sbi->used_clusters++;
 
 		last_clu = new_clu;
 
 		if (p_chain->size == num_alloc) {
 			sbi->clu_srch_ptr = hint_clu;
-			sbi->used_clusters += num_alloc;
-
 			mutex_unlock(&sbi->bitmap_lock);
 			return 0;
 		}
-- 
2.53.0



