Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208238;
	b=sihC9f3wfLeiVhcdmDr0QbbM+a8h5qq9qScWDttZZYz1SPkwOw+PuVSDrMLOL5MaB2RD
	 //nxVF8nAbweUk6gFTqMHLoBD9gukVEF7s6WJDRfB2IfgU7PndiK/nmMaGyjRC9bX8Q5S
	 M/465tCiQYuvZnsBvzQ5FhevYQNOUFM8xF4sk1Y8RJOxfySL3/SHwQsApPxBGWx3HSB4L
	 LB3oWNehCKwo6j/AG6j4QJXmra5r3wKwODW+Z8Lln5QlpdODL4zofeTk/ZwfZ5V2/1PfW
	 HcjHXKXGC8aJG8pA+LCxWfoS9H1/cy1VRhGMHP20+qqvYWGcJGoy/Bp5e5nfkcg1YNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u0Oqs2LJSpy9uIEOOrCASJ0yvSIQ3686TXZ6jm3RhUg=;
	b=EgAql/K152aXNfYhSlgfh4YjTtuNS1RWoIe9IAIq5ThSLkOxQxrXUm6x7spJVDOXtr8q
	 yO1780IOq7lAJMLFxEXeaWm5nQdUfk387QhISBSSoMgYt+5kZXSa1wtzRlpwlaAiN35Vh
	 QDe5GO02GFHUXeYXCUXYdMFwpkxG2NkHExFih52S+c2Cx1AZJroozmTMlqCWI7gWANDe3
	 4PHQPZB4VJyJU/yMqCT6KiBnS7y1YNHbhqcb2CdonvA+Dz8Kg5+fT+N2fF7PmZbcx0DD0
	 rSK2U2+DH1PZwBxXRr92qNvNZP3AiFBLQ6uomZkSUtF64Bztv1XINsSwgl7UDCWrF0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1d2bjlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A1606A31C;
	Wed, 28 Oct 2026 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1d2bjlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217E11F01825;
	Wed, 28 Oct 2026 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208237;
	bh=u0Oqs2LJSpy9uIEOOrCASJ0yvSIQ3686TXZ6jm3RhUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1d2bjlM9EOS+4nk7+UHwBemSvFyooaRn38cj5OToJbAd8yXowOu2tR/vEdPes1Lu
	 N0okrLGYVI+XeNwZEZ5VPJiDOorgNWC/r6qjIET+GvrTL6jrNlwt6s24YJ1J+Tysys
	 rzMX1Tym//I0iF8/O9BmkCN5AAfsNgarqHuZ2O3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/516] nfsd: release path refs on follow_down() error
Date: Wed, 28 Oct 2026 17:53:19 +0100
Message-ID: <20261028170004.647308083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit 6cba08dc1922140d260cfeb30bbda4ee1bf869d8 ]

nfsd_cross_mnt() initializes a local struct path with mntget() and
dget() before calling follow_down(). On a negative return the error
arm jumps to out without releasing those references:

    err = follow_down(&path, follow_flags);
    if (err < 0)
            goto out;

follow_down() never drops the caller's entry-time refs on any error
sub-case; for example a pre-cross d_manage() failure leaves path
untouched, so the mntget()/dget() taken on entry survive the call.

Every other early-exit arm in nfsd_cross_mnt() (other-namespace
return, IS_ERR(exp2), and the success tail after the swap) already
calls path_put(&path); the err < 0 arm is the lone omission. The
leak inflates mnt_count and d_count on each failed cross-mount,
blocking umount and pinning dentries against the shrinker, and is
reachable by any authenticated NFS client through nfsd_lookup_dentry
or the NFSv4 READDIR encode path.

Fix by calling path_put(&path) before the goto out in the err < 0
arm so the entry-time refs are released on all follow_down() error
returns.

Fixes: cc53ce53c869 ("Add a dentry op to allow processes to be held during pathwalk transit")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-2-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ retained the older single-argument follow_down(&path) API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c8eebd03784a2..7aa2338539af9 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -129,8 +129,10 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 	int err = 0;
 
 	err = follow_down(&path);
-	if (err < 0)
+	if (err < 0) {
+		path_put(&path);
 		goto out;
+	}
 	if (path.mnt == exp->ex_path.mnt && path.dentry == dentry &&
 	    nfsd_mountpoint(dentry, exp) == 2) {
 		/* This is only a mountpoint in some other namespace */
-- 
2.53.0



