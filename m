Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9597BB0C;
	Mon,  8 Apr 2024 13:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583873; cv=none; b=awYI4s0B5/LAkH4F0rQtTN8YzuHBkt2HpGCmIrdDuyQSlEhFk1mu9WoHPbapt/d9+YjVBGsbHbLsKYgR360G/rwtadx9z+pDxCiyHVHae3XZhyvMK4wYsK8kmh18bq28bfSbuY3sx0HTu40sV6v5XP9WJmDGG9Lh+dBVNFv+UqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583873; c=relaxed/simple;
	bh=uPOiZDYPXDcGT1ENqkOk4SK9DFhQdzDnXmUSdkkGq2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfSPcAjJEt8JYGWR/xcZamtQ2zMmmbNeXHRAb5iVMnV3wtuDIgYGCGRkIT9LtUGp2Zxd9Mm7GO22KUCkDNFbOPNo1nbnXCIn16SB1twI35TFlIj8kNUkslJWof63Of9N9Cqe2H5L0/3ub0d61LkuQo1ckW4/mOK3RszFXsbxDJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBuYkv9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBuYkv9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227BEC433C7;
	Mon,  8 Apr 2024 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583873;
	bh=uPOiZDYPXDcGT1ENqkOk4SK9DFhQdzDnXmUSdkkGq2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBuYkv9v2Sy4+LOhakWxn4FpIbTERFvbkoTmDeuTVUHva7dODuUiUooKRpKZR3ah+
	 pRc7qIgHqic/FuBd96O+ctRaZAl4wPZKTLREDs4EHe5ic0dSvg9gCES6v+HSLdB7Mk
	 2B33MZyUIj3h0Np/CnEe9KDpMSNpRtx4yllNzZcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 235/252] smb: client: fix potential UAF in is_valid_oplock_break()
Date: Mon,  8 Apr 2024 14:58:54 +0200
Message-ID: <20240408125313.946661623@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 69ccf040acddf33a3a85ec0f6b45ef84b0f7ec29 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -489,6 +489,8 @@ is_valid_oplock_break(char *buffer, stru
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
 				continue;


