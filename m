Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEE23BCD05;
	Thu, 16 Jul 2026 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211023; cv=none; b=t0FrQ1CtYu+KUF8Je8JJGYFNrRjREqRc7VD8vySwlpmEztfnMvyEyAJ89thgRI4RcMtmxicKulN8INdTUZSFHoIO5P3kMRR/WjIW8ZZmgSgHW0cj4xEoxAVhD1HZDWZXIRyMgJfOfMKE/aXC3Pzd9EgcfJSwKqJtiDqnVzVoIp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211023; c=relaxed/simple;
	bh=oN3jkvWTFbATuEVNEYXwFicZMSf9fpwT49vM+xx9/AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nifm1vNgy30Js/syidZw4zVV7l5eGA5TETSzype88pH4ZQzg9UItivXsoXkSz0UDM61RhWTITscajjIEE33yBZN90i5TZQZ7A9qP43rRZIvJ+h2o8Qa7w0I9KyZu1Yx2OvQGdMalnI5KRJRXMrHCpJuEDkHxJNpdj7k5ywWyFOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkAKto0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkAKto0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB941F000E9;
	Thu, 16 Jul 2026 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211022;
	bh=L3FROJBaLhDvM9puGF93aoF+ki7jHt5my868dQJfPOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkAKto0E1OsnRU8X8Dulrf0Xkmxi0niJ5Wo7vfqyap53VlLGaBqVyhyyh5jkLEJjV
	 JV3dIwQY4mXG4sRx1AFMLIFrmcJxtwIeB5fey+yCYuSCE4O5swVNTA+m4uOqtdpDmh
	 3MZMBQ/hrkXouv1iy/lT8bsVwigN3OyCzCR/2pak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 233/480] smb: client: fix double-free in SMB2_open() replay
Date: Thu, 16 Jul 2026 15:29:40 +0200
Message-ID: <20260716133049.859215077@linuxfoundation.org>
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
@@ -3205,6 +3205,8 @@ SMB2_open(const unsigned int xid, struct
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 	oparms->replay = !!(retries);


