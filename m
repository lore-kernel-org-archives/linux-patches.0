Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7FF17C208;
	Fri,  6 Dec 2024 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498288; cv=none; b=HH4xDE10DGS4ew8Tb0IvUXbCe+zqRHWBG9xTga/HRiUylNhtNb2okyZHXmiXYic3LJzWGc9rmG493rFwskn8lFDR59rtKV7vE9ETchemwsQ+sJ7kUyxp4bSxTn8rmK1c0knb29y4eHVudWpx66ZqAqUSOjuIXnCRLHvKS8qqEkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498288; c=relaxed/simple;
	bh=SAsFJPEiAE6FVRrz9h4buuBjUiUap7RBbYhZ3nKVMr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpwxmCKbKIhyfi4ZBKIOZ+mPGntFnC8lJkf+8aj7NDYWqdBgGPMY2X8+Qs6lgRHuAg6VgVpSe6DgPEhG76llvv2bbxeRxjkL92XjGwFNiKeSs/C7jZa3jqRZHp9Bysa2yM2xKSaW/0kMNqEzENwtU6eqSuzYthCObv2nxEzkoHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olxaM4tP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olxaM4tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183DCC4CEDF;
	Fri,  6 Dec 2024 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498288;
	bh=SAsFJPEiAE6FVRrz9h4buuBjUiUap7RBbYhZ3nKVMr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olxaM4tPpbFOhYsJ5tTbOMvX08aFbsqesKIfoNksv4i+70j1ho9IwC5lOD4chgsSH
	 peLRFTDVb0n/9hkM96/TwhFblUJlYXMdcMZXPx+Hm5jc/Fx+qzlpvuy2cifj6LV1Vw
	 bNDq9eGeL5JbJj/OohUHDDohI0KS8LVsZfFqQOtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 540/676] smb3: request handle caching when caching directories
Date: Fri,  6 Dec 2024 15:35:59 +0100
Message-ID: <20241206143714.452639119@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 9ed9d83a51a9636d367c796252409e7b2f4de4d4 upstream.

This client was only requesting READ caching, not READ and HANDLE caching
in the LeaseState on the open requests we send for directories.  To
delay closing a handle (e.g. for caching directory contents) we should
be requesting HANDLE as well as READ (as we already do for deferred
close of files).   See MS-SMB2 3.3.1.4 e.g.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4016,7 +4016,7 @@ map_oplock_to_lease(u8 oplock)
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
 		return SMB2_LEASE_WRITE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_II)
-		return SMB2_LEASE_READ_CACHING_LE;
+		return SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
 		return SMB2_LEASE_HANDLE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE |
 		       SMB2_LEASE_WRITE_CACHING_LE;


