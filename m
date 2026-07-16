Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7633BCD11;
	Thu, 16 Jul 2026 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210937; cv=none; b=hkUyUtp8oGnLNjCSoVGwRdrwCl78QqMnsqq6nOYJ3ixBM60WhyriCmexHUMYlyvRL5vF2wzrPe5NTlmuGm5klzktgcxrkz5tOk3AU6ckAANGBHU5wDRSllLe5cpydBCUq10vV/s5EfeNjo11GXKzhoCnWXYDnVx2biW2kVpMJQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210937; c=relaxed/simple;
	bh=qs1hjUDxYgOh+hlByHZsUp4msM9lpneqj/h/PNQnO00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G91Zi/dVWIwJoraaGbfDyIjMdWH7eMkPtMT6HffRb4fDY60fWjfSF06wPV72+BtXE/UUBPMcWtwOpJ5qFZsI63tyqzYRosVUQ3m0fgL5rnkoQLH42IkyyhBxsONHd78rRqBDaU9It8vLMe9xUxNbwg3A8x6N4iLdFNE3+5kzkJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfu9mAGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfu9mAGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17011F00A3A;
	Thu, 16 Jul 2026 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210936;
	bh=tay3TZai6NoOTqZtzdyQsDeoUZ7qP6/k8BWNB4dVuXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mfu9mAGDsZcNeJtYJMyW257mugDXkhUtoviCscll/iWlKR6xxeljf5qoOeCtrMYZN
	 DEEQv5MljnNNbom+PyqxXA0sMe6P5dH5Ai64qsN6Yde8jbiuL3QxfQPbsFashxi2Ji
	 VN410YiMZQF1gacOYmXMMsuNsn8ahpTeKxMb7ajM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 230/480] smb: client: fix double-free in SMB2_ioctl() replay
Date: Thu, 16 Jul 2026 15:29:37 +0200
Message-ID: <20260716133049.794028338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit f9bbadb6c94583e3b4af1afc449bfceb1d1ddec9 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_ioctl_init() fails before the next send, cleanup
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
@@ -3425,6 +3425,8 @@ SMB2_ioctl(const unsigned int xid, struc
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


