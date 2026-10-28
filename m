Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208997;
	b=RLTQxLZC3gvWyMyeR8D4u7NSNBPSWpTTM69MuQ5573mlJeoqMonwEFcc6HyMTSKxAz6g
	 vRjhfUQIOMbhu8LwJ5QAQDIekT8P/lScZknTi5iU/geLnKB/jrAvd3Nip29yP8AwTF/Ub
	 TBWQW4rRtPGHssmETU1+cQp7h36OytroIgzwjTi++V/x7veB3EZ0GhNCMJJMltCbDeIi2
	 wHiGjCUgQwyQRRFQlcAALNZTQ4KW7DVnagj3gjxzipijGZWF9sIToljlNQVvwuQav2uh/
	 dYdtCMirLJWJ64DafjzTuvdaL0SItLh/nAEZkjdqqI+qRPfOwwj7tIUH/zW9B5f7Idw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gXgEcJXufK5O0QURTCDk0ldW3g6Kt8ZLuCb6gJ2apAQ=;
	b=Hvr21P6mWOtP9cUUeMHXeTUuC40rm4IwCvlDzTJdFDd1LOlMxUI7lF1ZffFzgwpdWQqW
	 T5lzfqrwqr2P4ldMMSqXSMTP8IGpcmDnLqU+Z9Tf3XRsQEQtu0mXNQ41eHFe/Ob0Z4Tyd
	 XRGvNAAUjaThe42sPz6PmTX1yx0KQmIEAC6S02g2R4SNOojra/WOYkyGppSfGkFlyOuOq
	 nfrDTjDyrzO8ERFOcPnnWxIvc05WA6lTs/2av1WFI5CYa2tu7nlo2qBHs31slKAfV9MbA
	 nQNCVK337FICnnlxKoekzTaa2EDRxZNwLEezUE8tXMYYuNbkcf5WVdz13CzX8WLohlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e59BIBOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D226F606A31D;
	Wed, 28 Oct 2026 17:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e59BIBOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0291F01828;
	Wed, 28 Oct 2026 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208996;
	bh=gXgEcJXufK5O0QURTCDk0ldW3g6Kt8ZLuCb6gJ2apAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e59BIBOjOCehGZHdIXH+wRGYtn15nzqJO4S4EirtwY0cWSWLfHUpDbmc14VA+oPxp
	 aKMq45V+DJcJkaAJ1G7NDiI2mUUozcADx8OcwHv+cjFVgD0KSC2A+BUPF5dHfygjEk
	 ysPs4lqMF6vnAb7i9KJei6fEoit32tCKs831wdLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 315/516] btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()
Date: Wed, 28 Oct 2026 17:57:47 +0100
Message-ID: <20261028170010.951589046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 1fd742c7479961da6d0bb794ef8ac6b7b9442847 upstream.

When paths_from_inode() fails, scrub_print_warning_inode() jumps to err
without dropping the reference taken by btrfs_get_fs_root(), leaking a
reference to the root every time path resolution fails while printing
scrub warnings.  Every other error and success path of the function
drops the reference.

Drop the reference on the paths_from_inode() failure path too.

Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -692,8 +692,10 @@ static int scrub_print_warning_inode(u64
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to


