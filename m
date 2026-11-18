Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035235;
	b=s13wiv3LELFNUvNrW1bi1lYzsf3Aaubufq+3QPsI3MZEmkU9BIpgejlgQ3ql8STfWWPK
	 0dc6NsrADUsxDWaB6S3hHryGN7o1LMzHURm+W+DBEH7TVMOkbIrt8BC/Gd3VF/MW7MikK
	 bxohbK/IHxiI3/dsK1281Uuh89hMovDqBwokm4KRFl5GVl0p+RszBQXHZezW9+r0iz/tq
	 OjcSWH5Oax3eEEDMJKWY2hWCx032uPj3o+RH6TQvKIivNwMxf1D/wdVwRI1GX3OSgah+9
	 pGL/q1nNDXD+z1/Enc0S1LLIJNJ7r8NlkZZNDlZtdq7zDsDRzaiDYrcd3WztPHKqnfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwmbstO6uI0/TxBpyeggjxGcQFTVrEhW1BxuE+kxy7Y=;
	b=ZXCjaN3a8YDHcuakfANPYH+I5PV/BMK3z2WX+CLtZdBSfIULpiONK9JOkanb5IPmJIsg
	 xdcXXkc1d+EI4ja0OZtamfREtmmAJwsLIQcfLI9zUPYlfTzR1Ah6Mk5PkhNnJ9jEM37W7
	 RCeo39K/bZGDORF9bc/IRPxNepimCMkCY4IgbRSUbvNwylebaIJZ8kAUbLp0Vr8OyNFhj
	 BU3k44f6kxYU3DvHWAd09pxkko28UY3h7K8FqUFMPQ3YHSDhxXds1m24Uktn3JE5aOf/0
	 UdrH/2p1QW5h7dqpXOC1dURrfN2cHxYDe1ZCgQpxvg8SsL0ab36KE7J9pfybkwGB+TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BOVuKM15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A65606A332;
	Wed, 18 Nov 2026 20:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BOVuKM15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBF01F000C4;
	Wed, 18 Nov 2026 20:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035235;
	bh=kwmbstO6uI0/TxBpyeggjxGcQFTVrEhW1BxuE+kxy7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOVuKM15v11JSMItBc8if0ASU0tb8yttR8pDcjVIHGc8M9RsIoXYOCAVQ6Mgv5NI8
	 3rB14Kmkm9b2Vu6IVA8qciePk2pWXdiDG5G5wbCzS7SxxOuSxSiibnlrwr4yWzSgLz
	 jtYhrSqigwSQW+9hpRISRNpi/ILgobh3+gEQbxzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0654/3318] xfs: fix unnecessary dapos truncation in xchk_dir_walk
Date: Wed, 18 Nov 2026 15:21:16 +0100
Message-ID: <20261118150337.649259399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f60a2ef8d8a7ac6dedf4d0c3325cc3fc2fe0d948 upstream.

LOLLM points out that the all the implementations of xchk_dirent_fn can
handle a signed @dapos parameter, so the truncation here breaks the
information captured in scrub tracepoints if the directory is very
large.  I don't think it ever made sense to do the truncation for the
VFS readdir code for programs that can handle 64-bit offsets, but commit
15440319767942 has been around for 17 years without complaints so I'll
leave that alone.

Stumbled-over: 15440319767942 ("[XFS] truncate readdir offsets to signed 32 bit values")
Cc: stable@vger.kernel.org # v6.4
Fixes: 4c233b5c4f29df ("xfs: streamline the directory iteration code for scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -239,7 +239,7 @@ xchk_dir_walk_leaf(
 		dep = bp->b_addr + offset;
 		length = xfs_dir2_data_entsize(mp, dep->namelen);
 
-		dapos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		dapos = xfs_dir2_byte_to_dataptr(curoff);
 		ino = be64_to_cpu(dep->inumber);
 		name.name = dep->name;
 		name.len = dep->namelen;


