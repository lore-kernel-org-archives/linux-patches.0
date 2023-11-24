Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EF1364BA;
	Fri, 24 Nov 2023 18:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baRO7Re9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F4CC433C8;
	Fri, 24 Nov 2023 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851396;
	bh=66PgZqYwqgiF2o6zEYXOBPlG/3vnxfYBc6KlYiMBQq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baRO7Re9Pt8EngNfNhdHzebQ+3oTYrl8vgtU8DNz+LUZDW61Ly0xqNhn75qo6cjL+
	 /X/XgT3Lzj91vc6jzKHea2bmNb6zx9TA4rHF0lOYIoRlTCS0LsftUQ77h+tnjxXb1X
	 v33TcV2+dM+XAH8dRJxEwph/3CphaZH5/3y7Q9fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahmoud Adam <mngyadam@amazon.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.5 431/491] nfsd: fix file memleak on client_opens_release
Date: Fri, 24 Nov 2023 17:51:07 +0000
Message-ID: <20231124172037.566619277@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2785,7 +2785,7 @@ static int client_opens_release(struct i
 
 	/* XXX: alternatively, we could get/drop in seq start/stop */
 	drop_client(clp);
-	return 0;
+	return seq_release(inode, file);
 }
 
 static const struct file_operations client_states_fops = {


