Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9417228D830;
	Wed, 23 Apr 2025 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421426; cv=none; b=SuqpqjuFeK6jeMYoHRlv/Ixfii1DCWeBjpLqcmLgLboYDc25Wsz561gbxQoyXONgQ8qAL7xxFRZRBlYldPcTitEMu7c0EuQBeoKGfaBj7o9YK+poI4TNhKIm6X+asUPZYruYPQlmZYXprdJic9Z5LEVpn1t0x4RtUypC8/tW5Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421426; c=relaxed/simple;
	bh=fXMh+Dsu+SaoTf9jm2UDZ7FbwG80W6Aio645unhllwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAMzM7ohBqc1w4HZ5y4Nsa704tcafFBYLfvHxi2/5zGXNNKCcoPPnmsmes1ebIwx5Yxk8ol8JA9zNEt9hVg3XsCPjzFaA4fhw5TMEikJIXS8RdPKPZ4WOJkrluhbgT68WIDINsYGhIYZs/qmGY11w8K6ICb2XrvctPFC9Vwp360=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGTNbrgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGTNbrgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E86C4CEE2;
	Wed, 23 Apr 2025 15:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421426;
	bh=fXMh+Dsu+SaoTf9jm2UDZ7FbwG80W6Aio645unhllwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGTNbrgCD5RKzEXGwDF1f7fBRdhCo2Mrxcex9rnClInsQOSBLzGTxy6E5RWbiU5kf
	 nqnzxaD1VBQf0dVyxc8lioycTGQkBhn8yqxd40JqK2d6CYeyd12K8UhcETaIhK+9Zz
	 Ijq3C1T5amv3T2YoCvJvvXrG00MqrRuLwhzRybFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 136/291] cifs: avoid NULL pointer dereference in dbg call
Date: Wed, 23 Apr 2025 16:42:05 +0200
Message-ID: <20250423142629.961797422@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Diupina <adiupina@astralinux.ru>

commit b4885bd5935bb26f0a414ad55679a372e53f9b9b upstream.

cifs_server_dbg() implies server to be non-NULL so
move call under condition to avoid NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e79b0332ae06 ("cifs: ignore cached share root handle closing errors")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -814,11 +814,12 @@ smb2_handle_cancelled_close(struct cifs_
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


