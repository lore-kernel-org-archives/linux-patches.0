Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022272;
	b=f1yHZ3ojg/M0qKrTBmYw5EwoDD+5KS2Uff8iQ9jFBk+BdmWPNJYAd8Zv+JtLRFKo0G45
	 SYNgmcTNy6+LqAtalyoI708p6n4mUcfOmAG7MtkHLgFyUW7dFGm6i+qKjzEqy0Qp7OLU1
	 tgx1tMknEQc6Cq+x8TGgDx7L4tyqHQF7UpLF4qbiNeMWTEb0dL7w/wbtye43vPifhSXk9
	 7AP+BouCqIYDUiSSzK/r8+TXhj0TmhSS5SP4JYZgTqNSSzGjuVhkHgRf4/1cDpT7kXDWF
	 52G+AwfBCpT18VNt63+MKXnp9t11TAZyi72FmHrtjkvaskh3bT1hDNfiY4OLfWr30Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gBh8tCTK92bVXmaUUHEYnFuXL//6n4hp2/H9CJp3EKg=;
	b=K1u5Ldb3mdpIn8aZKd3sHtRWuS9+cV4I5SqcQaPEByiO54K/XjuNe++L/boVoiGD/xQ6
	 kCmgh7kXWwotCnGSArHIkOrSRw+COIEMsjWqu2ayYVMaLDdQuR6bdgXCmd28pPQigvb4+
	 Rq92KYFNCPNKvPpTTkeuUDH7pyJUAMcws5/CGkCk6TW7cntfSzr7QM3kT+zZ1Xe5I42bp
	 ZeAl7FnRop7Drfd5Iazr5CYHU3OaT0155GJosPmBq69sLKpFmPWhoK6W5e5CCtLLAaRK0
	 /oDBQJ4jCC3a8Fo/H1jGWygKn+WWCQwCmPXT2/N2jP3bvLCHMXDB+rGeLr+Zrqxwwrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opqPXdCi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94311606A325;
	Wed, 18 Nov 2026 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opqPXdCi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BF91F000C4;
	Wed, 18 Nov 2026 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022272;
	bh=gBh8tCTK92bVXmaUUHEYnFuXL//6n4hp2/H9CJp3EKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opqPXdCiSmDXk1OnvjC+35azTBKLocQQj15Ud16kv9EK8CK+2gY0buDDsCgfaHfMJ
	 OQ7dvbiwBvZf3lgwE+XHx1PN0/X/be0ER1PPfdGH4918VU5NEn2YiyubpnVW8rQJ6j
	 FgnUgYXe/ZY9N0FkWJ3VnclviN+AV0MGil17k0Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2603/2651] apparmor: fix a leak on a rejected string table entry
Date: Wed, 18 Nov 2026 16:04:03 +0100
Message-ID: <20261118150417.975873031@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit f7bd6285ffeb425793334f6d48ccb5035cab2fa7 ]

unpack_strs_table() stores each entry into the table only after
validating it, so an entry the validation rejects is never freed. Up
to 64KB leaks per rejected entry.

Store the pointer before validating it.

Fixes: c140dcd1246b ("apparmor: make str table more generic and be able to have multiple entries")
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 99dd61e3b1038..a633f924948f2 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -558,6 +558,9 @@ static int unpack_strs_table(struct aa_ext *e, const char *name, bool multi,
 			/* aa_unpack_strdup verifies that the last character is
 			 * null termination byte.
 			 */
+			/* publish before validating; the error path frees it */
+			table[i].strs = str;
+			table[i].size = size2;
 			c = process_strs_entry(str, size2, multi);
 			if (c <= 0) {
 				AA_DEBUG(DEBUG_UNPACK, "process_strs %d i %d pos %ld",
@@ -570,9 +573,7 @@ static int unpack_strs_table(struct aa_ext *e, const char *name, bool multi,
 				/* fail - all other cases with embedded \0 */
 				goto fail;
 			}
-			table[i].strs = str;
 			table[i].count = c;
-			table[i].size = size2;
 		}
 		if (!aa_unpack_nameX(e, AA_ARRAYEND, NULL))
 			goto fail;
-- 
2.53.0



