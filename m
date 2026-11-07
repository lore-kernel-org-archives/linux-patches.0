Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065602;
	b=J4Onz12BjGjDXTlyNJek73YdcFY6nt1dJ7KVgK6S9wQX3m1cCKAxsDR1wwDsEudIOLb6
	 gZ5xoJH+fckvIzhPkGTMN1MzigZspCNhqHX3takDrHzOWPSR5lQEQ39WWN52XCXdQzRVw
	 ci9z3OKbVzb4sHB6ZdF0g3iuqM3vMGLcmGXVflcvhFDjLZGSB/poryF+s13k2h6CM6YJS
	 0PPkVbG3f3ISO+8H05/shpS4cT6paO5/61l0B9svCDbD+TqMJ/wg4AjZbZjjCdQXikfto
	 cn4jtZKfDEoNj1eq6sDiKJfiIKzRK3D5A69RmpsbLZr4QXzRdOct37qxWqVHzdyH6tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dpd1YXeDnarZPNawIHXfYOdREDFhcguoFU7y13k0YW4=;
	b=FSraT0SToziiBauQj/3cAqFO1TTlsk+kp/fJ8NS0TZd5jstrSoM2d1eU4Lo6sOZXR3JH
	 zPvGg3M84esecugKufGkWqg1hRYI8r87SReBLXAjDwRrzHuH6hikJ2QrElJCx8OmNdEPl
	 JgqH1Ms9oAggrJ5IPrVQ9LGRBk5KzzUH6DLgXBguIcTggeuGARO9/h7kSAVg4f1Mgggny
	 pYNCxcq7ktqvFawettZ3FEpzg8fpYk/FScwvx7w6c3YIW4222oR0RHzbgAAKpRAwbZe3X
	 hcz37OW+HAwtH+6JouE71i04gr+U+DEZNK+YmRozeklIVDCTpP1h7N3IZwJEN5AeaYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgmHkWm8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B39606A32C;
	Sat,  7 Nov 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgmHkWm8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A2D1F008A1;
	Sat,  7 Nov 2026 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065602;
	bh=dpd1YXeDnarZPNawIHXfYOdREDFhcguoFU7y13k0YW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgmHkWm8qA62Yekp7YI9IlNp1yHdNwSTczAQC3h/1nIiDWbzOs8n4HJsxkskwMGwg
	 9NFY+ltSSXcVgpp2vNHQDQEKPihKalLgcdIdhk/O71HyobXoUhW8WTlugpo5RoGw5D
	 ml3rtOcCqNAQycWIw42UlkJch6WVq4A+oj5fvmpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1257/1257] apparmor: on failed load ensure profile files are removed before parent
Date: Sat,  7 Nov 2026 08:59:13 -0500
Message-ID: <20261107135014.023622479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 97ba44a2aa4c7ab011a93ce94cb595200fe4ea4f ]

The load interface does not guarantee the order profiles are loaded.
When a parent is loaded after its child, and the load fails, the
current code will issue a warning, and leak a dentry.

For the loaded set of profiles, ensure that on failure list is ordered
is traversed in reverse so any children processed after their parent
is freed first. We do not need to deal with the cases where the
children are processed before their parent, because either a parent
outside the list already exists or a dummy parent outside of the list
is created, and the list walk will not put those parents before their
children.

Fixes: 6ec46f8f1977d ("apparmor: remove fs entries created by a failed policy load")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 8f23f99d2a58f..63f7821b4dfff 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1432,8 +1432,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	 * them yet, and leaving them behind would leak the new profiles
 	 * (their dents pin the proxy) and make the next load at the same,
 	 * unbumped ns revision fail with -EEXIST on its raw_data dir.
+	 * ensure children (which are at the end of the list are removed
+	 * before their parent
 	 */
-	list_for_each_entry(tmp, &lh, list) {
+	list_for_each_entry_reverse(tmp, &lh, list) {
 		if (!tmp->old)
 			__aafs_profile_rmdir(tmp->new);
 	}
-- 
2.53.0



