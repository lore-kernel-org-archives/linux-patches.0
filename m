Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CFC15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DB1C433C1;
	Tue,  8 Nov 2022 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916366;
	bh=ZCg15C5V/EsyDptHy/1mzEKrJ/OKpxRTZ73ERj4aWpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXQZ68SkVCG11FExn4Keo7VE9Cy2PhPBdoNvotmVYz0XudEUtmqVDVH7owbC4HxM/
	 EAXh721hD8xjeJ4tUWodR3feFCkWOUbvnvvM0fa3UT5zG/etKf0qa0O/lRIjFxACTI
	 JKFGfnpuoFg1dv8pxSTDltspaJtjS4XN4Pa9CYZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 113/144] fuse: add file_modified() to fallocate
Date: Tue,  8 Nov 2022 14:39:50 +0100
Message-Id: <20221108133350.081314621@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

commit 4a6f278d4827b59ba26ceae0ff4529ee826aa258 upstream.

Add missing file_modified() call to fuse_file_fallocate().  Without this
fallocate on fuse failed to clear privileges.

Fixes: 05ba1f082300 ("fuse: add FALLOCATE operation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2975,6 +2975,10 @@ static long fuse_file_fallocate(struct f
 			goto out;
 	}
 
+	err = file_modified(file);
+	if (err)
+		goto out;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 


