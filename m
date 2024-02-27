Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D408E54BFE;
	Tue, 27 Feb 2024 14:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044283; cv=none; b=gXoS4kFdi6O4ZVaFxCoL1e3LL4yIzjm8oHbmWZhGUqW0L8KW/45K569NdIPYQg1yLo9oCjInYsUfWDZpsHlPGJbYiBYQBeCRtOSvPKhy9Mp6KvdX2di+ruQ0ci3WOt46iuYnzC6jJ4PxFAxf4f8KIVWupC0Kuk5hH1u8ymOZUGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044283; c=relaxed/simple;
	bh=5w4eW/Yc0zk880VxXzcTcKsI68vfXe1DsJTCoS/9SmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhfeDsSVidm3n0fMnOqTjEBDg5q+fnLjCbk/MDQ6ycySpoK3ZaCQtP1t6JkKRN4VQzYlIch0p7G4LhqeOkr3i9Ih7BxIfZITG1Hy2g9NSYKqF1VpVVwANe19Vgci+uyGn9Yv8PA3r8fjGKF8WWoF93lf46HKt70BDKQjsf6uk3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJaRCSEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJaRCSEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611C4C433C7;
	Tue, 27 Feb 2024 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044283;
	bh=5w4eW/Yc0zk880VxXzcTcKsI68vfXe1DsJTCoS/9SmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJaRCSEZ97TBCDDiY0fnmxMPABduhZiAQXYRByGjGwXUE3NtYRPZoCT4dV0eTH6HD
	 UUdSPzr29oadumK2zIeezBCmMEL7O9jJF0QoeYLuSxJRS9yR0pG8vRXd2/bZ0LpZRy
	 wmIPh+5QCt7mF/zRGgUbEoO2JRguXMMfErW5kOX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/122] afs: Increase buffer size in afs_update_volume_status()
Date: Tue, 27 Feb 2024 14:27:48 +0100
Message-ID: <20240227131602.206419086@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 6ea38e2aeb72349cad50e38899b0ba6fbcb2af3d ]

The max length of volume->vid value is 20 characters.
So increase idbuf[] size up to 24 to avoid overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[DH: Actually, it's 20 + NUL, so increase it to 24 and use snprintf()]

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20240211150442.3416-1-d.dulov@aladdin.ru/ # v1
Link: https://lore.kernel.org/r/20240212083347.10742-1-d.dulov@aladdin.ru/ # v2
Link: https://lore.kernel.org/r/20240219143906.138346-3-dhowells@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index f84194b791d3e..fb19c69284ab2 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -302,7 +302,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 {
 	struct afs_server_list *new, *old, *discard;
 	struct afs_vldb_entry *vldb;
-	char idbuf[16];
+	char idbuf[24];
 	int ret, idsz;
 
 	_enter("");
@@ -310,7 +310,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 	/* We look up an ID by passing it as a decimal string in the
 	 * operation's name parameter.
 	 */
-	idsz = sprintf(idbuf, "%llu", volume->vid);
+	idsz = snprintf(idbuf, sizeof(idbuf), "%llu", volume->vid);
 
 	vldb = afs_vl_lookup_vldb(volume->cell, key, idbuf, idsz);
 	if (IS_ERR(vldb)) {
-- 
2.43.0



