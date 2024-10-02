Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2C81D1E62;
	Wed,  2 Oct 2024 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878758; cv=none; b=GVz1WCTZBqMJMjYxQBq8MyBbLZW54w5MsPNPlVp+kTLQWummSSolit3nJ921Hr/adUYgAxAA4TlaGZRKFK2pXBGTC4POxFbkJ14FLVzzJulueSGa311S1NO3ByomwudC3sZY/tXC4Tb1KgIwtS9rGbHHg0F/zoCGdtFvFXIT7x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878758; c=relaxed/simple;
	bh=hmGITG4570EPbruURs957Zzzr7RHLDQj7eR93g1g4pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCrAh6GWr6KiLOWIUx6pPHrZ/2zanbxurvuSNudtDIdw2UoCEU8RjyyvRn+DQTvZunZlFP4QBzgLnaG1qLWX6q05QncRlC1kpNYPIt+nyziMDSlBVICPSPxOOP6VCDZ1pxami7mlURFZ73FIPasb+e7uH27RR6YSQ1a4B0Khx5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tFWrXww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tFWrXww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD146C4CEC2;
	Wed,  2 Oct 2024 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878758;
	bh=hmGITG4570EPbruURs957Zzzr7RHLDQj7eR93g1g4pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tFWrXwwHodsgamrnyJQZ4bH34I5CDH3D+1W+y8jgpzjIxiks8oEpyP5BkOtVTi67
	 MiwMhyL9vbJFbQJ+3BeKOzmQjr2kUsOZtLVgSa17QYLBc67RkJLzW/qBw71d8EqmBj
	 IgWw8klZLdBvMUyTQlOyF6sCXhOe2vxOd0G2zcTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 505/634] ksmbd: allow write with FILE_APPEND_DATA
Date: Wed,  2 Oct 2024 15:00:05 +0200
Message-ID: <20241002125831.035907754@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 2fb9b5dc80cabcee636a6ccd020740dd925b4580 upstream.

Windows client write with FILE_APPEND_DATA when using git.
ksmbd should allow write it with this flags.

Z:\test>git commit -m "test"
fatal: cannot update the ref 'HEAD': unable to append to
 '.git/logs/HEAD': Bad file descriptor

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -496,7 +496,7 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 	int err = 0;
 
 	if (work->conn->connection_type) {
-		if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
+		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;


