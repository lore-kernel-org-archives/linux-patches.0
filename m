Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1563A1C7;
	Mon,  8 Apr 2024 13:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584180; cv=none; b=fsI0P81yEJXQviCpBYA7A8cU6M8f2dIxqBOtg8snHoQbjdynMTJDh4Wwyxx4TBIBeXOGFpNljLtHD2n5AR/S/smAJa9XRFVGcrcSeXPEKE/vAD0fvGuBZRMT85bR/ED4/+hLkR7JysIoO47d1E93DxyvEEZZgjYwenMk8Ta/vHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584180; c=relaxed/simple;
	bh=k7WJTz9A1fSUvVn/SMzFKJrxEITI0uioaz8L+iRnBBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozxP1yRU8POaNAv18y9qzlTX5QRGG9FyBPNBvQeQ/INdtvLbOypC2R5eTzdby1kEpCzO05HUfeUj3SNES4wpyMzx90EOMR6XjvXO4GDJvB9YEIAqyNxf7H6yj2O2KIW+GKi6kpzMsjrVpNLHLZe3hO1WT59nBpvEJDzW+OebzIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+JIWJju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+JIWJju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30EFC433C7;
	Mon,  8 Apr 2024 13:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584180;
	bh=k7WJTz9A1fSUvVn/SMzFKJrxEITI0uioaz8L+iRnBBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+JIWJjub0Yw2m0QNSheqEYrz7i/8xq63PiLTPM8jUAGh5cWVFuBGVJXV2i4MkLdz
	 yHTleninn/fb+PQLNTpp2/FCMhMT4sDLqOKylXoK7Ylu2WtGVTk36ckIh54v45fYxr
	 CF6b1dtvtgKB8c4Lpi0RRrx9I5j/OWb4Rpd5vulk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 313/690] NFSD: Show state of courtesy client in client info
Date: Mon,  8 Apr 2024 14:52:59 +0200
Message-ID: <20240408125410.932789297@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit e9488d5ae13c0a72223c507e2508dc2ac66cad4f ]

Update client_info_show to show state of courtesy client
and seconds since last renew.

Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 447faa4348227..5bbf769b688bc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2494,10 +2494,17 @@ static int client_info_show(struct seq_file *m, void *v)
 	memcpy(&clid, &clp->cl_clientid, sizeof(clid));
 	seq_printf(m, "clientid: 0x%llx\n", clid);
 	seq_printf(m, "address: \"%pISpc\"\n", (struct sockaddr *)&clp->cl_addr);
-	if (test_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags))
+
+	if (clp->cl_state == NFSD4_COURTESY)
+		seq_puts(m, "status: courtesy\n");
+	else if (clp->cl_state == NFSD4_EXPIRABLE)
+		seq_puts(m, "status: expirable\n");
+	else if (test_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags))
 		seq_puts(m, "status: confirmed\n");
 	else
 		seq_puts(m, "status: unconfirmed\n");
+	seq_printf(m, "seconds from last renew: %lld\n",
+		ktime_get_boottime_seconds() - clp->cl_time);
 	seq_printf(m, "name: ");
 	seq_quote_mem(m, clp->cl_name.data, clp->cl_name.len);
 	seq_printf(m, "\nminor version: %d\n", clp->cl_minorversion);
-- 
2.43.0



