Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A165F39E162;
	Sat, 30 May 2026 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160418; cv=none; b=Oa+buN5RiMcNNgD380fifJioVFSf+1Ia/PB36vVQV2mbCtjvHb9y1GSkMDZBYRXMMOX2g4q+fj6/ucMhC2zvBszU9s+sq1jDiZrAKZDotpJhNKnmnmk+ePt+B8wEZAPX7t/HXk8E23CuK5SFvzKiM5W3aGM8fxdAux9c7e6S0tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160418; c=relaxed/simple;
	bh=Fzpo25RDkGTVEphPYSfaIfGc0OtxSFJ8ImrZ9nrGhVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/SOVJTtyfBfnXkXVQ7dUNpMMIFJM2v9WIYRiB8k7eIaWx8Bo3WEYZV6/+NVCb4Swf1dBXDuk/w5nsS60Gg4KJb4ciHv+kuyKo+xRvWU7bfFVSe2+NmjVtUHohlI8AgeW9KiY2PiWHfZq0sFrJPILtztteVzQHM40KyDPIl5a7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1L1y3qH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1L1y3qH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB17A1F00893;
	Sat, 30 May 2026 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160417;
	bh=e0DR1lPHcmOPCza7rjlZ7tOasSZPD/evRjc7bcRBEhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1L1y3qHiU+Nyzwfx4liTPAXXiF8RkUcxon3t2GmooHUkBKbaKdnwlAITvB3Gkm3U
	 CfwGpNxsqg9TXlOvVKKIKY+pD20jweKJhUwatZU5YrE4PORuK02EXySzWjLkcbuaj2
	 X/stIe7Enrl7HsSQf3K17hy2ica09RW9WHZE2mi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 332/969] cifs: change_conf needs to be called for session setup
Date: Sat, 30 May 2026 17:57:36 +0200
Message-ID: <20260530160309.546679713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit c208a2b95811d6e1ebae65d0d2fc13f73707f8e7 upstream.

Today we skip calling change_conf for negotiates and session setup
requests. This can be a problem for mchan as the immediate next call
after session setup could be due to an I/O that is made on the
mount point. For single channel, this is not a problem as
there will be several calls after setting up session.

This change enforces calling change_conf when the total credits contain
enough for reservations for echoes and oplocks. We expect this to happen
during the last session setup response. This way, echoes and oplocks are
not disabled before the first request to the server. So if that first
request is an open, it does not need to disable requesting leases.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -94,10 +94,21 @@ smb2_add_credits(struct TCP_Server_Info
 					    add, server->in_flight);
 	}
 	server->in_flight--;
+
+	/*
+	 * Rebalance credits when an op drains in_flight. For session setup,
+	 * do this only when the total accumulated credits are high enough (>2)
+	 * so that a newly established secondary channel can reserve credits for
+	 * echoes and oplocks. We expect this to happen at the end of the final
+	 * session setup response.
+	 */
 	if (server->in_flight == 0 &&
 	   ((optype & CIFS_OP_MASK) != CIFS_NEG_OP) &&
 	   ((optype & CIFS_OP_MASK) != CIFS_SESS_OP))
 		rc = change_conf(server);
+	else if (server->in_flight == 0 &&
+		 ((optype & CIFS_OP_MASK) == CIFS_SESS_OP) && *val > 2)
+		rc = change_conf(server);
 	/*
 	 * Sometimes server returns 0 credits on oplock break ack - we need to
 	 * rebalance credits in this case.


