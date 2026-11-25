Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623454;
	b=oCqiBYEpEN32hRMbycjmJLxCraHNfyugTts0gu7eVk9vqTIq6rcVx1VazYh88HlQ1YVx
	 QVTOZpwBQgFDNJZLwq34NRr+0ihEdwkupHT3N5NjLvOvTpaI6yRl1hG1lgJhxWYHcyMH5
	 OiMqNoNbWOcAs/gbpA7R0nNaval9RwNYRTrXwNliU69KUFnWgOpebhlAC0V1VhRbqMBRo
	 NMJZjB7RnKOB/4/ZOoSECC5bIKLEP6Akdg91yWK8XmvgISuhZJEU7UTCuKOO15lNmZn6r
	 JaDnuc9j8z6Dj/TmFy+Fu93ePu3UxVARv+M2n33ljPJDhrp22QDG+zKIAxznpb0zNuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cq7PkrrVNPfNoTHCUSfJ8luS02HX1Kb4kMSEmctCt1Y=;
	b=yOQewDyr1SCE8FReijIq1OgfK5glPTvHWP0b0I6wflZTZnon01fHL68bs+88wtSqaDbo
	 Rm9U5tJi/AdWWmJuQ7G2JTN3nPUrOXWaqPAMZVdcF+d1YP2AddpHEMaDszS0QVF12utt7
	 W6SxqvI9S/9XW4bGQvf8pxYlNSFZm8UZWl1SBI6tzJy1sjPhw/gLIUl+QvVD6iwhH33AO
	 ty3IjuH5oIhjZ/jXtaW4ak+K1RmipXPQuPorbgMv1QdBnCzxx0errfbJHXc2bTCrtYMfh
	 aEsS8itM28Nso1aWoCDyMWMkMzMrzCU1jeMwGlwHqZEHcVbxTV8mMjF6DVWMAG1axsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HG47rjOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1795C606A31E;
	Wed, 25 Nov 2026 16:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HG47rjOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC441F000C4;
	Wed, 25 Nov 2026 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623453;
	bh=Cq7PkrrVNPfNoTHCUSfJ8luS02HX1Kb4kMSEmctCt1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HG47rjOQMdtsS7F2t5aFZPQklK6eLaFbRaIJX6ndyYY78hXADPrCkaCxgYHUNk7Qo
	 djBBLmtwS60YowW73PyG1l3+eAdBj7lSdU0MGUInOVlqH2IolqyTjPw9ebvr0++zEm
	 QvyOb3vjIUBR2upjCiYbS/fr0AEM79v+ml6EKjek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 864/990] dm persistent data: dont leak bufio buffer if find_leaf fails
Date: Wed, 25 Nov 2026 15:37:11 +0100
Message-ID: <20261125143842.263894465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit b27523a0781aae0b51ac13f29dc65373d14b8434 upstream.

If find_leaf fails, the function dm_btree_cursor_begin would return an
error, but it would keep the dm-bufio buffers held. This would result in
a memory leak and a warning when releasing the dm-bufio cache.

This commit fixes it, so that dm_btree_cursor_begin releases the buffers
on error.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 7d111c81fa29 ("dm btree: introduce cursor api")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -1582,7 +1582,13 @@ int dm_btree_cursor_begin(struct dm_btre
 	if (r)
 		return r;
 
-	return find_leaf(c);
+	r = find_leaf(c);
+	if (unlikely(r)) {
+		dm_btree_cursor_end(c);
+		return r;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_btree_cursor_begin);
 


