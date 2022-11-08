Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0217B15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F06C433C1;
	Tue,  8 Nov 2022 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916831;
	bh=1q2EdipwbvnHYYNkZDjrj0aPWHGSstZNU6IUadB6Nzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsbjWS0wgJRYdklbzYUCywthzYppnfOIFs2OT/fjNwqK001g73dwdxLHMAdajWIoH
	 v6j6Mg5/8s/cgVDQZZz+LTyRemRnFBvb+J7n87hGhLHf8H4UD1oNHCxxfCMVGhhWzy
	 1D8ryRs/NoF7RR1iEf13LwXEMgW5ZqRoT6ncQ5yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.0 147/197] fuse: add file_modified() to fallocate
Date: Tue,  8 Nov 2022 14:39:45 +0100
Message-Id: <20221108133401.640997850@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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
@@ -3001,6 +3001,10 @@ static long fuse_file_fallocate(struct f
 			goto out;
 	}
 
+	err = file_modified(file);
+	if (err)
+		goto out;
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 


