Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E643438BE;
	Sat, 12 Sep 2026 19:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240955; cv=none; b=LK+zSsd6vJUUgUWsWqmJE3lrKo5UDvStvPMMXTzM6vs8C0Z03bWp0vLOpJqhjwycx6NfM0mvayTP1qX/WkweX2aXQXNH5VtYwNEb8SzVpqd36HbxdN1S24gfCT5TY18yOYwVuR1R0Q1oyY+I8UtTlZMJ2I211vDgBNDfKk//+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240955; c=relaxed/simple;
	bh=h8d/Nyy+ySYTUiKkLOzEzl9NhRfZ74kP7A5GlVeVbak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdeQUENcaCy0KGD0biq079IUhVvQuDssggmvRKlIRCkHjEynrOFVmES4EA6BYDxGQjJwvJXj27qsFzBKwcNv8bSGzBZqAzRoMdh2kkVVJLrs6HjQeqdTDh7qVIab7MUTls4GS9QjCeOj7kCgraQvZOaxOSjI9M6N02zfq/9Qq/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHKudp9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHKudp9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82461F000FF;
	Sat, 12 Sep 2026 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240954;
	bh=2PABVKQVHfhdVhTAYa7B3vd5BQk/IOwYzOS1HeTkx10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHKudp9HFxt3FRgBCVa1Jp+bOr9mc0IhM0QfB/PDyN6Pdno7sJ8eG9uzkQAY+pvgz
	 5YdPV9id35NZgiuQVov/7eV1CUNsjH09fC/BooFjWXlpSka5JWpC7NrutI+dIoS2vd
	 qFR4gVdPtQHkO167oDyN2oY1trde9ti5bR0J4bWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 037/798] nfsd: add filehandle match check to nfsd4_delegreturn()
Date: Sat, 12 Sep 2026 08:54:25 +0200
Message-ID: <20260912065517.813131304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 04cce9d79f2b1a114f7128e08bf60a473e10f1ec upstream.

nfsd4_delegreturn() is the only stateful NFSv4 operation that does
not call nfs4_check_fh() to verify the delegation's file matches
cstate->current_fh. A client can DELEGRETURN with a mismatched
filehandle, destroying the correct delegation but waking the wrong
inode's waiters.

Add the missing nfs4_check_fh() call after the generation check.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-6-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7128,6 +7128,10 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	status = nfs4_check_fh(&cstate->current_fh, &dp->dl_stid);
+	if (status)
+		goto put_stateid;
+
 	trace_nfsd_deleg_return(stateid);
 	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);


