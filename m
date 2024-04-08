Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B867C0B0;
	Mon,  8 Apr 2024 13:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584054; cv=none; b=M1JjSZ/WHANHf6FfrcEIV5Qv3p4SDX40jDDe+pc5r0vIokOXCKOobc5+HYbKhE0OFNmn1OOb1osOOqh7Fi978zKqbt80FPM5/7CEqTVT+aGL4CLNxmGk86ok/0T+BNbHoxhu2KkONmGvDOJVSac6xyMkpafzaBf9hmF5KSUc4xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584054; c=relaxed/simple;
	bh=KBPtMcsfgdNnlW4zzUXvVGF/1hzXal82h1z0UncvRPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFd3CGoPSEehj2S3tD6DwXril5/1zomLoO6fqbcQLvG3LpsStBY/Yr1Ji7ZuQEf6n5vfdtSiNY+JXVIMeJztaka2lywVeJoanjPB5YwXRN+yUriZbeYuIuOWMl76ioIWj553SqC9M7S/fd1TJVAcr7i/nXca/reUwzAFPByq1TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dsh4fVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dsh4fVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30FBC43390;
	Mon,  8 Apr 2024 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584054;
	bh=KBPtMcsfgdNnlW4zzUXvVGF/1hzXal82h1z0UncvRPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dsh4fVSrEfJbbshMJ8GJZIKgNDuX6RBOkFLw3k+GRp5/TqiaK81EuJp06aGgLx+h
	 l+B9EU/o4mvBkDnruRbpDwMiuP7+gQevsZW0J5sEbX/Fz/joouYURkNLX7K5aZDybu
	 o3gi0cpDRg08kIzgOiAE7JXS4PHlpffxpFCK1O64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 254/273] smb: client: fix potential UAF in smb2_is_valid_lease_break()
Date: Mon,  8 Apr 2024 14:58:49 +0200
Message-ID: <20240408125317.335385771@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 705c76fbf726c7a2f6ff9143d4013b18daaaebf1 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -622,6 +622,8 @@ smb2_is_valid_lease_break(char *buffer,
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			spin_lock(&tcon->open_file_lock);
 			cifs_stats_inc(


