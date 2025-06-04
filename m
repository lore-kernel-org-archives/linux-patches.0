Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED78C19D08F;
	Wed,  4 Jun 2025 01:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999128; cv=none; b=FQQCzT98kIg0oHMbObtrcJxFKPaUajKgj4qE4ahK+owFKa0suCnf7+/F/iK3WTZtF6aSJq2wDSMHZmYLSFiWQvfrhiubbuDWmbF7Qr1T8fFSf7Z8bcWAn2Qk5tZGmWSJPCTinUPc51Mg7uw6Omzr8jIbcVx8mkWXG4hTLWvxlUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999128; c=relaxed/simple;
	bh=7sPYSZ1OaFDu3HNANzwCOrbzVjcsp9WNbN6myF9HpxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aYY6vtHacroalV8gW5zhn2yLhO84A4WXWFqlg+grSJ37aMoLOkEOZLZTR4S1Xlmo5qy0jmhgrqzsjHHy3IxYehmIDqU5bveW4Pmzq3Ct+Afcyqt/Kg5KM06EmznZvE7Wn7+59JJn8STSSglqL3IdB9ibMDWigHGvm7kVY6rlqiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6SVtp7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6SVtp7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0CCC4CEED;
	Wed,  4 Jun 2025 01:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999127;
	bh=7sPYSZ1OaFDu3HNANzwCOrbzVjcsp9WNbN6myF9HpxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6SVtp7TYJI+kmRZ7aBR7wwVvCOQ4c6xT2uEiqfY64XtCdao29kaxvZB743qW4BSz
	 9OJjuW1GxLKWBWeVw9Dh+GaM4HwsLOaM/bsklluvjCzSa/44n4tuI8grNJBZ3YVeUp
	 /Y2NBPbG7cfFNsN6m1bWCcVfdyCzaDKKAIUZzgXIQdoTILZ5V5l52ZKTQp5cknCwEL
	 0YacOoJGU3CvwaD0O9zcMDOEKLF/YN44Rr3XzTMpcfV6UHgzu65VM+sCJ3PYKOBg4C
	 GublHx6duRT6yleOXz+Ee6wP9LOlKMJZg6Y1dMpM3HEG5SkkfnQ/DnbgWkMUtAOSXT
	 PtpIoAsioHl3Q==
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
Subject: [PATCH AUTOSEL 5.15 02/33] tipc: use kfree_sensitive() for aead cleanup
Date: Tue,  3 Jun 2025 21:04:53 -0400
Message-Id: <20250604010524.6091-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010524.6091-1-sashal@kernel.org>
References: <20250604010524.6091-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.184
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
index b09c4a17b283e..277fc5ee179e4 100644
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

