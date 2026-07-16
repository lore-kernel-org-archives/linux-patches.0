Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED7C22301;
	Thu, 16 Jul 2026 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210278; cv=none; b=Rs/slXsPZ/Y4VS07du+CmoTFVgDejeWLMMXudnT6lsrd0cRw1SUegtbCJwKDK26/U2VNBOq0cEK5Sy8ikZyn9AtvIHq3tZ3KBEZvd5GfqNd0dqRikO+k3dEVb+c7r0TllYmg9SBKTlRqU+IPOvnNP5pkXw5QwXbS0/nR1u6+iEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210278; c=relaxed/simple;
	bh=aPJbYBrkrLag62ifjZd1RiKCtrHUAKbG6E4OHVJ1KAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwYqSexpkMJLnB3IEXOoc3nk1kb9m0Ah4V10mMT4XvJTRvOkhGkWIzhRc6QSkN/YhUXSpjPp/dcxOVis1lL4np3VA/RmS+5G0t3mVg+HamrKnMW7U+TUaUeokl8KgqmM+HoHL+WWi2E3jr2dv08tzFWLKmVKGyJY0eWNcXC9tXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhWCM565; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhWCM565"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CEB1F000E9;
	Thu, 16 Jul 2026 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210277;
	bh=MzATjpfcz8F7yPXqY01WudthUp+805eknYPmjM/kQ+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhWCM565D9zT/1zjrlUl50LUIdi3asZT1dJndff1//1mh/ptbOn/xAurMNgUyaddR
	 jHna7ruL/BKEBu0U+pnMa4xKS9OSpnrqEyAmJ04Ej6njBuM8QTIlUcR3z0sounYM2Z
	 naObAr1yo1LuoHwQE4lqor8rRR7c9EiC4mNu5Ic0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 506/518] fuse: dont block in fuse_get_dev() for non-sync_init case
Date: Thu, 16 Jul 2026 15:32:54 +0200
Message-ID: <20260716133058.912267404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit 9f6f44aa5a58aaae0838126dc09460c3e1f56ccb upstream.

Commit a8dd5f1b73bc ("fuse: create fuse_dev on /dev/fuse open instead of
mount") changed behavior so that fuse_get_dev() now unconditionally
blocks waiting for a connection, even in the case where sync_init was
not set. Previously, non-sync_init opens returned -EPERM immediately.

Restore the previous behavior of returning -EPERM.

Fixes: a8dd5f1b73bc ("fuse: create fuse_dev on /dev/fuse open instead of mount")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/3c9f8396-41f4-4c88-b883-34bede72b427@sirena.org.uk/
Cc: <stable@vger.kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Tested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1560,9 +1560,15 @@ struct fuse_dev *fuse_get_dev(struct fil
 	struct fuse_dev *fud = fuse_file_to_fud(file);
 	int err;
 
-	err = wait_event_interruptible(fuse_dev_waitq, fuse_dev_fc_get(fud) != NULL);
-	if (err)
-		return ERR_PTR(err);
+	if (unlikely(!fuse_dev_fc_get(fud))) {
+		/* only block waiting for mount if sync init was requested */
+		if (!fud->sync_init)
+			return ERR_PTR(-EPERM);
+
+		err = wait_event_interruptible(fuse_dev_waitq, fuse_dev_fc_get(fud) != NULL);
+		if (err)
+			return ERR_PTR(err);
+	}
 
 	return fud;
 }


