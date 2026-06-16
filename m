Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9655047A0A9;
	Tue, 16 Jun 2026 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630767; cv=none; b=PcvQWRxEs1YFe812IhxiUE8vVNyFnIjzlgV87GnP2M8MuHuoybLwZhSIP4MCHKUv3+4a5Avys29rS7YRagPN0EiZv15ZVpec+w59FCsdeYeUkcE5Hpxs1uJAtNP7WIJEcuqm1s7PxX+kXwgOoLRk52NV1mz0FnHUvAN9MORuKCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630767; c=relaxed/simple;
	bh=EfiI3CCEsmPBE7OqgKxFXhv1RylZZXkSezccGdOq0ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYGa23K7DvzNE+X/+P+XuxvlTRX+r8fMOAmpOGKk+z5xf0/HOjINWFmMtP6hKtUzZSG83wE1PMVndAOSuglxchoXnMhBUAGkVSRctRvYg8XD8md1NajJD5B2yPeJVx7G4YQhI3B83GlJqNxEAJ9xOifTQt3Hq8rqeQoFbhWrXqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crvx1ghZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crvx1ghZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2B41F000E9;
	Tue, 16 Jun 2026 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630766;
	bh=0arqabB24sUwym8N2HsZb79al4T4h2zv/Tj4lZMp4Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crvx1ghZyE2G1fNtWnQL/lg5aGhWkpq3qYIKxT5nNjBGH0RT8y5GdiahWjeYzDUKF
	 Dop6cSaT5dV4mtoUxtek2vFTWGkzrwiqS5bsNdMOsg8vCFLJsuJVDkHAkhnIlOjBiQ
	 SXLDqOLJjl0bgVM4G+s4PQkLbzMybWCC8EnOIhuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH 6.1 092/522] hpfs: fix a crash if hpfs_map_dnode_bitmap fails
Date: Tue, 16 Jun 2026 20:23:59 +0530
Message-ID: <20260616145130.197128599@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 974820a59efde7c1a7e1260bcfe9bb81f833cc9f upstream.

If hpfs_map_dnode_bitmap fails, the code would call hpfs_brelse4 on
uninitialized quad buffer head, causing a crash.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hpfs/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -372,8 +372,8 @@ int hpfs_check_free_dnodes(struct super_
 				return 0;
 			}
 		}
+		hpfs_brelse4(&qbh);
 	}
-	hpfs_brelse4(&qbh);
 	i = 0;
 	if (hpfs_sb(s)->sb_c_bitmap != -1) {
 		bmp = hpfs_map_bitmap(s, b, &qbh, "chkdn1");


