Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4B41F5D5;
	Sat, 12 Sep 2026 12:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214434; cv=none; b=n4gp6UZqQsgsIfx/astT09Hy3TMIA9+//UV181rN51N0YLlpBUnd4Uux45gktr9hlwdJOawg8FwFE9Y41KLsHroVTZQdc4d50MhhcvdkSPWH+eFgTEMF53DdE7ruIh6teQrrk+NuBvPv/R1SVaucl+siLykIMtToKhsRl4H1X1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214434; c=relaxed/simple;
	bh=LQDUzVb8rs6mSmHBNAhS4E6LOX+pKBK18MB12bj0ezA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMhd7I3EhDWogq6X1Uv5thzTS0g0MqSTv40vS8fNgdLpWH6HTeoa0KAGgLNe4XAJzMcNrzffUSgcGphhCT5G5W0NKK20ftt2UlIbhuHNIjaabLJaL8iBtGtpDUSIhwrsPRpIZJsJJAAJF4l9S2OHOMFxS54JZfwimPJtJgFNXA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5Yls+Md; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5Yls+Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C1A1F000FF;
	Sat, 12 Sep 2026 12:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214432;
	bh=0eCLyX+vy2fzGulaeNqzbyWfwYYT4cD8nGcjNAUkNT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5Yls+MdoDHXxBIW51pDMBpwsGnqnZsVibPVyn7Xma5OfSzupghqWEpnhD+bPnAOm
	 IP9RPDXI0PVPsWKveQB27Rs4JB0CbuKGw6DBiPgeq3kSrws4VoqOg04fkuMN4iq0ep
	 ILe36y3NSb0XZtqpR42WCu6cwL7qiJKA4etCeAII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0288/1376] ksmbd: zero pipe read compound padding
Date: Sat, 12 Sep 2026 08:45:14 +0200
Message-ID: <20260912065613.965956704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 73f860489e3be2245598d1819226304fc5b87291 upstream.

Compound response handling extends the last response iov to an eight-byte
boundary.

smb2_read_pipe() allocates only the payload size, so the alignment padding
can expose up to seven bytes of uninitialized kernel heap memory.

Allocate the aligned size and clear the unused tail before pinning the
response buffer.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Cheryl Babcock <cheryl@renat.io>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6739,13 +6739,18 @@ static noinline int smb2_read_pipe(struc
 		}
 
 		aux_payload_buf =
-			kvmalloc(rpc_resp->payload_sz, KSMBD_DEFAULT_GFP);
+			kvmalloc(ALIGN(rpc_resp->payload_sz, 8),
+				 KSMBD_DEFAULT_GFP);
 		if (!aux_payload_buf) {
 			err = -ENOMEM;
 			goto out;
 		}
 
 		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
+		if (rpc_resp->payload_sz & 7)
+			memset(aux_payload_buf + rpc_resp->payload_sz, 0,
+			       ALIGN(rpc_resp->payload_sz, 8) -
+			       rpc_resp->payload_sz);
 
 		nbytes = rpc_resp->payload_sz;
 		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,


