Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA882252914;
	Tue, 29 Apr 2025 17:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949148; cv=none; b=TMVOI7xAb4C7PRWw9GgGSQw8coHydkTVBgf97mYbUYg9/vVUG7jImOyg3xNijHIcGttlW7xkESNqt2NSb6jfWDuzzy6MhbRwajqzO2FwtLTIdSOE6lvHGYKt6jOBejjLzctooEq5yGWxhZDUGZZx3yb68JJVXT89RT3CS/Te024=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949148; c=relaxed/simple;
	bh=phrDytaEYvP53PjBiC0kavcxSh/eyVZDEw2lPicEds0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9sgDfolX3aUA8dpr045pyHmFxLow3wjWDun90REBRvtFUyA+9Rn0qdc3YM3O1ij4YK4BCDeyK8eLXSkL/hDimpZhGqesPwhCUH308oiCydjvPBr9XF0oGtI6UoAWmH7spyLNdh7eDEP0D0tIV5GE+ID5gospX3/Ye1ge/gqcKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2p+B3agu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2p+B3agu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1237DC4CEE3;
	Tue, 29 Apr 2025 17:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949147;
	bh=phrDytaEYvP53PjBiC0kavcxSh/eyVZDEw2lPicEds0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p+B3aguH/DwFplS/pG1CDjly8aRdzH+/QRO/HdJtqvX+DZdnVHT/tapyAta0n9LW
	 yk1xiTNGAyBKf2dX4TclaML0UHtW2HR9DEfj/Zq9QzwDT+dqQNE9liDs8FmODfkVui
	 kSO9N1OVc5O1UTuJsTKj5PTuWjqpk8DoZTtlWHJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 228/373] smb: client: fix potential UAF in cifs_stats_proc_show()
Date: Tue, 29 Apr 2025 18:41:45 +0200
Message-ID: <20250429161132.524396507@linuxfoundation.org>
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
@@ -613,6 +613,8 @@ static int cifs_stats_proc_show(struct s
 		list_for_each(tmp2, &server->smb_ses_list) {
 			ses = list_entry(tmp2, struct cifs_ses,
 					 smb_ses_list);
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each(tmp3, &ses->tcon_list) {
 				tcon = list_entry(tmp3,
 						  struct cifs_tcon,


