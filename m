Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9301E1041;
	Wed, 19 Feb 2025 09:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956631; cv=none; b=gKIuwDMwYi0b9NwAzH5YeqOGAX1cvXJn3CYqAagsGQmTfHnUKa6LSLek/QBOK0l57PnX/QCZG4FMiJZegpuvausmoFBxG/zU+XxYY16YzNgV+Eva/JX6td9yPJwW+13j+PGP7kMCKoyDFrjVkveUGh7DIagzt+0UORn0efBF0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956631; c=relaxed/simple;
	bh=BXJT0lKePGJ+duA/s7DdlIaOVFzTYQYny0lO5i1eDYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM7EmNqtoO3NL5sQU9OVf2jUvCwsHejxX+VgVkPum8Tj36DLVSz0mkREB+ZwoUmzIy5GpFQjlrsQiQIT71IfYKUj1GhmGMzb7FAHZw/fL29oi7xog1m+wh6h73L25RDpi73t4BnE1evhvk6NlJ0uN5KlJBAN+AWc7T8TlTpephY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPtxmoSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPtxmoSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA1AC4CED1;
	Wed, 19 Feb 2025 09:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956631;
	bh=BXJT0lKePGJ+duA/s7DdlIaOVFzTYQYny0lO5i1eDYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPtxmoSzzGN6DVG7td5A6q0MaFxeEKHIOUWm3lNJ7MPUD/Iz7DFudg6iYWcfSOND0
	 PNi4ZFQ2WBjuPOUvWOs4Hn1Z5He4GBgk4NuLYqrUP7Ia5GKSBAbdapaoj0NS01Haf4
	 jMl9rB9rFWnpJ8ej37ORTnB5gWYATcJTh09wzx/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 244/578] NFSD: Reset cb_seq_status after NFS4ERR_DELAY
Date: Wed, 19 Feb 2025 09:24:08 +0100
Message-ID: <20250219082702.633109310@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 961b4b5e86bf56a2e4b567f81682defa5cba957e upstream.

I noticed that once an NFSv4.1 callback operation gets a
NFS4ERR_DELAY status on CB_SEQUENCE and then the connection is lost,
the callback client loops, resending it indefinitely.

The switch arm in nfsd4_cb_sequence_done() that handles
NFS4ERR_DELAY uses rpc_restart_call() to rearm the RPC state machine
for the retransmit, but that path does not call the rpc_prepare_call
callback again. Thus cb_seq_status is set to -10008 by the first
NFS4ERR_DELAY result, but is never set back to 1 for the retransmits.

nfsd4_cb_sequence_done() thinks it's getting nothing but a
long series of CB_SEQUENCE NFS4ERR_DELAY replies.

Fixes: 7ba6cad6c88f ("nfsd: New helper nfsd4_cb_sequence_done() for processing more cb errors")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1202,6 +1202,7 @@ static bool nfsd4_cb_sequence_done(struc
 		ret = false;
 		break;
 	case -NFS4ERR_DELAY:
+		cb->cb_seq_status = 1;
 		if (!rpc_restart_call(task))
 			goto out;
 


