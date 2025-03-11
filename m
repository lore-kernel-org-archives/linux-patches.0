Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196C825DD08;
	Tue, 11 Mar 2025 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706731; cv=none; b=T+tx9/kPpWfvf8X31yuhGkJhLhXdBtdSip7t0JYjwqgJNKnQ6tIu7Ww5xlVve8UFe51UIyn4h/8GM9Wbwone/Q8jwJkqetcJOBcgxfSpfuyeHn6bYu3fZtIkgNNAuNZ4GHi9xQke6zP8UtUhcoo1qhw1DxkNnQIavI8EiHsouEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706731; c=relaxed/simple;
	bh=X12N2x4MczGfoQ5i7tWiPQQijuOO3C9mvOAklRIR3Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVCep964/MQ6fFLhp1Sq9jycFkJBrnokSLrHSqHDPXQO95Mbc0rcc+SG+LJvWGoimy0ti5HEM6yTWVKTxJS3BvI5NAFxnYM20PA22E4h+veSAsWBlQhPYIFRSgHhSktSKhb8aklnILRnDGD/0ByN5j0tjPbfR/Yn2DL1iZNmMk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELFBbuXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELFBbuXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2121FC4CEEC;
	Tue, 11 Mar 2025 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706730;
	bh=X12N2x4MczGfoQ5i7tWiPQQijuOO3C9mvOAklRIR3Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELFBbuXYi4yaDqyIOt6KUKwxzN+sxBleKPIw1N3/V7FiQx3S04ilqDXBBl4z+RmRR
	 Vk1gwfdMsuqOw90uiR7ySpTr0Wp8LZaSfpKqUc4S+IcHPJJPI++nfGrrUR1bjb7T90
	 afs8b4T+CkezctiNACCciBkWVcDxzTLIHM79fjZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 116/462] NFSD: Reset cb_seq_status after NFS4ERR_DELAY
Date: Tue, 11 Mar 2025 15:56:22 +0100
Message-ID: <20250311145802.945080637@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


