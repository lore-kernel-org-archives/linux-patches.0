Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3491FF1A1;
	Wed,  4 Jun 2025 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998940; cv=none; b=ETBtlDWze5s2GgapZuveA/yPK4N1o9wJmCef/BXVShYw48S4Sg5TsbFx30CBQ6XZ271Fa7BS+8qK8wzirCe+n6sYCmuZ1m0miF81KXYgkZTDprJKGzi992nd3ND1/mZU3imaaAF8Xlxuwb9n418fesyqDA8LODWUtlER2LqvqfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998940; c=relaxed/simple;
	bh=6NZgrgaUc9ARO8n1NP1J2dv68Wc41FddipzyybgZRx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CbQO8ltPa5Srtz8RKJ2HugQNFjv2pmjLnmE7Y0cBHo4tQAWNq6H6AX17nE8dxJ4x1ZcpzS66WpRmwk3XzEX9biXNN/L0kVQOwn+uAtL7pLh1nA8fuuOB7EW6aqLHbEhzDnLlkM0IW/MZ+3wQl0H3R8kXMSj2KxVnJD837c9gW/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISPFnhRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISPFnhRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2432C4CEF1;
	Wed,  4 Jun 2025 01:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998938;
	bh=6NZgrgaUc9ARO8n1NP1J2dv68Wc41FddipzyybgZRx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISPFnhRlaJSS1Nolnkr2iDKxsYe+sjfZhV3lm3ZGaJbmrexUhuN126/IXrseKM6h7
	 kH00JPjJgaY2ux7cTJaA9EGZbZbLdrwpH/htUNVfR0b9tlKHruIRBMDuK4MVJlpY7E
	 wI+URecGWVdicpCTgaxBg5PBbU7OCjbcGRAGiQNwlh4c3ni4Lj00obf6mR8oCxQ9/3
	 r4vZ54xMe5bg8tZTkB7cMhCU7oWihLmArq+jWtn3d9ewz6M9x3kGn8mhEhZI+Aec7/
	 9M+OYE2CJJASL08Naz9RgfbmSIh9tYXopoKn4NCOeMUm5bMABZxA1rBCbcxrdhNqC5
	 CgEi7NiaCHEjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jmaloy@redhat.com,
	netdev@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.6 03/62] tipc: use kfree_sensitive() for aead cleanup
Date: Tue,  3 Jun 2025 21:01:14 -0400
Message-Id: <20250604010213.3462-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010213.3462-1-sashal@kernel.org>
References: <20250604010213.3462-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit c8ef20fe7274c5766a317f9193b70bed717b6b3d ]

The tipc_aead_free() function currently uses kfree() to release the aead
structure. However, this structure contains sensitive information, such
as key's SALT value, which should be securely erased from memory to
prevent potential leakage.

To enhance security, replace kfree() with kfree_sensitive() when freeing
the aead structure. This change ensures that sensitive data is explicitly
cleared before memory deallocation, aligning with the approach used in
tipc_aead_init() and adhering to best practices for handling confidential
information.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20250523114717.4021518-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Security Justification The commit addresses a
clear security vulnerability by replacing `kfree()` with
`kfree_sensitive()` for the `tipc_aead` structure in `tipc_aead_free()`.
This is a critical security improvement because: 1. **Sensitive Data
Content**: The `tipc_aead` structure contains highly sensitive
cryptographic information: - `salt` field: Cryptographic salt used in
key derivation - `key` pointer: References actual cryptographic key
material - `hint` field: Contains key identification information 2.
**Memory Security Risk**: Using regular `kfree()` leaves sensitive
cryptographic data in freed memory, creating a potential information
leakage vector where: - Attackers could potentially recover salt values
and key hints from freed memory - Subsequent memory allocations might
access residual cryptographic data - This violates cryptographic
security best practices ## Code Change Analysis The specific change from
`kfree(aead)` to `kfree_sensitive(aead)` on line 428 of
`net/tipc/crypto.c` is: ```c - kfree(aead); + kfree_sensitive(aead); ```
This change is: - **Minimal and contained**: Single line change with no
functional impact - **Low risk**: `kfree_sensitive()` performs the same
deallocation as `kfree()` but adds explicit memory zeroing -
**Consistent**: The same file already uses `kfree_sensitive(aead->key)`
on line 427, showing this practice is established ## Alignment with
Similar Commits This commit closely parallels the "YES" backport
examples: 1. **Similar Commit #1**: Used `aead_request_free()` instead
of `kfree()` for proper crypto data handling 2. **Similar Commit #2**:
Applied `kfree_sensitive()` to crypto buffers containing key material 3.
**Similar Commit #5**: Fixed TIPC crypto security issue (preemption
problem) The pattern of replacing standard memory deallocation with
secure alternatives for cryptographic structures is well-established and
consistently approved for backporting. ## Stable Tree Criteria
Compliance This commit meets all stable tree requirements: - **Important
bugfix**: Fixes potential cryptographic information leakage - **Minimal
risk**: Single line change with no behavioral modifications - **No
architectural changes**: Uses existing kernel API - **Contained scope**:
Limited to TIPC crypto subsystem cleanup ## Security Impact Given TIPC's
history of security vulnerabilities (including heap overflows and use-
after-free issues), this defensive security measure is particularly
valuable for preventing information disclosure attacks targeting
cryptographic material. The commit represents a clear security hardening
improvement with negligible risk, making it an excellent candidate for
stable kernel backporting.

 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index c524421ec6525..904f1cbe8e7b0 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -425,7 +425,7 @@ static void tipc_aead_free(struct rcu_head *rp)
 	}
 	free_percpu(aead->tfm_entry);
 	kfree_sensitive(aead->key);
-	kfree(aead);
+	kfree_sensitive(aead);
 }
 
 static int tipc_aead_users(struct tipc_aead __rcu *aead)
-- 
2.39.5

