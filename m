Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774A628EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1389C433D2;
	Mon,  2 Jan 2023 11:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658745;
	bh=nz3+Zk9eUFcCcp3wWYKpSm1I5sth4SC4NiBeKFn/qj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gS4E3RKUrt08o/9W+x5q9hfd3PeCL/CaEY86JKue/ipmfMrEmy6XZCMKIs1aTgHn6
	 EFwVfK0329X87EMYBtM9NDOLnCJb58/c47U2/IiddmkCMKaLnA04w5oUFw+vGjF69T
	 ganxH35E3oXPVDELoRIuRRajEXnEbHAJLCU3AhCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Labastie <pierre.labastie@neuf.fr>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 55/71] ovl: update ->f_iocb_flags when ovl_change_flags() modifies ->f_flags
Date: Mon,  2 Jan 2023 12:22:20 +0100
Message-Id: <20230102110553.803247392@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

commit 456b59e757b0c558df550764a4fd5ae6877e93f8 upstream.

ovl_change_flags() is an open-coded variant of fs/fcntl.c:setfl() and it
got missed by commit 164f4064ca81 ("keep iocb_flags() result cached in
struct file"); the same change applies there.

Reported-by: Pierre Labastie <pierre.labastie@neuf.fr>
Fixes: 164f4064ca81 ("keep iocb_flags() result cached in struct file")
Cc: <stable@vger.kernel.org> # v6.0
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216738
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -96,6 +96,7 @@ static int ovl_change_flags(struct file
 
 	spin_lock(&file->f_lock);
 	file->f_flags = (file->f_flags & ~OVL_SETFL_MASK) | flags;
+	file->f_iocb_flags = iocb_flags(file);
 	spin_unlock(&file->f_lock);
 
 	return 0;


