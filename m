Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E95425EF86;
	Tue, 11 Mar 2025 15:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705637; cv=none; b=gcvNmNypEjwKDY+sJIH+YlKqjaKYqT35+V4D/XZ/S9lTt0p3oPYTLB6o5mwMo2CrvDcqFMwhszvvC3HMv/u+9ex0ZcaECUn7e8IKO3QsgoAy/ORt0gs4AW++xWW3BVQA0vdjcM1viUJzVVtTlcmo/v5H4Ps9T9ww8pp9qIJyaWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705637; c=relaxed/simple;
	bh=3a1MAcr/HMmTJ1NylvV1h3SU8QDlEUFzqZg+RvO11p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4f/5pGnsRHsvOqt0EUJBPX+K972aDv/MNh00VOGZ4lFeShlJo/QJqqybK16kQa4/KMcq4hBi6a2wVsgGso46ZKaTSPn9wz4/yKmaCyU1LKIlmoIGXEkRA/mx+94UJOqosLLrLLjo21tqhSiWcCKem4iQUjIOcXT5ZghT0dRE3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXHF5W+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXHF5W+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F89C4CEE9;
	Tue, 11 Mar 2025 15:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705637;
	bh=3a1MAcr/HMmTJ1NylvV1h3SU8QDlEUFzqZg+RvO11p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXHF5W+zbk5mVB1oGSRxigN1wZLjqMls4dp23IW9Sf2dbqoLBPNvZg+fDttE+Trfl
	 zYlH/O9JVYn6qu8eIj/tgv5GMDSF89US6GVLph9Wo6IpVFndXT4aIj4vLix7a55lAo
	 +v693LuMZApMx5VWmAILvLLWG+DWCmPzS1SdqpZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 075/328] NFSD: Reset cb_seq_status after NFS4ERR_DELAY
Date: Tue, 11 Mar 2025 15:57:25 +0100
Message-ID: <20250311145717.872417163@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1060,6 +1060,7 @@ static bool nfsd4_cb_sequence_done(struc
 		ret = false;
 		break;
 	case -NFS4ERR_DELAY:
+		cb->cb_seq_status = 1;
 		if (!rpc_restart_call(task))
 			goto out;
 


