Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060252;
	b=rvq+naZ+RRn9MsRIMlkU5ly8wz3mNFy6KnfcGNZfF/JQ7Ml582LyP7LwCW4I5BcFIxAc
	 vKpbr8aRLMhk4qCJ2nQ6ZSAEfLEZmji0AcbI+kG/fb4ceTT2io9GdRsruPgDWJW6JUOhg
	 E1Fzgf4tghqtFsjkW04qTAdCLqgHgKterjWiQAt8rg3woSqITdMvvd+wtVnL0NrTlYs97
	 aYwl9uD811Up6C8y0ZOvdzCkWkFEzBIQMw7aXBFJt0KvFSlKyK5hm73kUZs8j3xp2DNe+
	 SSRdduBYyQdK456hS8ydrRAXM2VcHv1XIQaT8X0XzaP3aZRlYNIfFhPOaQfpMkJvTsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y8mwhuWxoWy+C8HyfFmXSiX6MkzLXARRk1NFlclooCM=;
	b=vP5n8J4PN//wikQkZ7N9yo/mmMCWyT9qlI4NhOU1D2YAbskR8UIQoe9LTAwv4aDdeNfc
	 /xZJG8cLz9dOan3RLZEln13+LUUjp2EdWBwtOFtTuXHk48rgzdGu8V1vmdWfdwqlbLHTH
	 8TVEjR+kvDZZaVHhmvcn7Pqr1Q1Z+cWyyfcWmcqipNooAElTQ9u+VSyJUpUubgInHz7Pl
	 zwJwlJKCucYEv6EXfKlGLmZyvPND9X1UW5nlEAKssR6gIIdAf7MHoFLeJsQnmTaVmIYVM
	 C2fSpLIpt4PekcIrsY/AVCyy6vKltdTMtafHM1LUMu0H3WBTtZvI7SiEIUxiLzyIxQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0thP2Nb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F11F606A320;
	Thu, 19 Nov 2026 03:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0thP2Nb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF551F000C4;
	Thu, 19 Nov 2026 03:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060252;
	bh=y8mwhuWxoWy+C8HyfFmXSiX6MkzLXARRk1NFlclooCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0thP2NbP+OEFsTxmizfaXXE9fdAk+I9BUHcqElKbqu/XF1iwWN1zYIHffN5ps25y
	 PWc0ppL4e8TlpzqbxXvGTKxwxIBkq7cTPKKI1EHjCL+wp5Bh1a1LP1UFvdn5KjFYR3
	 wQa0DQVDQOEHW1DIJtuBOPWU0bcM1j7EHdpPacrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1132/1848] kexec_file: stop the top-down search before it underflows
Date: Wed, 18 Nov 2026 15:52:50 +0100
Message-ID: <20261118150006.744045749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index c669eda6f71d2..6334fda93c8c3 100644
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



