Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426FF18A6C0;
	Wed,  5 Feb 2025 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766500; cv=none; b=YVP4Cct3HC5VWRG0JZVjB1wgOunpAqJZA+tf9BnNFWfWDot+IMgbEEevrqc0DGJkL5lupi905GfJc/RQjrDD7kmn0bDL+8YtDlfguOsseI0NT1yqPG8VNimUWqXhRfOo2Vv4YJf1YdibwwyNpTNbr9GY2SU52WHw7I1uc9XrFKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766500; c=relaxed/simple;
	bh=cr8GE7iWznVx7A5SWeJMzuMIeSeWY7rpdbn2E1L52wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glqgEpJa/ZlS+DOEzi6/ukauRSDXJbsAq/kZn8Yfki5B7OZa8vxwJzDEthOk2QhTMEgbAAwjoa996BNi950pPcxQR4LKHzW97yP0CG/uqFFXli8rW8Jd38YypBNDMhc196rK2EMtJacRFiDd4+t1ew6OhXwL3bk1NvZBCcMzZzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIjsGFeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIjsGFeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BECC4CED6;
	Wed,  5 Feb 2025 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766500;
	bh=cr8GE7iWznVx7A5SWeJMzuMIeSeWY7rpdbn2E1L52wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIjsGFeGqzCmwvBbQOK+fG6IZR96c9PnolBWX2Q0m11gKEqmc6zQyQohB+wl29xxY
	 Qp6b5nHg5zkaSpduDZZg7xM0csF/BW+wqUx41v0eEgJtjlhmKejGAjvjNccV3EF8yM
	 G2tcvxN8WEQs8LdBetaQMJreFej4ZRqMOS3p//R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 368/393] NFSD: Reset cb_seq_status after NFS4ERR_DELAY
Date: Wed,  5 Feb 2025 14:44:47 +0100
Message-ID: <20250205134434.380593457@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


