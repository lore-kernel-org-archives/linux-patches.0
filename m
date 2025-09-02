Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04958212568;
	Tue,  2 Sep 2025 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820476; cv=none; b=iCb8uzBgaBYKgPAkDldfTihLymu4/YEBmgqVZEihoaUdKhm0fDL2WlaeYnsDHVIokCq4SHm8tES2HdlU0zb2VOfv3pR6SPfJBvlaRGagqKbSU/xNa5AjRBpOpYmP0AfSSe/JLlWpinUjoVFpMynO2L5JXFqMXQZ+NEj07COglBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820476; c=relaxed/simple;
	bh=QIJHN6SqMMFqiQOY1u5ZFh65wXIVBIcUCXCI2pkFlv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CykiFQ/WMWtz+3TI8heIzM6xdCQ3a6Jyu6SiHLdaeakSoQEubQQWAkZEV7dsa9OnvmAJ/rKD6uuPrxbARM9v6dAU8gxKryY4GUmhtt4IUdiqrfOJH8FrR0pvad/IzA8zbaFCV12l5U5MYEsTKOT8M8FvO1plCmPQVup/AT58lN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJCzVGFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJCzVGFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B2EC4CEED;
	Tue,  2 Sep 2025 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820475;
	bh=QIJHN6SqMMFqiQOY1u5ZFh65wXIVBIcUCXCI2pkFlv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJCzVGFa3/wwkK+dId5slEbI96CZapyF4+GZ9nxZioR+4L/fKa+14uSc8n00Ddxpu
	 FeZjlfAWOHf8zNkJcKwxHcc3LQIajb2OUJZ8tqQRvDxzMKeHovZ6GHeMKK8E/iCfJ3
	 3gqvQvP4nKpd+ptw4NH21YibqnXyPQUrJ38diLlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 42/50] fs/smb: Fix inconsistent refcnt update
Date: Tue,  2 Sep 2025 15:21:33 +0200
Message-ID: <20250902131932.187505286@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

From: Shuhao Fu <sfual@cse.ust.hk>

commit ab529e6ca1f67bcf31f3ea80c72bffde2e9e053e upstream.

A possible inconsistent update of refcount was identified in `smb2_compound_op`.
Such inconsistent update could lead to possible resource leaks.

Why it is a possible bug:
1. In the comment section of the function, it clearly states that the
reference to `cfile` should be dropped after calling this function.
2. Every control flow path would check and drop the reference to
`cfile`, except the patched one.
3. Existing callers would not handle refcount update of `cfile` if
-ENOMEM is returned.

To fix the bug, an extra goto label "out" is added, to make sure that the
cleanup logic would always be respected. As the problem is caused by the
allocation failure of `vars`, the cleanup logic between label "finished"
and "out" can be safely ignored. According to the definition of function
`is_replayable_error`, the error code of "-ENOMEM" is not recoverable.
Therefore, the replay logic also gets ignored.

Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -81,8 +81,10 @@ static int smb2_compound_op(const unsign
 	int len;
 
 	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
-	if (vars == NULL)
-		return -ENOMEM;
+	if (vars == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	rqst = &vars->rqst[0];
 	rsp_iov = &vars->rsp_iov[0];
 
@@ -510,6 +512,7 @@ static int smb2_compound_op(const unsign
 		break;
 	}
 
+out:
 	if (cfile)
 		cifsFileInfo_put(cfile);
 


