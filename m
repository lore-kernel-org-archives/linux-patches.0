Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829063;
	b=Na7qGp62gwiXehoevdrV5iwQ0/CwY/0w38wFnjayBrRNs6+QExlFmtdEsIWZEdTWIEpQ
	 JN3//Zw6u+HxcstSXzMBnp2QZpryHWB3I0kxFRMt2FSbNajOyOTsVV1a89n9aNmmGUYPe
	 qWO4yq5mJ6j11YJhrzosHSqF1RfY8UtbWzFoTOyQIm4lYLUFaw0IcsamEkyEj35xrjFuQ
	 OyG+NTONBE2nNeagdnqAsdOgw+Hi5TaGygJS6IyVQD66H/0xlExT3WmvaF/ckTc3I8BdD
	 zMpk9RIwCq7J6uQgJycRCbbKEbv0xGR0pT9C9lbImW0hOyUEoS0lBFCbKGMMIfyCN6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PhZz+LbzhndfomHnHMRSGWt43inSfjjlqlSt6DzJtzE=;
	b=Y8WjgSdzFbrioCNwq/3MlifJ8VpF/BvMcUoLXk51WccC899xKSdmlwNrXMJWuKHF9VDz
	 fja6kXWUP+O2ag9QhVDVRlU7YgvRXuW53dSqTthIcWoOpNjynZCjEUejARUcoVDHwsfbl
	 hkAy0RJpqy7hW/g+IfRTD1TuMfAE+1K2HFQlyLfwz8HU6xEfjheL6BcZpWwVXmHBNQVyA
	 k2zlp6/MQ5+ZfSVYcYXr05NSOeZkeZluhvuUi+VlVH5HyQeuAUL9rw0fIKyA7RHTUptnv
	 SEmdM3f0NbUH9zXYdHxB9wg+2KUaE6OazITSwFDMyMGIqgSLG9IUD9J/B9QzjirfoAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSET5yHu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08896070775;
	Wed,  4 Nov 2026 21:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vSET5yHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531671F000C1;
	Wed,  4 Nov 2026 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829062;
	bh=PhZz+LbzhndfomHnHMRSGWt43inSfjjlqlSt6DzJtzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSET5yHut0aib6SxmobPh4VKHkD669+SgfhePwhblzV0gVfVhULRY4Rkq5T+/5ucZ
	 3nYWyrAzzfkdfIjci4aXYxYp3up8vMhTXNfTJ+Ntarx9KEGPxBKuTS6iGLR5+OcwgT
	 DZ854FigD/opnaRudsGI5PpeIaWEkWan6xYrOMbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Flynn <david.flynn@hammerspace.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 419/547] nfsd: fetch direct I/O alignment for files handed to the filecache
Date: Wed,  4 Nov 2026 16:10:03 -0500
Message-ID: <20261104211050.235646287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Flynn <david.flynn@hammerspace.com>

commit ace72c3d263294df7111477caaeff37438aa10af upstream.

nfsd_file_do_acquire() fetches a file's direct I/O alignment
attributes (nf_dio_mem_align, nf_dio_offset_align and
nf_dio_read_offset_align) only on the branch where NFSD opens the
file itself. The other branch, taken when the caller supplies an
already-open struct file, stores that file in the nfsd_file and
leaves the three alignment fields zero.

NFSv4 OPEN with CREATE takes the supplied-file branch:
nfsd4_create_file() creates the file with dentry_create() and passes
the resulting struct file as open->op_filp, which nfs4_get_vfs_file()
hands to nfsd_file_acquire_opened(). The cached nfsd_file therefore
keeps zero alignment for its whole life, and
nfsd_write_dio_iters_init() refuses direct I/O for every WRITE to a
file the client has just created.

Observed on an export whose backing device reports a dio_mem_align of
4: all 16 of 16 1 MiB NFSv4.2 writes that followed an OPEN(CREATE)
took the buffered path, while 16 of 16 writes to the same file
reopened without CREATE went direct.

Hoist the nfsd_file_get_dio_attrs() call out of the open branch so
that it runs once, for both branches, whenever the acquire has
otherwise succeeded. A getattr failure now fails the acquire on the
supplied-file branch exactly as it already does on the open branch.

Fixes: d11f6cd1bb4a ("NFSD: filecache: add STATX_DIOALIGN and STATX_DIO_READ_ALIGN support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5.1
Signed-off-by: David Flynn <david.flynn@hammerspace.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Link: https://patch.msgid.link/20260908163448.30841-4-snitzer@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1285,9 +1285,9 @@ open_file:
 			}
 			status = nfserrno(ret);
 			trace_nfsd_file_open(nf, status);
-			if (status == nfs_ok)
-				status = nfsd_file_get_dio_attrs(fhp, nf);
 		}
+		if (status == nfs_ok)
+			status = nfsd_file_get_dio_attrs(fhp, nf);
 	} else
 		status = nfserr_jukebox;
 	/*


