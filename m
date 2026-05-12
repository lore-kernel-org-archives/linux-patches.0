Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B32C2EBB84;
	Tue, 12 May 2026 17:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607936; cv=none; b=P8v+oqi9eRmucTpo2/sug1fyqBBS8G28EsCRi6zIY5l6Mwb/rN5DfeOVynxHxUOeI6hxH/HmZBUvT2IQuZYKhw6HvKdn1bWWrrUMfHOe+abDXn5YwgNEyz+SPpbubpT3PXvhxzrHn9i3mQj3epIU5Ah5sdE57FZj1QgZeOO6Yz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607936; c=relaxed/simple;
	bh=U6N61Uiyn9ETmZD6VVTSLT81PaSeaXSgH67gQaeuOHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOzCJBNUPokj0I/ZS7LyppnmH2LxhWEf9ghINbjjLJShMqz26K0EkPNytKEFb6ocHSP/qE8RtjcrHksY5A9NSQp9EcL9nwLlFij9YN+iHSxp1Bt18Y7NWCKEXK9aQVGJh3jUZcBGy4bwE37zpFI78uQhl3jKsGojs31wi+pHfAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IT964E2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IT964E2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32012C2BCC7;
	Tue, 12 May 2026 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607936;
	bh=U6N61Uiyn9ETmZD6VVTSLT81PaSeaXSgH67gQaeuOHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IT964E2qaSWgR02ZMDaxN3mTXXBROd5RBL/8ZwOVO4NUXfHzzg+lJcYRavvTdW7sH
	 WqGen641F2vcf+ozTsh73sTlHg8y1ZHrxHWUXfsiqMEms0R6g6OFrYRxqZMV+A73a0
	 Nzsutq5BMgzn8Ccu8r40KYnnzsVQOL6Lva2xV4rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 092/206] cifs: change_conf needs to be called for session setup
Date: Tue, 12 May 2026 19:39:04 +0200
Message-ID: <20260512173934.805162656@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -111,10 +111,21 @@ smb2_add_credits(struct TCP_Server_Info
 				      cifs_trace_rw_credits_zero_in_flight);
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


