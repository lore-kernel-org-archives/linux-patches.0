Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041333161AD;
	Thu, 16 Jul 2026 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210919; cv=none; b=XScPx4/evzWqHDHpwTPbZyQYXuOybAmWcdWbZSc09ps9WdL2Yt1SnDMxQ4zamHdRkI3V+r7BojfSy05LV1PUPkPjd8W+Gm3/Sj/zo14Ry8BN9fKtY3d14KwhevFjv5/r7vEjvCQPEv0mrhAUWgwTbIh0E21Euq8fewo77Bg0Glk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210919; c=relaxed/simple;
	bh=ikuw5MxBTgY3mhpAqjOVbh5SSRfhy5ftfdJctljT4bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mU0mOoqyhUjy/m6jENNqRYbkXzDvkle6nhURjEpraSQA/ifJxD0dnpLcxmKb0HaCcgOlw4ddmXC4KxocQeB8tBXgZkjVllPAe3fj2TGdpOFWoZmNauQFP9dwYnd4mK7PdpiMvJjWreDDjU0QM/NbFHjVcJxX1xRgiv3bB+xev+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUqF4sBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUqF4sBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B3D1F000E9;
	Thu, 16 Jul 2026 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210917;
	bh=Z+Jo0eJI/CheOn3kcDgWWDaJoD5HcLyBZsOtobWoKY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUqF4sBqoCDpM1FVGxIl4Ys13mIccS9LtD5PtXrGv2a5rGchufGIDRhjgH/NHUooW
	 I+/0tKugTdNBqETnvxnG4rlIXU/L1jqdDLIU5bfMhlFmZX/Opdinr1W30Ns8/TAIXL
	 nYTDbFt1y/v40B4Gh5MJFcCGRKbMI53JW9LOvWcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 228/480] smb: client: fix query directory replay double-free
Date: Thu, 16 Jul 2026 15:29:35 +0200
Message-ID: <20260716133049.746486307@linuxfoundation.org>
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

commit 9647492b5e41954be59d5157eddbcd4cdc1656f7 upstream.

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_query_directory_init() fails before the next send,
cleanup retains the previous buffer type and frees that response again.

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
@@ -5668,6 +5668,8 @@ send_set_info(const unsigned int xid, st
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


