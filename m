Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F8740681D;
	Thu, 16 Jul 2026 13:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209563; cv=none; b=QKU5yTv10sdFtw2HqTQyo8VRpg+Wts0Z2EY8htvM0LkCl6YnalryfdJi79rtirYE33NHXljLOnw2XBsLWqSKYx7wwZ5TKJIw70v/Z3SpJoYzFMQ+r17TE82uVMdoXAXYsS/Sq7NqKKoYz35lMD60hwaNxbQSANUwIMvKeTxQzOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209563; c=relaxed/simple;
	bh=LoE37MF4Vktc+3oNjbk/AwvBTnQqXZTNO4VE/q18hgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuwePhUpeuclkJWajlXC3bOd98DjiOpkdKN6AWCxfrbQ0DNivssB4jLkti2GNaARqvK55DaZ3CxNgXnygcFSzfQmmddBsS083zlO2hslreZi09qXKjuVmIF6ImDIsl4Ooj6VaqMxzIPEQN+VQjojrEyKy3FisNdi9N29fEsv7dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKfdcqp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKfdcqp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550181F00A3D;
	Thu, 16 Jul 2026 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209557;
	bh=4OxNZrLCAe0pOU8OO0ua53i9johB1oWIzJsx9ef3QmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKfdcqp+o4hldAaOnUvcnG0dn+EIyDnj/8x9cepe51EDQQIrIMkm+Gww87UWGb6Eq
	 cAakbsyjvFaybGqQe84j4PgV35O9mS7jdE9BfNjGYFx+HigmCaubJZc80/wzNlLCFb
	 RwNY2RQ5+h22K97cksjGDRTKOVYAi6Dg/rhr4SvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 231/518] smb: client: fix query directory replay double-free
Date: Thu, 16 Jul 2026 15:28:19 +0200
Message-ID: <20260716133052.876931044@linuxfoundation.org>
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
@@ -5683,6 +5683,8 @@ SMB2_query_directory(const unsigned int
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


