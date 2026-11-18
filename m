Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033420;
	b=L1q235nF+CDDhvq6+RrKQdv1NtlU4YcT16VqyqzYaYQh32pYWl6it3ocLIAUOLMvH2AS
	 JyXv+j4HMs5UL1H9hofylS9S2WNQwTGIz3hHl+6XSUkp0T9fdlh7dkfVjeFxA5fzV5yfO
	 RUL5u86BfJ2Od5OPtjYYlesX89R9FdoE7ZAiJJIC01UWEy0SouLpzMlZ2LdnVXTl68Idx
	 WIJpfdGAQfgRRfFB6eqiNV54FSvWqfqnA2cjG2wO6FAIReYrJctoQhpB68ikIJoDx4Q2b
	 izVMqO+ppgCwH4fMwV8TpT+Sg0gFTIBPh4riv7KExE5i88AO6GCicrGpyK79fOvTNqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7bEPwk9S9+af7bcpI4Bxsp5vGsehcDF2fg2gu66n88w=;
	b=5C8vRe7KgtBnjIybOKOXDqWJs6Q+PGZdNjyPWZ6cSsXqD1R+Oy7cxCsQUnche4IBMjnm
	 OofGRUz4jP/VoeAXSFH/IByRE25+eF96LJB2vNLk1I2+KFn/FNKMyHN3yQKxDUWJD4JGp
	 bbDeLBvbmyR9Ko7HhUuuIeHozn19W+wgzz7uQPwZvxajNipWXjNCN97iIYKLwoOnMfmEq
	 RUuN2P/Gm/ypa/V0gvPd0EwB1SrqXzcQ2Li787pbyCno93CKN/Upd3MqqILM/TriWlFoO
	 qWzQwzAlW1f69GlNkMw9VQgu3ZeLUcl8B7yXisYj0+mfIdoXnKy3Af+T/G+xpW6yKpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j8kNdw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62450606A320;
	Wed, 18 Nov 2026 20:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1j8kNdw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B397B1F000C4;
	Wed, 18 Nov 2026 20:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033420;
	bh=7bEPwk9S9+af7bcpI4Bxsp5vGsehcDF2fg2gu66n88w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1j8kNdw766kv2dPc5EY1ihFvVLTdIsDdyKY3y0bKmo/LHP16Y7ToGYT2xET1RoXJf
	 q2TD+yw5Kb5hMK0BUmiph3oL+L4YQUX4thoWF+z3s93X/UJf6wm9obeK2sSFLZ3ZNS
	 i+/6MMPgTDK53XiMU1wCiN7yfafR7TNCVNFSBMVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 1744/1756] apparmor: fix: accept2 being specifie even when permission table is presnt
Date: Wed, 18 Nov 2026 16:04:31 +0100
Message-ID: <20261118150118.967877531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

commit 4d9d1a08b796efd54f1e29b42bd95879109fe448 upstream.

The transition to the perms32 permission table dropped the need for
the accept2 table as permissions. However accept2 can be used for
flags and may be present even when the perms32 table is present. So
instead of checking on version, check whether the table is present.

Fixes: 2e12c5f06017 ("apparmor: add additional flags to extended permission.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -799,7 +799,8 @@ static int unpack_pdb(struct aa_ext *e,
 		}
 	}
 
-	if (pdb->perms && version <= 2) {
+	/* accept2 is in some cases being allocated, even with perms */
+	if (pdb->perms && !pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 		/* add dfa flags table missing in v2 */
 		u32 noents = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_lolen;
 		u16 tdflags = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_flags;


