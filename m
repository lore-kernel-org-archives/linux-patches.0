Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054621;
	b=KKJKqjzo6E3z3HLu5178Yrayf8XOZvqJ0hDc0dykwoRqT7scVuh7vDcUm1zL63mDZDNc
	 zIyrB/2dlkGwjffdhxrVByI4Uv3D8P+7K+bhCgPz0WuzDtE2XI5Q9QdqY1nLAhEeYgVon
	 MK3lxe92vNPCVhlAI5s4U1DBwzOZScm+3myYwOMmd9HXBoQ/DiKy34qCBSldrIvFsBL4Y
	 tMPkX9pamusYHJeU7XTLpVcb6IpBreXBKJnLoIomlOVPMbVJlDUhcDuiPOHpRU7VoBfqK
	 SXIY9m0eiQQrYqZn3uGlq2qmq8yf1jrTUHqf3sKGHWpyETQn54p/9xI3YEYe6FD9S0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vQaSVuWVwyvOyd9QJTydXLIK0TxADv290mZbU9dopLI=;
	b=JNetFdUb2GvWDfc9q7deOA2QR4IrGQnBal8S3ef909UKhydxHcYuYfVY3JYt/ap5rPLy
	 9o/hBzuCz5CGIvPMK6cOoLHZYiArKju8mtOqSLahkW22w3x8m//4aK6z2wS+jM/s919sT
	 S5BdMJryt/A71ZlEy9LRhTeiph4cURDTdIWYXN/cd/IJoBiEE7ZbWXbGmptHhG3h6ud7Q
	 EtxbbSu1pfoXOhgJ7dmFjGZ98px9J9ObIpiFmlYiRPRm3j+YS/deaVJgyQkY0d/HW73+O
	 LIdfvpRYuoObyh8qvfOPE7xj6UKk2mCjQMno7HA5WNXt2AUrzmH1hfVryu94OnHomMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OH2V017i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6941606A31C;
	Thu, 19 Nov 2026 02:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OH2V017i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205DD1F000C4;
	Thu, 19 Nov 2026 02:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054621;
	bh=vQaSVuWVwyvOyd9QJTydXLIK0TxADv290mZbU9dopLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OH2V017iT11889g188ToKto5SYKowx/X3itdjhkkOSUELrhfakPDRuFjfo1j8Lhlq
	 Kow+m80xV9GAueNet22Q9jjVnEGsEmmwrOr1TN74K09D4baeoouQ5jDQryq6IlKmSa
	 p1jEMTj9rHl0QDzlDFRhag1JcSwcanItblR5STpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1341/2214] kexec_file: stop the top-down search before it underflows
Date: Wed, 18 Nov 2026 15:50:17 +0100
Message-ID: <20261118150105.071451919@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c711461303af9f796b293b5ac06f49a885e46e71 ]

locate_mem_hole_top_down() walks candidates downwards by subtracting
PAGE_SIZE whenever the window conflicts with an existing segment or with
an architecture exclude range.

Nothing stops that subtraction at zero, so a search that reaches the
bottom of the address space wraps temp_start around and continues.

The walk starts inside the range being scanned and only moves down, so
bail out once a candidate ends up above end. That covers every step in
the loop rather than the subtractions alone, and it matches
locate_mem_hole_bottom_up(), which already bounds its candidate on both
sides.

This is a better check than subtracting with check_sub_overflow(), given
that we would have 3 subtractions in this block, and this single fix
would take care of them all (instead of three check_sub_overflow()).

Fixes: cb1052581e2b ("kexec: implementation of new syscall kexec_file_load")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Link: https://patch.msgid.link/20260812-kexec_posioned-v6-1-e477887086f0@debian.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index a5ded0536e21f..e7dbbdf562742 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -433,7 +433,9 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 		/* align down start */
 		temp_start = temp_start & (~(kbuf->buf_align - 1));
 
-		if (temp_start < start || temp_start < kbuf->buf_min)
+		/* A candidate above the range means the walk wrapped around */
+		if (temp_start < start || temp_start < kbuf->buf_min ||
+		    temp_start > end)
 			return 0;
 
 		temp_end = temp_start + kbuf->memsz - 1;
-- 
2.53.0



