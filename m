Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771AE442FDE;
	Tue, 21 Jul 2026 20:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665152; cv=none; b=h2mxxk7j375Hqu7tOV4Bzs1xlckem8AztEKnl0WggeebdLqRNX4iTHbPH1dOH8axGNlY3cuftBOZrvd+ieuTBanmmMnxIcUTcinUnwIX/wLREuSa9z+gvrIm+6K49RRJM/hKGsTuxpFwiqRCuGIqja2uCf4AVzpTFm4dFLweTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665152; c=relaxed/simple;
	bh=9Hmc+UhFLS7ONhFm2gvJUaRgQIoibybXI3f3g88OsCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3wtDsOPTVnfPKh4RJsauwzmUgpKLbhOHNTzjCMcHd3vWDaZ7wvZABKF/WY/Vy96+EGu8WRy6H9wxz4p/9yl2oGSEt8HCXk7Ivxix3dLZcmeBiqFiLeOLoQo+soc9byF0BWFLch5saE9tHVaIhoCqmNoZAanb+h2ZUcMDS94juA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGPJDlj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGPJDlj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF2E1F000E9;
	Tue, 21 Jul 2026 20:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665151;
	bh=goP1dyBeIK4m9XXYAHsZ9hCU7eLWG4aTPKlP5gEuWL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGPJDlj3JYg2KbdGpkZq16pLcvDW2UDt5jPXVmTOLnORW5I+hPv/J3xY2+emMo6pE
	 Bwq3fXvXGMbVtz+1jEi4jTur+SJpP9j3AjGvSLqX4+CVBcIMkE5Tpxzn6OM2kCoLH2
	 hmptlm5kp2x8FLWnKOhoupwcaiQKgyh4ZdJu1JHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0197/1266] smb: client: fix double-free in SMB2_close() replay
Date: Tue, 21 Jul 2026 17:10:34 +0200
Message-ID: <20260721152446.217816456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit f96e1cdcb63ed3321142ff2fcdf784e32cda8fee upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_close_init() fails before the next send, cleanup
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
@@ -3629,6 +3629,8 @@ __SMB2_close(const unsigned int xid, str
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	query_attrs = false;
 	server = cifs_pick_channel(ses);


