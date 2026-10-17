Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E44392C3D;
	Sat, 17 Oct 2026 18:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260351; cv=none; b=oDGnDK7bjx2dvykNnlvrFxRUyejJxwwMZpstjrI+pdgROal1f4EJ8pq/VzGhQrQciWpBf2Vv3YcVsA71FT3usYCfHmj+zn+V+5m7AYRX+2X+w9to6BAZgP4XZFNY6+IrEwTwnF/fMCVInGLERFPOKrPjbAhyhmvYcxIaWKGBOPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260351; c=relaxed/simple;
	bh=uJJfH6iAnAqtHAdKvxwxHgqEwNv4j/dj6PGpt9BrbGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCbUDLyKw2QYyYrh5dnC3/ThZXrfzQv5D0PoHiin2qvqBeb4JdRShPY4Y2zhv1SmDuEO86HzRPianHsgYwxDm8RxMcuQVb1pHKpTkYerDhvTpHrGW7akZcS090JPAojezY0BeOeMi8XK4kPS69sF3/0RSXOYyl6OYRoJGIcmJJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVUEpu6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVUEpu6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2751F000C4;
	Sat, 17 Oct 2026 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260350;
	bh=BpmacDH4i37NC6JoyjGD+c1hjKOqltQOXgBKFJv0zrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVUEpu6FnxFck3UzRCmgKlPhk8FxQwTFO1dFZ2aiK15xCTOUMAU4LxgZQ+XhytDLE
	 fwelP7IaJKYdXF4mCaJlWy+wXbEax1UojFzIaU2uyuB9jRwVBtxE4NZoKIUNf/cWT0
	 MbnAXKVStP2wQ3/PwBKMRKmZuE0I2NJ6qlrlMJh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1516/1674] ksmbd: remove redundant DACL check in smb_check_perm_dacl
Date: Sat, 17 Oct 2026 18:03:08 +0200
Message-ID: <20261017160510.034747485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit 8dd2e58b62731a96e276ee0545fb910ffb2057d9 ]

A zero value of pdacl->num_aces is already handled at the start of
smb_check_perm_dacl() so the second check is useless.

Drop the unreachable code block, no functional impact intended.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cc2f133e80eb ("ksmbd: fix maximum allowed access checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 7824c20dc80e2..a1765abc13b42 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1498,9 +1498,6 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			granted |= le32_to_cpu(ace->access_req);
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
-
-		if (!pdacl->num_aces)
-			granted = GENERIC_ALL_FLAGS;
 	}
 
 	if (!uid)
-- 
2.53.0



