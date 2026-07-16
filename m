Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20870424667;
	Thu, 16 Jul 2026 13:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209570; cv=none; b=d1OrBI61560qimRIFLPym+YTgwJ/GPdbQrqNYoGC1Rut4JPYB1bqDg6RHDe6jk3hjXVSZag84iko2GDYNla0GzAlyV9oGsflKthy0Mu9ZJjPduoQagIQO4EAdWKpK+T7t4XerRGbUwFlmhDp8tfkD15wOW9+f9lnz6WfRyQJi+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209570; c=relaxed/simple;
	bh=7Rdbu6H8whkzAazvrgpqJXYQWXkWPOKPmBUV6ouiqlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDHjwZcFXh6gZ0yVnxTHMWqrifBoUxYQO3nUTtRP5Zo/kxRNiGgnfSxVrJ8AdvVip3IVo0I74HgTGao7qNcIdgsntRzYPWFk/2LadzoYCNn2+hw4fl73svc4Ok7FTAAdGj3KoEqpolP//KoLn3E0+1lI8uzooAhgeaUiYAKDG9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b//7QQvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b//7QQvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2E11F00A3F;
	Thu, 16 Jul 2026 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209565;
	bh=cAV2QKwQv9aGvhJ97jBTNM/bQV20BTp1npMDcj9X5yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b//7QQvZ6wLrvI00cmfaCJuIu+XjTQYAiyr3zdtTqwDLXY2qdOnMC3XqrUVm7y1cD
	 FHxQUR+QwDdul6+CSqICGTjC5X3/oJEu3HK/HEfQriaqj93ZV4UPTTivlY9/ywFQVe
	 LQs3oxKukvm2C/hef6r96siCA9aoB+HRb6J6GXhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 234/518] smb: client: fix change notify replay double-free
Date: Thu, 16 Jul 2026 15:28:22 +0200
Message-ID: <20260716133052.940895138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 145f820dcbb2cced374f2532f8a61a44dce4a615 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_notify_init() fails before the next send, cleanup
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
@@ -4087,6 +4087,8 @@ SMB2_change_notify(const unsigned int xi
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


