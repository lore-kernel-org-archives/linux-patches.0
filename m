Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA972C87B;
	Fri, 24 Nov 2023 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lb7EXLQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9B0C433C8;
	Fri, 24 Nov 2023 19:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853703;
	bh=3SDCDEI9fF9zQquteMXfZAoxBvlxQyKZHzt9wtlSkvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lb7EXLQSnHeWlKd5sRvjkNU5zVyFp4tr6mNWrX+5Vb37AOX5QsCwaAZRjtOEG4bqB
	 HE4LD0scNfSlGtIBCmUy+i7lnk4mgrceHL0dgY24dJcqmG4ZFVt6wX9Kfz+vJKF06P
	 BlewEozusM/0mrfWiE2Pn5O41T1KIl1KapaSUGc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahmoud Adam <mngyadam@amazon.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 270/297] nfsd: fix file memleak on client_opens_release
Date: Fri, 24 Nov 2023 17:55:12 +0000
Message-ID: <20231124172009.593661662@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahmoud Adam <mngyadam@amazon.com>

commit bc1b5acb40201a0746d68a7d7cfc141899937f4f upstream.

seq_release should be called to free the allocated seq_file

Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: 78599c42ae3c ("nfsd4: add file to display list of client's opens")
Reviewed-by: NeilBrown <neilb@suse.de>
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2686,7 +2686,7 @@ static int client_opens_release(struct i
 
 	/* XXX: alternatively, we could get/drop in seq start/stop */
 	drop_client(clp);
-	return 0;
+	return seq_release(inode, file);
 }
 
 static const struct file_operations client_states_fops = {


