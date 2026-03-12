Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF852C032C;
	Thu, 12 Mar 2026 20:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345871; cv=none; b=NS7CbCvp6fSUOcOLzZ58+zL8xO1cYR512UJX1CC4dfK70SAQ+pn/2dyarP0xCH7Mc8omVT4u0GfaWk4YAIU8iAD/DEw4D3DoOCRD6fPfgbycnjK+M+kTm0+wYN5WRvfpLHLmGwsQzPk6JW2NaWOyw0BlHMAHQ4gnTKxgD/zoXwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345871; c=relaxed/simple;
	bh=VuVhZZfoD8iAZfVZNIOZTCMsbhzaAheUUDdWVbwG4RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwkW0ZKWcha9FkrtTTjllluWzvZ7URdJcYhSCLEszQvQTsLlm9V6cKsU0eJlIMoUEAF2CN0yCgWCoPzcTHTgmrBDzdIS/PTqkQtaDrW/7tRPqc4PQe0mbqikm3HmCe5JpOXeSTa1d68aA5lP7uQPkMGMJBBMLiuDvVrU4TSz6ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgFdDkyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgFdDkyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E3AC4CEF7;
	Thu, 12 Mar 2026 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345871;
	bh=VuVhZZfoD8iAZfVZNIOZTCMsbhzaAheUUDdWVbwG4RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgFdDkyJBGBZ6KPgZTgduBAXO15kyxMiKFqXg8uyJNpzs0eglH+Asx7Y39/0uKqOY
	 V6A0h3gbwIe15qpdXAPGl3P8vH0I4M0hfdtcLms40WBrF/pLMLxeMrE1LUMic3Fk9G
	 ymiNi3XpZz/l5LE12Plvp6zoAh2Nj4oZvshDvuQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.19 03/13] apparmor: validate DFA start states are in bounds in unpack_pdb
Date: Thu, 12 Mar 2026 21:03:35 +0100
Message-ID: <20260312200321.800076239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit 9063d7e2615f4a7ab321de6b520e23d370e58816 upstream.

Start states are read from untrusted data and used as indexes into the
DFA state tables. The aa_dfa_next() function call in unpack_pdb() will
access dfa->tables[YYTD_ID_BASE][start], and if the start state exceeds
the number of states in the DFA, this results in an out-of-bound read.

==================================================================
 BUG: KASAN: slab-out-of-bounds in aa_dfa_next+0x2a1/0x360
 Read of size 4 at addr ffff88811956fb90 by task su/1097
 ...

Reject policies with out-of-bounds start states during unpacking
to prevent the issue.

Fixes: ad5ff3db53c6 ("AppArmor: Add ability to load extended policy")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -770,7 +770,17 @@ static int unpack_pdb(struct aa_ext *e,
 		if (!aa_unpack_u32(e, &pdb->start[AA_CLASS_FILE], "dfa_start")) {
 			/* default start state for xmatch and file dfa */
 			pdb->start[AA_CLASS_FILE] = DFA_START;
-		}	/* setup class index */
+		}
+
+		size_t state_count = pdb->dfa->tables[YYTD_ID_BASE]->td_lolen;
+
+		if (pdb->start[0] >= state_count ||
+		    pdb->start[AA_CLASS_FILE] >= state_count) {
+			*info = "invalid dfa start state";
+			goto fail;
+		}
+
+		/* setup class index */
 		for (i = AA_CLASS_FILE + 1; i <= AA_CLASS_LAST; i++) {
 			pdb->start[i] = aa_dfa_next(pdb->dfa, pdb->start[0],
 						    i);


