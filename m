Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207349;
	b=iO2gzB2J0jn1OLMeJ6S19t7P/AHu6nNYkS8KbVF3H6h1X8fOs3PiiIBx4lT1ebskaHOJ
	 wCaxfW+lgVEevfDJVijCJIY/ta/nVn3REl/RAZvtZv1EKSPKZZT6wiowT4qt1GzX2FOzK
	 B7xBTDvcjwV+nSZfeYWGybOltPgX/1QbxtvVdkqhnYf5t+NevVd64ODYJQ0olmy8VWiOw
	 pCnMU6a67EMrl2E6d3dm0IRl/cG7C+X+JN/dDasL2kIuwxkUaB06h8r3JuTGn6wGuLWLw
	 gZ7YHPBUGYFSR7VQv/U2SEyue+sFg4Wr0Rh6x6a8W5oQZr9GX2Ja4T3sQt175+zb0mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jxsC0r4D3qpyDpkIH+Mo+/w22zyfKoyourhWSKgwvS0=;
	b=SJERs+EM/3GSuZ4arCh3SEg0nKdRj8oJq5NeW7V9Z3pIzpOIIiun1d1od3pay+4dQs1a
	 Cy+Y7PBHW+tCaRIOh//EaxB3xPWAH99tgIinDC1PWpCosC35ENoOGYNtTAN4PjA/Uyvc1
	 BHb18t49M0d3wdOZJopbG71N1Hi/uyhGnqYVQ2NXS6cjxbeo8qdWhRfgFZ0DzSZ9tPl4l
	 YiRevgjFdip4VZH+672TW37etsiZaOu6pq/m8DgLxX5d2f8sOAf41dcDJOKRZzw+x+gl0
	 sc7aYZp3/LP8mjEKICRZs2HbLIMv9402zjpQVr3eZaA+7Gk+tiZm5/DCpKHT4T1HzJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SQMS/TcY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122DC606A320;
	Wed, 28 Oct 2026 17:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQMS/TcY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633701F031E6;
	Wed, 28 Oct 2026 17:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207348;
	bh=jxsC0r4D3qpyDpkIH+Mo+/w22zyfKoyourhWSKgwvS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQMS/TcYgK1isfULoyqALb1IDoCK1y+x9Td7GG7jK0/zjJZdQxTtRmDggO4vhzeQo
	 9fCydJfK+q36mYUs70QLKGe+TNzdeyJqlpLLvKX1OLWbDxSfgJ1a3x2LhxZ8brQEgS
	 DBegJPn9jSmbQyIep5AVtxsw4cMPWUzpkB9os0Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 7.2 75/88] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:00:23 +0100
Message-ID: <20261028165943.881612698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Martinez <adrimg3196@gmail.com>

commit 0b157166e612b70f98a332b6c7be7eac6f8e9593 upstream.

The restrict_link check in key_reject_and_link() is done before taking
the keyring semaphore, racing with a concurrent keyring_restrict()
that installs the restriction while holding the semaphore in write
mode.

Move the check to after __key_link_lock(), so it is done under the
semaphore, matching the pattern used in __key_create_or_update().

Cc: stable@vger.kernel.org
Fixes: 5ac7eace2d00 ("KEYS: Add a facility to restrict new links into a keyring")
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Adrian Martinez <adrimg3196@gmail.com>
Link: https://lore.kernel.org/r/CACO1+RT+m==BY+ZPkE+fo536D0qu3wog4xE1dfuXQ56g+=Qv=A@mail.gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/key.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -588,11 +588,18 @@ int key_reject_and_link(struct key *key,
 	ret = -EBUSY;
 
 	if (keyring) {
-		if (keyring->restrict_link)
-			return -EPERM;
-
 		link_ret = __key_link_lock(keyring, &key->index_key);
 		if (link_ret == 0) {
+			/*
+			 * Check the restriction under the keyring semaphore.
+			 * keyring_restrict() installs it while holding the
+			 * semaphore, so testing it beforehand races with a
+			 * concurrent restriction install.
+			 */
+			if (keyring->restrict_link) {
+				__key_link_end(keyring, &key->index_key, edit);
+				return -EPERM;
+			}
 			link_ret = __key_link_begin(keyring, &key->index_key, &edit);
 			if (link_ret < 0)
 				__key_link_end(keyring, &key->index_key, edit);


