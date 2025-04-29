Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326A242D94;
	Tue, 29 Apr 2025 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947254; cv=none; b=h79FS1EcRMy+pU8c8HpQ6rE5nSEHhr47MXK8ZMSDLaLr+zd4RwmxiO8kRuJ//kMab+IBRRZyVDPXhOIIKfaq05vnWyUnWKWuV17EUlD5gYPMLd43CY8xPwec3R+q62lpvrZRK9V93sQBNGLUwlVsnROb0tPBYLLeasD1IPnqMFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947254; c=relaxed/simple;
	bh=hIg6uYmMDhLr/Ph/DngLQPstFQPP1z+Pe7x0ophHMaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWuYei7t9JoYqicTkwEVv25y+AIcIkf+jKdoXWRzt51Hl+SbxxJDX/x5ivgdt6oIu6ciLzPf12bIPgAQFGQ/no7+/w64tJpc5Y4l7WTsxojd9ikfonoW536UWtWyJ/TCk4NzcX8J8Spzb+EOPaaozQRz8PXPgP17jQq9I/611R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/HImkcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/HImkcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23186C4CEE3;
	Tue, 29 Apr 2025 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947254;
	bh=hIg6uYmMDhLr/Ph/DngLQPstFQPP1z+Pe7x0ophHMaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/HImkcux5XcLVJFPJVOUuFosy6Ao86sFZshkveLylTDEs4Fz70VxHFD2LauZxxOD
	 GWRCx9qogjBO9Fjj/OewHl+x4/H2gmVhqUsEMjijyHMcHumg04K85fgttRgoCkjf4Q
	 pEnnSHN4vGcMAlZdib3r1q8jnzDH11pLDMpPjVis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/286] cifs: avoid NULL pointer dereference in dbg call
Date: Tue, 29 Apr 2025 18:42:05 +0200
Message-ID: <20250429161117.035581918@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexandra Diupina <adiupina@astralinux.ru>

[ Upstream commit b4885bd5935bb26f0a414ad55679a372e53f9b9b ]

cifs_server_dbg() implies server to be non-NULL so
move call under condition to avoid NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e79b0332ae06 ("cifs: ignore cached share root handle closing errors")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2misc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d21b27e68f2a8..c0b80ba8875af 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -809,11 +809,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
 		spin_unlock(&cifs_tcp_ses_lock);
 
-		if (tcon->ses)
+		if (tcon->ses) {
 			server = tcon->ses->server;
-
-		cifs_server_dbg(FYI, "tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
-				tcon->tid, persistent_fid, volatile_fid);
+			cifs_server_dbg(FYI,
+					"tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
+					tcon->tid, persistent_fid, volatile_fid);
+		}
 
 		return 0;
 	}
-- 
2.39.5



