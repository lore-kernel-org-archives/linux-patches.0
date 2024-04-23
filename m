Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0AE1448D2;
	Tue, 23 Apr 2024 21:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908562; cv=none; b=Eo1r0MXD1GxsX6CRWquoIU4NZKPRfo/NMo3o4GET9RvnVYVoB80LA5eaOtSimKtuKuOOPZWivtqCy4TdrZBT2PhvW677fiN1BnPYFcMA+oTkyP+PyQWhBiipQjuiG/rGLSuz2HbpcUx/sj+dS+QA9a78nQggzUs7nkUNNNjWMm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908562; c=relaxed/simple;
	bh=DQgK7wldWxAfRx1TlHyJlFjsH9rWAfC39ntmwMmlRkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaMoeuKiQvmTxSSifYMugxdcKvYmJZCYtl6h1nSNZFB/XIpUZSJBQr3xql+9hXa9yk75vD0yKke1mMx8aJB83umUMwdq+IAyjcZFI1hq9GpnBRsDh8eeC9Iig3BqJbJYY9X2vZfnYLD2bhCj+O4EFpgdL8Ucq7JZ5QNHkhmJ1EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3q8WDKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3q8WDKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DB8C116B1;
	Tue, 23 Apr 2024 21:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908561;
	bh=DQgK7wldWxAfRx1TlHyJlFjsH9rWAfC39ntmwMmlRkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3q8WDKn2PbSu7BjTCklbfSkFC6v/ZAnkuR81Z8PZkRtYUZD17CkW+JqPBJPMBxF4
	 5bF0gBvFnahha8WZWMi44WTv7JNt/tC9h8vUtxQD8+kMtpIIMkrxL+KeSkLzVzWfCj
	 lIlrYjXXO4n9WDZ3P6HuAzEOQUvPayAmniFZ+740=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Lin <danny@orbstack.dev>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.8 139/158] fuse: fix leaked ENOSYS error on first statx call
Date: Tue, 23 Apr 2024 14:39:21 -0700
Message-ID: <20240423213900.388925529@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Lin <danny@orbstack.dev>

commit eb4b691b9115fae4c844f5941418335575cf667f upstream.

FUSE attempts to detect server support for statx by trying it once and
setting no_statx=1 if it fails with ENOSYS, but consider the following
scenario:

- Userspace (e.g. sh) calls stat() on a file
  * succeeds
- Userspace (e.g. lsd) calls statx(BTIME) on the same file
  - request_mask = STATX_BASIC_STATS | STATX_BTIME
  - first pass: sync=true due to differing cache_mask
  - statx fails and returns ENOSYS
  - set no_statx and retry
  - retry sets mask = STATX_BASIC_STATS
  - now mask == cache_mask; sync=false (time_before: still valid)
  - so we take the "else if (stat)" path
  - "err" is still ENOSYS from the failed statx call

Fix this by zeroing "err" before retrying the failed call.

Fixes: d3045530bdd2 ("fuse: implement statx")
Cc: stable@vger.kernel.org # v6.6
Signed-off-by: Danny Lin <danny@orbstack.dev>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1317,6 +1317,7 @@ retry:
 			err = fuse_do_statx(inode, file, stat);
 			if (err == -ENOSYS) {
 				fc->no_statx = 1;
+				err = 0;
 				goto retry;
 			}
 		} else {


