Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D694515961;
	Wed, 30 Sep 2026 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787943; cv=none; b=AT/hBcYVWcLRwJ6FjK26PUFUakxh2zN8vVSf8BN74M/qSJ3feQKQxnIQ84FUzWmx4CfF4oxcy58DECk0c/yoemOHWt9tnTPJi62aTept2PXUnSUt+/TtGZSlFZKSNlnQDZ4D87tL3jdF0QatXqhadnhMURGYneWpKow4IQa3zmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787943; c=relaxed/simple;
	bh=Ork1ADqVEzGcIrN3RXxxauD7JigU1XBm157190ZlCKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOVqKnQzCcKcj3wCTpnuNL3uPcIiky8VgLqR7gGUCUXxefCRm6B+u9LXP82mx2vjxyK5jjh7yCVNz40kLTshofyHFqlHr80PqoIcxuIZcY9c+df/DftJ2aO6XHiRT1k7zWRvickLBE6KmbIefoBbtsFlDPjFDj35J+snYePFYHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsEdcmEn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsEdcmEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6F41F000FF;
	Wed, 30 Sep 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787941;
	bh=VueIuVsvfgOyM5sVkV7Mv4PBiXE4h5O0dcOYV+GPTJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsEdcmEnsnPhWaAWMlMiSzoU38GcnoXqPTqnWsAQboAgnEYNRwRFXuiufz6zTa52d
	 qj4SXz8dRMcpgOGP7dULvCrytn8pmGcz5yN5EQuastCCoVF3cJFkYmcY+gzD9uOshL
	 ra1Jh3s96XXkGKEBbrTDK3gFYLR0aol0i1gw8Viw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 409/457] smb: client: close handle after create-context parsing failure
Date: Wed, 30 Sep 2026 17:28:34 +0200
Message-ID: <20260930152354.818831413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit 566820af017e81497fb5e9d3ad6e7ffe2828bc8b upstream.

SMB2_open() accounts a successful CREATE response as a remote open before
parsing its create contexts.  If smb2_parse_contexts() rejects malformed
context data, SMB2_open() returns without closing the handle, leaving the
server-side handle open and num_remote_opens elevated.

Close the handle after a post-CREATE context parsing failure so the error
path releases the remote resource and balances the open count.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3413,6 +3413,9 @@ replay_again:
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
 				 oparms->fid->lease_key, oplock, file_info, posix);
+	if (rc)
+		SMB2_close(xid, tcon, oparms->fid->persistent_fid,
+			   oparms->fid->volatile_fid);
 
 	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
 			     oparms->create_options, oparms->desired_access,


