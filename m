Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7EF28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8477C433D2;
	Mon, 30 Jan 2023 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087475;
	bh=hTS3lQSOY68LpKdHYpmHG4oaVQoUrNo+8qwtmiInaOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3Gw5c3foishmE06BOO5e7tFaoXTeZEmjWrF7o3Tg6zRk43k/Bb4EJ5raJp+mTPX4
	 /StP93lLOhgfhl74t8+3b+s632UXD9eZhvXSasdj9EtBhyl9glAdPl44xmDt6EBKID
	 5STANquTBmGNE/JzYXSh4+LhvZ9ZZ8sz5Ew5ZV/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd749a7ea127a84e0ffd@syzkaller.appspotmail.com,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 220/313] ovl: fix tmpfile leak
Date: Mon, 30 Jan 2023 14:50:55 +0100
Message-Id: <20230130134346.956896874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miklos Szeredi <mszeredi@redhat.com>

commit baabaa505563362b71f2637aedd7b807d270656c upstream.

Missed an error cleanup.

Reported-by: syzbot+fd749a7ea127a84e0ffd@syzkaller.appspotmail.com
Fixes: 2b1a77461f16 ("ovl: use vfs_tmpfile_open() helper")
Cc: <stable@vger.kernel.org> # v6.1
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -754,7 +754,7 @@ static int ovl_copy_up_tmpfile(struct ov
 	if (!c->metacopy && c->stat.size) {
 		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size);
 		if (err)
-			return err;
+			goto out_fput;
 	}
 
 	err = ovl_copy_up_metadata(c, temp);


