Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E297D074;
	Mon,  8 Apr 2024 13:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583520; cv=none; b=pRrjYfLChoSiTeQOJgMJJbvviX2Rh2LfpxRpSycvsh86/sFlN3JxIYuDiRcu0SnHEBUKJ+X8GBjHUG/GriR5ZpTIH9LGsBglM7SiI+pc0/mJRzCfE/GwApJL/WGr72TG6NW96SGHtBt8h30U4CWh5hlfm7kThp5aohoX/YZzoeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583520; c=relaxed/simple;
	bh=yHv5mdT59vw3+AB+ZUJyz5T4+mXcTnciHILng9eHs1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5+4O0OjCNDZ2TaWZORcLJAFEB1CniM30LT88rpv4HKO/L1WeBRBeLz0hM9ZcJ2chHWrFoxkZyuZPi2Jv46k9AJZ6Qr8Xj0AkaCGAwVrtzlspVjjLycINCfGB77751w2J70j6Yh2mmq86fYJMpM0q1u0/uGL2YRO0UHzh5pz67o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzUVU8v8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzUVU8v8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F954C433C7;
	Mon,  8 Apr 2024 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583520;
	bh=yHv5mdT59vw3+AB+ZUJyz5T4+mXcTnciHILng9eHs1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzUVU8v8T8Dbqj7aaz0gruWSZTt9VwYpew/ymFwB9Oku4cGT26aDtXdisYYQb8HSz
	 wxtLioM0xIKweOKuYImCozyt4wE0OuzjW2JGqKKK4NMr5kIWzHEXOYUeBmuPN5zWHc
	 wGXlh+qiLdzNwpfnrH5tvmdC92G+X269IsUZ7Yho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 204/252] ksmbd: dont send oplock break if rename fails
Date: Mon,  8 Apr 2024 14:58:23 +0200
Message-ID: <20240408125312.984402061@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit c1832f67035dc04fb89e6b591b64e4d515843cda upstream.

Don't send oplock break if rename fails. This patch fix
smb2.oplock.batch20 test.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5631,8 +5631,9 @@ static int smb2_rename(struct ksmbd_work
 	if (!file_info->ReplaceIfExists)
 		flags = RENAME_NOREPLACE;
 
-	smb_break_all_levII_oplock(work, fp, 0);
 	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
+	if (!rc)
+		smb_break_all_levII_oplock(work, fp, 0);
 out:
 	kfree(new_name);
 	return rc;


