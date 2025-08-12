Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063D8217F35;
	Tue, 12 Aug 2025 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026800; cv=none; b=ME9joxMmK3V0dxX7iaQaYf/HAQVl06Bdh+QubGbJRHu5U0ZD75LxmJntvohyBjUlvgB4yfXuAIt8rk2o2pfBamrDo8Kp2LGnSJ8Ae5iZN5u6pvQg/Ji5N0y9JExOwiZ6wmYuDscSAmbtSKLWF+zeVEswsNIC4nfd3jnXnjHw/s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026800; c=relaxed/simple;
	bh=2py0gSPKoWKURHj+lc7hHOVTGYKqFpjx0L7F4Gi6vRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5zOnQUUKgqA1tSDMT880rr5wu1k3CYAWOMVarriXDraHMATz48WKk1GFFpsSU+pAjr3DFxzGnS8xPlqnLTm5f08usvWGl8SOQEi81zJwsJVngY7XCG2elNH3G6z2+qXu+JKTcudGZyex3RBYe3GijzrbxDU+BHHEpFmEAgUdBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nONwGVj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nONwGVj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5EBC4CEF0;
	Tue, 12 Aug 2025 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026799;
	bh=2py0gSPKoWKURHj+lc7hHOVTGYKqFpjx0L7F4Gi6vRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nONwGVj+jKjmGSwX+RYYgM3JGKvJL+8eF/mZKwYTXqC7yRJaYLFnhnYu/pNlmJMr3
	 KMEYnaXeQ8vQ6A/BYbIpeWQfQ/riXHlZrr7UDFRbHpncLX/no1FPchYeizf2vyQ1kZ
	 b29LCNYzPA8R5c+5mOsVptwhiyj/X/mqaYaT8GZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.15 445/480] ksmbd: fix Preauh_HashValue race condition
Date: Tue, 12 Aug 2025 19:50:53 +0200
Message-ID: <20250812174415.745755935@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 44a3059c4c8cc635a1fb2afd692d0730ca1ba4b6 upstream.

If client send multiple session setup requests to ksmbd,
Preauh_HashValue race condition could happen.
There is no need to free sess->Preauh_HashValue at session setup phase.
It can be freed together with session at connection termination phase.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-27661
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1847,8 +1847,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 				ksmbd_conn_set_good(conn);
 				sess->state = SMB2_SESSION_VALID;
 			}
-			kfree(sess->Preauth_HashValue);
-			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			if (negblob->MessageType == NtLmNegotiate) {
 				rc = ntlm_negotiate(work, negblob, negblob_len, rsp);
@@ -1875,8 +1873,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 						kfree(preauth_sess);
 					}
 				}
-				kfree(sess->Preauth_HashValue);
-				sess->Preauth_HashValue = NULL;
 			} else {
 				pr_info_ratelimited("Unknown NTLMSSP message type : 0x%x\n",
 						le32_to_cpu(negblob->MessageType));


