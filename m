Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530537B413;
	Tue, 10 Mar 2026 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141992; cv=none; b=G3yijBa5IX1FPG+Vxb4UoseezIRFfi0iuRFRWycn77YRSRbvEfZwnCy/qTi3QD3RQW4NR6NHEKjwgl2UgBJ8FbZohKprUO/SKUQ0fA9LAPnDfRqFQW1UcNUkwAevUg6UEYV6z9WvrI5TadIdfv0jtqXPRyUbLpdPxJCyspjfhGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141992; c=relaxed/simple;
	bh=7EtrgCRBRzg42imEDePHQw+Fxt3ibH6pVF1z8HHHUKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dL7/tlsiz+aSBKqGjxXWJN25jfSTFCVM5rxXCzWWK7dRFCaHrc0Je7OOnsyVIpYhcdcX8VnTkFbcKhQKHAisEux4BTs3GMIUMH1zK00bywhdrAcZaCMxW6eJC3DhDa1xsF4i+4DaAk8WPoNp7H1jLeUIKQYtcZV8XVGPk/0UxcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfRK3Apy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfRK3Apy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4216C2BC9E;
	Tue, 10 Mar 2026 11:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141992;
	bh=7EtrgCRBRzg42imEDePHQw+Fxt3ibH6pVF1z8HHHUKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfRK3Apyq3ffRyuQxadBo7Q4JT4eGtOuptZFx+TwAW4jhju9qp14JrAN2HK/3pENf
	 Z5fqKOfdM/UyqW6l/8Fp89dtEz67Noq80Cys3auLw8H/bWuUmK9kaL7tzwVcyxbAT9
	 pkzJx3k6FolkwOOHi0U5LY3CgsDSaE1wIu5nHOWz9LY8pJF2wgGjY++ZyniDCRdm3G
	 9RFgthgyerv3FJvz3RC0GDkHDAoLBBIRVra48pggsvIODEdEe17eJsNC4BHrOrrrNv
	 ZmFGGSWvqaF6X/Mg2tJAKAAU4XwMNJqyGEtqmfsQ9lc5ZBHY2ZGjkxC8IG8nZUfRWR
	 09r5upY3jWKyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/314] btrfs: define the AUTO_KFREE/AUTO_KVFREE helper macros
Date: Tue, 10 Mar 2026 07:16:16 -0400
Message-ID: <9f467cc138e596e4c9f8e3e3d61ba27eb267bd4e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miquel Sabaté Solà <mssola@mssola.com>

[ Upstream commit d00cbce0a7d5de5fc31bf60abd59b44d36806b6e ]

These are two simple macros which ensure that a pointer is initialized
to NULL and with the proper cleanup attribute for it.

Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 52ee9965d09b ("btrfs: zoned: fixup last alloc pointer after extent removal for RAID0/10")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/misc.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/misc.h b/fs/btrfs/misc.h
index 60f9b000d644b..a82032c66ccd3 100644
--- a/fs/btrfs/misc.h
+++ b/fs/btrfs/misc.h
@@ -13,6 +13,13 @@
 #include <linux/rbtree.h>
 #include <linux/bio.h>
 
+/*
+ * Convenience macros to define a pointer with the __free(kfree) and
+ * __free(kvfree) cleanup attributes and initialized to NULL.
+ */
+#define AUTO_KFREE(name)       *name __free(kfree) = NULL
+#define AUTO_KVFREE(name)      *name __free(kvfree) = NULL
+
 /*
  * Enumerate bits using enum autoincrement. Define the @name as the n-th bit.
  */
-- 
2.51.0

