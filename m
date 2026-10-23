Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774312;
	b=R5LRiVHWetLSA/ElHs0Cj2LYHsxHIvO2j33M1Y4EO8Smj4o3mKx/3FEVRihdhbMkFx6e
	 8hMAlVlRsfO89IPmQiDDkvn6AA/LGdTEiF399vSX/UTLAL0b7xJwRzaG5PgiLdOp4cEcH
	 HVmtWQD5LQL8IA1lsXKBBSSUkOu7/LOPJRi9MP1ttfTMa0B0kggEoVf+/bamFHUS7kfeZ
	 cwT2zC/PLGW7/vJWKC3U9ASBk7spxq4lDBzHR1qTGuQ0I61UAUH1OA2TCtrYIoyi11cnu
	 Fpm+qrh5XK69YxsXnjY5zEc8R0Fif8q6Omoz//US1YT1CkLbyo6+fZThPQEA8QZoyxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a09IQKM8rYEumL7lnh4hSm1Fl9u/VbHRhm3go7368gc=;
	b=Y+Or/M/Pq6tHepCWaVr9+ZPFPHw+KkH5frCWltH7nqi3yIm4vRI3w9S/9MX1GcdQ8heZ
	 2U3Twb+4ua0/7hjpVjQrIxQpdw1arhOLGluU2mZ/sN80d+siiyDx6WR/chrDSSyQoXjbp
	 x6awpg8OH08ujYRbU8mED4qPszi3EbBfCE8mA7CnavALIQNOaCiDd1xu/LYoELWYvZ/bs
	 WecxvyAdvV/ofWM5h4Nhtz6WQVgCQoHngxt/cdC3rTc4VUNIQXIRZJh0mw3I+iUzvenze
	 yzcslWXPvVjQ+Ca6YC2kx0kBDiWygYSL4JX9YhycSeLFgi86gJ9cfny9c/rpYVdAPpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8FxBuSn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014FE606A31E;
	Fri, 23 Oct 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8FxBuSn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A831F01825;
	Fri, 23 Oct 2026 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774311;
	bh=a09IQKM8rYEumL7lnh4hSm1Fl9u/VbHRhm3go7368gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8FxBuSnmihR5NCbHCZtiK5T4/kbtl36JuPc9WJrkrVZV4nrn77kkllSPkRkGDPZZ
	 YYcrC2z5/wtHFGYv6jCTjPfclQvKIMpM3kapOmrKZsphYMrzFwcM1Dc10Y21YG1aBM
	 tFOEaECnnPjK+4H7nNG5g3jJp35PaG1R4Es9E4kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.18 193/193] smb: client: drain outstanding I/O before truncating on O_TRUNC open
Date: Fri, 23 Oct 2026 18:37:50 +0200
Message-ID: <20261023163718.786754121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 3581f843defa0bb30fd7da1e7dba170465e13a95 upstream.

cifs_do_truncate() flushes the pagecache with filemap_write_and_wait()
before resetting the file size to zero, but that does not wait for
direct/async I/O that was already in flight, which can complete after the
truncate and reinstate stale data past the new EOF.

Drain outstanding netfs I/O with netfs_wait_for_outstanding_io()
before resizing the file.

Reported-by: Frank Sorenson <sorenson@redhat.com>
Fixes: a8603b52b39f ("smb: client: fix data corruption with concurrent writes and O_TRUNC")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1003,6 +1003,8 @@ static int cifs_do_truncate(const unsign
 	}
 	mapping_set_error(inode->i_mapping, rc);
 
+	netfs_wait_for_outstanding_io(inode);
+
 	cfile = find_writable_file(cinode, FIND_WR_FSUID_ONLY);
 	rc = cifs_file_flush(xid, inode, cfile);
 	if (!rc) {


