Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC3A257AD8;
	Thu, 17 Apr 2025 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914903; cv=none; b=awNmVCBWoP34OIJTEGeniiLBtbNXUl8lrtqueJ1Dq6rIe785onYewU7pluZAz/LgpaVw5vj+a7i0nB45zLMXapydylSUWhqO0WDlEd1cpH8eKQ6yyU/y7VGgn+MhPLHwvapyHdNBh/M7OoxbdRAgZsg/aQ3MtUiSnDfOFl4UrQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914903; c=relaxed/simple;
	bh=bLuyetuUtXeOzDXRylFpS3I27XoAopijWzqAtsT8NWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngoAOnidmlpUrVa9J3F3/2fGcICsEi2MvtMdmKLeRIff9Ywc7ducj1pEDs6jW9JzNvbrjadKAMIMQzVpgRYTSK3VSMLWmDqXfFv3dzYZPJwI9tTQjcXxwfS7Wlu0y0YnRtaLEyDAzPK+Kq50y0Uc2kdvJVmeQJZzMMHyqqT25oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGB1q2tC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGB1q2tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC900C4CEE4;
	Thu, 17 Apr 2025 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914903;
	bh=bLuyetuUtXeOzDXRylFpS3I27XoAopijWzqAtsT8NWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGB1q2tCyR5ffdsJ0u3TVs/ULEAVx0tVB8IRRKmsOiOljKWd9E0sF8rEbqjByIMXM
	 M2MeFpOtrhkuxL4ClEjeFK8G3qZMZ/hIMv7BByfF8eDWEtPWwYxIurxEiY096IkVas
	 jNzsQlPSYh/CIu5VMr0CwHB747i9x5Qct/vakrG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 341/414] cifs: avoid NULL pointer dereference in dbg call
Date: Thu, 17 Apr 2025 19:51:39 +0200
Message-ID: <20250417175125.145684802@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -816,11 +816,12 @@ smb2_handle_cancelled_close(struct cifs_
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


