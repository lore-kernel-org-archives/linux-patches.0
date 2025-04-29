Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B777321ABDB;
	Tue, 29 Apr 2025 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947169; cv=none; b=dMs8u3z8o7e8YBoKaC1a3tWDPePQO45mXxWSB9pEiS/+0gsySW//lXCmUmyPKNAiIFf78YDSJakXH/yWAtLjhJuUlG7klZVIJpvaTulPB6ZjB1YolWmJR7dtiWmX+EDVBq2I0MfbddJdrsjHD8P+fqri109RVZt8prIL+7fJsW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947169; c=relaxed/simple;
	bh=Nx2FiEI32+ee4sDl+1QgFsbTHg/KmwtiZAHuZTRuKxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPINA8hswZ9XOR4Ln1usBS7RFyoiW/DmxCkripN7cYi+sNk+MFHhUl7sTDqCkd+75Ej5umjq+uq33xTAsltcWPaA3e13u1W/Czf3aurU9g8JaDslZlVikM/6yU5fxtz3RaO1ViVOQXKZTjKs+LmgofKkX5YPmpNHC80Rpidczgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNetA8ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNetA8ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2493FC4CEE3;
	Tue, 29 Apr 2025 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947169;
	bh=Nx2FiEI32+ee4sDl+1QgFsbTHg/KmwtiZAHuZTRuKxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNetA8ZKAAFZOgA6XPYw3o5te7GKYY37ekkLij+UsSGOhTPKEXJGUExf+PlTXw+Cc
	 ToT8yKe+445qySiuVoAj60y1smN1B/MMBGsp2x5bTpBV2uxOEFmPc5Jg16ZQuWZXrl
	 icD00YestcBBX0aeJm1lBXHaNwIonLgU1Rmycbbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 165/286] smb: client: fix potential UAF in cifs_stats_proc_show()
Date: Tue, 29 Apr 2025 18:41:09 +0200
Message-ID: <20250429161114.672633121@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 0865ffefea197b437ba78b5dd8d8e256253efd65 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ cifs_debug.c was moved from fs/cifs to fs/smb/client since
  38c8a9a52082 ("smb: move client and server files to common directory fs/smb").
  The cifs_ses_exiting() was introduced to cifs_debug.c since
  ca545b7f0823 ("smb: client: fix potential UAF in cifs_debug_files_proc_show()")
  which has been sent to upstream already. ]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -595,6 +595,8 @@ static int cifs_stats_proc_show(struct s
 		list_for_each(tmp2, &server->smb_ses_list) {
 			ses = list_entry(tmp2, struct cifs_ses,
 					 smb_ses_list);
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp3, &ses->tcon_list) {
 				tcon = list_entry(tmp3,
 						  struct cifs_tcon,


