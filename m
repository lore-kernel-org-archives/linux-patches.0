Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC03625335F;
	Tue, 29 Apr 2025 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949290; cv=none; b=dC2x8kedlsvy4T1Ak1l7kN2Ki9aE9RV5YUqgL8lJYcl/xOTRZYiKjxniiEWpZaX9jZeceGcpwXM3kuEf/2PYzt8kKZtMpK0yt/NkYhFlmXNjdQH9D5yK5FsTRtXE7vtiYCllH6kr9iXxFLurFSBBGtCKJXSYLi14K8ox+r4tBvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949290; c=relaxed/simple;
	bh=Vfw8vPkwXzTwf1sVYrw+C0K4aR9CedY58It+hDQXH7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ue18Y9MXght8+QRajxBxNIQaAqSc6y62OzZywu7LGm1dOJqm0ibJsmRDO232Y1o0pHhGgBQ2PlN2kyoXgiy+NNFz6LlZdWDEpUnfwNeqE5Am3vEfoadd4VH42TUETaniPsU58JoIJqS1WUvgi9v7qjzQO2bgmF0XRETLFdD2tSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayzlmDOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayzlmDOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6943AC4CEE3;
	Tue, 29 Apr 2025 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949289;
	bh=Vfw8vPkwXzTwf1sVYrw+C0K4aR9CedY58It+hDQXH7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayzlmDOLJeZOipDYsgkUtpcSZz0KWq0iCV1tFPVbaxenDQ3ttgL4zJ9tKUTrg5aJb
	 EWGaYOMNaLtJ0upqVbSR+LDjHlZBTSQEbqm2PkKE9clN7EWRG+zlzMIQJ2mDC/SOdG
	 wNNlFFRgy4HMndih0myG/j/NtgKkeRtJLLUnEveg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/373] cifs: avoid NULL pointer dereference in dbg call
Date: Tue, 29 Apr 2025 18:42:28 +0200
Message-ID: <20250429161134.275170345@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12b6684f2d372..b84e682b4cae2 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -788,11 +788,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
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



