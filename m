Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C347400E15;
	Thu, 16 Jul 2026 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209578; cv=none; b=PkJ5ztC7+ceREyZDSsrLaNxvSUJVUZvRLDwP5AG52wifFA+loIKKqKqMJUkgLd1pDBjFIzQK85oW7onLSEQsycRgeaTv1fLQO7nOIe4fGDGikjD3Gv+2kOIebUCzMUHrfiFtxvgqNcIM5ZunJcvQ/GeHVH0kUA36mk8eu/GtDVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209578; c=relaxed/simple;
	bh=xwkzj5wPz+04SNO4o68kXntaGG+9bCpJ45OusbkgKag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uogRxf5LhGA+6RIcK8Rj/IJVbDn8veWJpGXN0rcZnYXOvBvGk4lYBJymaIQO9P6GNaLiS72O6KoK2gYsvx5u22cx5g+ZJiRQu2A+t2ZpyZ/7o8+FSXJ5CndMT2FjHZnE/KjGIBgkjHQ+VaBo/tGHVRcXjTFJTt+1AL5BD2+JWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEn0q0g/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEn0q0g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220A41F00A3D;
	Thu, 16 Jul 2026 13:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209573;
	bh=A5zfGTn8EQ6Ry+ggA76Hh7ca4Sm67F1Ux2iPEVUsBqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEn0q0g/+LnZGmPQoesGOZeg1ooSmdDBH5E1onG8dW2YA5OPSD6u1ysPWqTxUvU+6
	 v2dUDowGJpxhaiMuw9fmS55Dy3O+fkA62Pnx+fPIlRrvYsiO9uoIE2HlPN4dyR6BtL
	 MEKzwaNqv7kYvVglUGzpvp7CT6ps4Sm17sWpUG+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 237/518] smb: client: fix double-free in SMB2_close() replay
Date: Thu, 16 Jul 2026 15:28:25 +0200
Message-ID: <20260716133053.006735717@linuxfoundation.org>
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
@@ -3703,6 +3703,8 @@ __SMB2_close(const unsigned int xid, str
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	query_attrs = false;
 	server = cifs_pick_channel(ses);


