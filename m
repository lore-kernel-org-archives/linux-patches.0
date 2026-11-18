Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054396;
	b=CVT/Af7/C8vybGdK1MDnGnVT8G/K81fwSyB/Sosj5d/sjeV8PMuYvraErOGzf3CaKuer
	 9TLRObRjW3vKxeE2sRayP4DAJMZYuYqnIju9zCCBeAQS980qR0RqQ/VUKRC3Q5+gZqt4p
	 mwKoujXJTK8/Jjl4hVsbmJuidVmFVbEFN2qzd1saQw3YEMmYzt9iYOm6tFdI30TiojbHr
	 KRwyTglOOczn9DNd2QFbzHoOcdf8/GVZILO6ioeMHh1BoWSHtd5xkokpe72TQ5dlN0cgr
	 w0sc3qVIgJSpI5l6NcmfqI2sjPgfYeYQtVi5PQPmmVd+QcPc5PoibshfNdS/XpxNHrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZcQ5R4fvJOeLYM1CIfHHNrYIOvp7pNdjHRQeqpJi+YQ=;
	b=RzKLmczhKWyditxBQoU2ZoTt9h/8W7OcDRqMIjGXTS161TE+s3JSu0yG+YZZl0SznHul
	 BHOda47eTbHaaDUa8HJQ9yulaQFOH3TNaA3GvDT0N37S0eEcRELNJsnc0AoQexL+kUMzT
	 NJIkQr1E3SXCbQOyDA7jcbaRuTqEFqUi1KWiyPfLQxhxhITyqPGfi7T2BfqR8oJ+78w5o
	 CYQksSg7kPQj0oTaSzqlmL9QoT/Bv2s6vnm0ZRJ+hgtiSvFeTEFneFBf/otArYZ4oh6fv
	 Y9nmqDoVxVDivULeaIFBEvt+A2kRUGSQXYLsarPCJG8gTO5ijUepqG0zPJcZYuQol0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUauUewv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA62606A325;
	Thu, 19 Nov 2026 02:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUauUewv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476FA1F000C4;
	Thu, 19 Nov 2026 02:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054395;
	bh=ZcQ5R4fvJOeLYM1CIfHHNrYIOvp7pNdjHRQeqpJi+YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUauUewvf4y3Wlp9I4HxjXbnpM5Z2aS9NKq6vvKzhfpnncWBlpKTrhYak1KyCCknq
	 BG2NMY2rGnrv0zbwQXgomBaMZB1LJjwEJQfRa35x+5KDtuhB43H7k22OKRY5BVfreF
	 4BVpQgY14qFHfFBSpXsDkRdUoJLtxEK1jYPJU00c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1260/2214] ksmbd: do not read past the DACL in the access denied debug message
Date: Wed, 18 Nov 2026 15:48:56 +0100
Message-ID: <20261118150102.053540200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 8296a64df5448548f410fb246c1d88a93609602b ]

When smb_check_perm_dacl() falls back to the POSIX ACL and then denies
the request, its debug message prints the access mask of the ACE that
the second DACL walk stopped at. On that path the walk ran to the end
of the DACL, so the pointer is one past the last ACE. If the DACL is
the last part of the stored security descriptor, the message reads 4
bytes past the buffer, and KASAN reports a slab-out-of-bounds read in
smb_check_perm_dacl().

Print the requested and allowed masks instead. They are what the check
compares.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Adjusted file location and context around the older permission check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index ed690767837fd..adf9d2d2e108e 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -1417,8 +1417,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 check_access_bits:
 	if (granted &
 	    ~(access_bits | FILE_READ_ATTRIBUTES | READ_CONTROL | WRITE_DAC | DELETE)) {
-		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
-			    granted, le32_to_cpu(ace->access_req));
+		ksmbd_debug(SMB, "Access denied with winACL, requested : %x, allowed : %x\n",
+			    granted, access_bits);
 		rc = -EACCES;
 		goto err_out;
 	}
-- 
2.53.0



