Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033942;
	b=trUI1sedKSoilqcaa5VFqy97/fj+oCwsjwyqkVjQRjKy5BAuxlGI2d9vLD69kNsyS6X+
	 zIh6Q/nc2wnKYY/8n8AtS/vIRDIroR5EZnQ1JF6GuqJ3R4YTFLZDoa2LhTSPQH+yhmR/A
	 9MfFJHZPkLzBPItmxU3tavSahLA4yztzplf8dyLGerUCAlONhw1VjWQczDMPunHVeGfoR
	 UrEQG36h21cq5npJ73NBa27ct5e+430+X8IojzvFe04miSJFYYAOnQWG9pZb7vpb5kcGX
	 /aTRDnNXXVHI4cpgqLEn0p67WB9i1SjBHVUiZHe23JMFFZiOEZi9NT1pMAErD4LCI8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DXUEtK8HDseeKPyrxAtoyAuaiZ1oM3h0UTr9iIzuAYE=;
	b=YAcqIvxUu5Zbgu+LdlkyldS82yIYSHmRGcrYWNBUfx+KQXZWjrXytTnkCRTCTJ2Rb2ol
	 rSbndy9xb6L3KbXakviutuCVyqlXavkXKKwiTI7Q5ODbzwM4D50EnZkiu+Lh7kWEQkYD2
	 5O2GwtZNJ8I37fOlqdlDdEbzjyfRfa5YpjuMf/82SEYBfWRUXzjWNLBeo4Mp7uB+W7YF5
	 0PB2NnXl7pqQMmeBd8bYssdC3FNmFrnOOuSoKtstsggaotnXSNtlM+EprVek2HNy1fFGx
	 KXkqz6pPdeUEY7gz8lu/LNcilyMsn/f6bMGQXt+NoGzLIq2As9OsMvT0orVzv0juCbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMLvmCpj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA68606A31C;
	Wed, 18 Nov 2026 20:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMLvmCpj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E41C1F000C4;
	Wed, 18 Nov 2026 20:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033942;
	bh=DXUEtK8HDseeKPyrxAtoyAuaiZ1oM3h0UTr9iIzuAYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMLvmCpjl7eWRqE7ZaOWCekpfZ867A+hUcyBoLn26KlPjYPf3z3/59Gxq9qYZ2n6C
	 SZOYWVmZk7NqSv8Jh45Nfb2a8b+rruSmaeQxzvmYKukclyjefx3y498O7DyPHgCutc
	 94/2H43S1mTegwarPwNac2exAXPQ8CfD7TZzI45U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0193/3318] fs/ntfs3: Fix memory leak in indx_find_sort()
Date: Wed, 18 Nov 2026 15:13:35 +0100
Message-ID: <20261118150320.600550473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7ca7e6c762021..d1e45ff4a2457 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1327,6 +1327,7 @@ int indx_find_sort(struct ntfs_index *indx, struct ntfs_inode *ni,
 		/* Pop one level. */
 		if (n) {
 			fnd_pop(fnd);
+			kfree(n->index);
 			kfree(n);
 		}
 
-- 
2.53.0



