Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690E56F53D;
	Mon,  8 Apr 2024 13:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582512; cv=none; b=QpUNBfxRqL+0uC++X+Binti7n4PGdMFjIlHqisAI5GM0yuX8tLjoBWIGOJec9Vrjw5KC6ed0AONYp91qT+d6cw/QsG6kAgvStFvYQ1lZObri5wn04wfHWlhR/4Zs2Bz30sACAgXQFOX3MtjFiE/CJ9Z/EekMi5vwdZxn8ZrxUfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582512; c=relaxed/simple;
	bh=3FJehmw35hCujxCOJPHk8OBJcnK5TixMyEY+kbQWGzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm545PnjRF5jUSpBQlY0Yl1B8Goo6z9gj5luL0ohDfl0PK0f/0G2UjYxcgJD+m8TIqs2DTBw2fqUSpkwpWgAXt8+8Tp0v6ndNp0693l/dgGuqPgcsNiBwUZcBYHcrzmAwK8La0Ws4C7se4i/JqtVcc6ZPzBeNn1u2s+kvl2VDY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qylI4Mk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qylI4Mk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD61C433C7;
	Mon,  8 Apr 2024 13:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582512;
	bh=3FJehmw35hCujxCOJPHk8OBJcnK5TixMyEY+kbQWGzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qylI4Mk1rBc63w+B4ylvmL0VdpQ1b1x6dfiPkoLDOKWYHObuBnn7jv/K5/x6SKA0l
	 aDJ9P1VkFgcbZ+6y1fjaeeiBGSV7QAyqF0MNZJKn0LNDu3Q5C3ZuD2w4IBdrpmoWVo
	 lPO7e1k2ECJpLSVB23lMI44yxP0EpZYXe1aD/8cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 112/138] ksmbd: dont send oplock break if rename fails
Date: Mon,  8 Apr 2024 14:58:46 +0200
Message-ID: <20240408125259.715117045@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5579,8 +5579,9 @@ static int smb2_rename(struct ksmbd_work
 	if (!file_info->ReplaceIfExists)
 		flags = RENAME_NOREPLACE;
 
-	smb_break_all_levII_oplock(work, fp, 0);
 	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
+	if (!rc)
+		smb_break_all_levII_oplock(work, fp, 0);
 out:
 	kfree(new_name);
 	return rc;


