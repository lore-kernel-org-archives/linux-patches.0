Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E57435A96;
	Tue, 21 Jul 2026 20:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665144; cv=none; b=JEPEYiw3hFOuPnpPbYHIA0VUVC/mJs7V7lw6HJsjLwawAVTAfPuYPytO1PCG3SEvZB4xADK0fGo5EBFLOyMfRMoXoksyGsB36Gu7eqoBzcdIpTqJolJXFZUdK4eu9pF7FvXid70xt+S8KocdRGYUkMGTpeDTGyvj3kyD328PBuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665144; c=relaxed/simple;
	bh=PMbOov/PWbI0FAtjhWMca3Pt5+Ea9oTDxAd15bQiCFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRQL9TXeAL3ZaWHAqTTzKxG4G5zxSmDSoDwnbnI58AFSZTQ8uvc9418QO0qQb9qvZCmymeWKliaPsDMHO5yyTQdKyFJGlrCEq4oslYSpOs7fCkj4a5qpZOgN8B6pUVQh1z7/xD2Eq6P7jc5XiFWhSIqDyvZhfMwnHVRnl3ye1Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdHJlYcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdHJlYcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8351F000E9;
	Tue, 21 Jul 2026 20:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665143;
	bh=QHmMP4pFCQ2iZRD3FOeBUDXA5MbPMAqhJXuYH5NJVqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdHJlYcp/rCY6BTy8b2ZqiHC87R/47UrJ3zFP6pp6/C+npXS+QrOx/eHD4FFzAqrz
	 G8XMxbUfGVnyGlsEENMBwOXPTDky7q7OZU2kkJ6picScYbuiv60EVLM1cKaoh/8qD4
	 EwsjQbtjBRwjVpv0wPfOhh98vHn/DKOqaJDOr+XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0194/1266] smb: client: fix change notify replay double-free
Date: Tue, 21 Jul 2026 17:10:31 +0200
Message-ID: <20260721152446.146299432@linuxfoundation.org>
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
@@ -4024,6 +4024,8 @@ SMB2_change_notify(const unsigned int xi
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 


