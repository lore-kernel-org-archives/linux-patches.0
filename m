Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B783FF1BC;
	Thu, 16 Jul 2026 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212051; cv=none; b=dUCmmn/IBNNoro8PRQyiFvzbnost4sopV+E2LSml7qtHb1SEzmwClNygyfyMf6jGPEmvJypu+zXATyQdTQ7sNQaQUxTOkt9GyE19keEihXhatPxTDls2YgmS5fBTjcynxRooejNpegtFm5xHRatObxQY9SvqFrc2bqqaOYhTJs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212051; c=relaxed/simple;
	bh=Vc95HhcdZhXQZukWshLxm1stHqnnRKufZRqPO8BfM8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nC4wiYVMwz4YRWMR9UuVdMfq4WWuwaNCoyYJ/DDgWkuAqju6H3FITLZxRhQM3eFc3l3uBIuaT+i9U/pxSGVpR0q6qEZQlKr6X5NwJM8uHBj8EB70LBAgNDERwMON9ivJGa+AGbKkiTceurBoLRAwmN6o6YedjYG4hP3dTD2pBCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vLTAjyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vLTAjyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594961F000E9;
	Thu, 16 Jul 2026 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212049;
	bh=hZZqBTQVcDM+/x1UoQ/WhmoOIH62uRi36mTEOeKLgWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vLTAjyB5YfA6gAmJwfytjep06y7n97eeZ4vCTS3LPmMgCmRte5sv6jmueHYtYfir
	 /dAH9rlIJXr0XQnU/ZNStd8F06dH2aVubUOmVpxRWlJClVI6R2WNXZMFISSypNEcxD
	 NdYaEaKLzZ7/fIMRC5BBcd9TKz20rxSIOgPfX+18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 179/349] smb: client: fix double-free in SMB2_open() replay
Date: Thu, 16 Jul 2026 15:31:53 +0200
Message-ID: <20260716133037.383336267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit b55e182f2324bc6a604c21a47aa6c448f719a532 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_open_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3214,6 +3214,8 @@ SMB2_open(const unsigned int xid, struct
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 	oparms->replay = !!(retries);


