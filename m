Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C29F28EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC37C433EF;
	Mon,  2 Jan 2023 11:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658943;
	bh=brgNw/t9C+5VCrcvkooNJ83yLfbdV95Y/k4DoRWcK6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2stFDLTim5KDOVtJ/8p3VlQUnTIN718QGCKHQkMH1nnvunzP8HUw8NsWNuHYptfUF
	 Gw0vWjBvgZDRVwfmAYctlBT9WFLZv1MDJw8aDczjSe4lGZFRSIGkpvgtXOYF4XaNEj
	 1n9pJ61aFfeDrL+rOHSreDmuS7Anf2fAmyfdr7tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Labastie <pierre.labastie@neuf.fr>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.0 58/74] ovl: update ->f_iocb_flags when ovl_change_flags() modifies ->f_flags
Date: Mon,  2 Jan 2023 12:22:31 +0100
Message-Id: <20230102110554.574408722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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
 fs/overlayfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a1a22f58ba18..dd688a842b0b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -96,6 +96,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 
 	spin_lock(&file->f_lock);
 	file->f_flags = (file->f_flags & ~OVL_SETFL_MASK) | flags;
+	file->f_iocb_flags = iocb_flags(file);
 	spin_unlock(&file->f_lock);
 
 	return 0;
-- 
2.39.0



