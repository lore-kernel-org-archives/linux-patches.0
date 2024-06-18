Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FEF13AA44;
	Tue, 18 Jun 2024 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716722; cv=none; b=jJYdGT8y5OpPTRRPqHZry9s1A0IrHA0wnqFmBFSZw9oA/U6Kll4Omj3+3o/f0+wXewlroZVC4b6avXQ5i2MC2WFPxDd1/fBJfrHQ2lnXkSPT6DzLrGhDNZWYYu9mlq5vfa4b1o+Ya3rT6gtBLK4f/18TZTgU6fzutbBNww4VQgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716722; c=relaxed/simple;
	bh=8ZT0IuMndMCe5Bq/y1wmEfNWndZGUkLVz90SNDEqyWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiZhhwYerjgeHyfH+HXFQBNbzRwrC6O7COZJN7y+a04Srv29dkou41boktMqWmr3ysoN2045wYkXstlBt1ARn8OaBQ0zRzb+E0UrWBW7aec3Oe3mUeyz3yJkxIv5uxJdhTNkt2RfTdMmWYdga70r/t1j9zMS7WRW6+fql/z9Drs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1iMfQl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1iMfQl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B7EC3277B;
	Tue, 18 Jun 2024 13:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716721;
	bh=8ZT0IuMndMCe5Bq/y1wmEfNWndZGUkLVz90SNDEqyWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1iMfQl7leqT1dNIhwq5fMzX+2oiL4hKSSCDX/Eq96tPocbjuuISvS9TD94V8GTRg
	 Ybq7fxSQfAUxTIRe7FDlUXmGbj3pznwFjcFXvQOuWfsxLx+es1pu6u47QRkX40N9Iw
	 WdlvwGP4qqLx7yFtObEa2sNJeIgPSN4acAveyDhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 740/770] lockd: set file_lock start and end when decoding nlm4 testargs
Date: Tue, 18 Jun 2024 14:39:53 +0200
Message-ID: <20240618123435.831862481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7ff84910c66c9144cc0de9d9deed9fb84c03aff0 ]

Commit 6930bcbfb6ce dropped the setting of the file_lock range when
decoding a nlm_lock off the wire. This causes the client side grant
callback to miss matching blocks and reject the lock, only to rerequest
it 30s later.

Add a helper function to set the file_lock range from the start and end
values that the protocol uses, and have the nlm_lock decoder call that to
set up the file_lock args properly.

Fixes: 6930bcbfb6ce ("lockd: detect and reject lock arguments that overflow")
Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org #6.0
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/clnt4xdr.c        |  9 +--------
 fs/lockd/xdr4.c            | 13 ++++++++++++-
 include/linux/lockd/xdr4.h |  1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/lockd/clnt4xdr.c b/fs/lockd/clnt4xdr.c
index 7df6324ccb8ab..8161667c976f8 100644
--- a/fs/lockd/clnt4xdr.c
+++ b/fs/lockd/clnt4xdr.c
@@ -261,7 +261,6 @@ static int decode_nlm4_holder(struct xdr_stream *xdr, struct nlm_res *result)
 	u32 exclusive;
 	int error;
 	__be32 *p;
-	s32 end;
 
 	memset(lock, 0, sizeof(*lock));
 	locks_init_lock(fl);
@@ -285,13 +284,7 @@ static int decode_nlm4_holder(struct xdr_stream *xdr, struct nlm_res *result)
 	fl->fl_type  = exclusive != 0 ? F_WRLCK : F_RDLCK;
 	p = xdr_decode_hyper(p, &l_offset);
 	xdr_decode_hyper(p, &l_len);
-	end = l_offset + l_len - 1;
-
-	fl->fl_start = (loff_t)l_offset;
-	if (l_len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = (loff_t)end;
+	nlm4svc_set_file_lock_range(fl, l_offset, l_len);
 	error = 0;
 out:
 	return error;
diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 712fdfeb8ef06..5fcbf30cd2759 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -33,6 +33,17 @@ loff_t_to_s64(loff_t offset)
 	return res;
 }
 
+void nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len)
+{
+	s64 end = off + len - 1;
+
+	fl->fl_start = off;
+	if (len == 0 || end < 0)
+		fl->fl_end = OFFSET_MAX;
+	else
+		fl->fl_end = end;
+}
+
 /*
  * NLM file handles are defined by specification to be a variable-length
  * XDR opaque no longer than 1024 bytes. However, this implementation
@@ -80,7 +91,7 @@ svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 	locks_init_lock(fl);
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;
-
+	nlm4svc_set_file_lock_range(fl, lock->lock_start, lock->lock_len);
 	return true;
 }
 
diff --git a/include/linux/lockd/xdr4.h b/include/linux/lockd/xdr4.h
index 9a6b55da8fd64..72831e35dca32 100644
--- a/include/linux/lockd/xdr4.h
+++ b/include/linux/lockd/xdr4.h
@@ -22,6 +22,7 @@
 #define	nlm4_fbig		cpu_to_be32(NLM_FBIG)
 #define	nlm4_failed		cpu_to_be32(NLM_FAILED)
 
+void	nlm4svc_set_file_lock_range(struct file_lock *fl, u64 off, u64 len);
 bool	nlm4svc_decode_void(struct svc_rqst *rqstp, struct xdr_stream *xdr);
 bool	nlm4svc_decode_testargs(struct svc_rqst *rqstp, struct xdr_stream *xdr);
 bool	nlm4svc_decode_lockargs(struct svc_rqst *rqstp, struct xdr_stream *xdr);
-- 
2.43.0



