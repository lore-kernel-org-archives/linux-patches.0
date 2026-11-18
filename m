Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047730;
	b=kfcAbrHMwtGlAddXFtozChoQ2EdvIxM/Ohl/V1LMOrcI4/ttNuYOIaVlmlqOUTCXoW/A
	 8+wPKcKxqj4vgslIxR7b9BwYGt0wKbETC5U3aIh6A/lw3t039vPkvEySboPVCIdI2L8wS
	 HEhT1OZ9l/wLZ5qRXLLJEjohpECr3eFJ0NIQ7LeNaatG3oWlHS/xTcoteknv9EXbiQUjV
	 hTbrO2s/u49A3MDkb9E6Xpj3fZWBRYg8X2avJcLfmfXhm7fAk4VjZba7r5IcaxrOWrJBa
	 kBPkXNF4tjdB7xXkW3PLeEZUs31By+R3ib4a2cMFGzvsdsUu/v6sChggMB43Ju+OcUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tdgcoVQM4R2EDbyUnG0pYx5h8J8zzn3N766+9e9HRzs=;
	b=T/xQlwOrXmrZHHNhR9d1y+YlTk3al+K38k6FDXD1N/9rzr3du5OyP+LO2WTuH7Sx8v8p
	 v8mP4RamHDnE6LJfSNTIAX/UVOrNnx01wBEKLvMZRrSws4g3sLCK5yFhbWcmrQLNLouDD
	 z/G0svbLM60Gj2IWW06NkjGARlcPbEkLU+pThkvJW5qkr5odr53cCgwt+KSZlslp+TWHf
	 KcoEMQUesnGo9Hz9jMq9GpY7iELqS62MPQ7nI1Gu6Q1yY0Bv05m2jA4UDiPv7kbxBdD7N
	 9zYfbP3ICZ4OuQp5jbfj+CWiB4xfYRlEUCdcAKZY+kRgBTuDt+Mgvaba7yXmPBOqouw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPwJYuV2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2DA606A31C;
	Thu, 19 Nov 2026 00:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPwJYuV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A401F000CC;
	Thu, 19 Nov 2026 00:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047729;
	bh=tdgcoVQM4R2EDbyUnG0pYx5h8J8zzn3N766+9e9HRzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPwJYuV2wqiBdw1yjB6X59MoplIVJBFOosR0/OIfENq5osGz4qSZ29oASfkqbrlxm
	 qTsI8p3jV4AepZXlyLi9ldYzkDKeoev+E9GfYI3/UBQZOw/4s6Os+UG3hkKSw+PRQS
	 HJ+k+Z9gdRJ8QcQCnSmrxvGVbfsbuxMWPhjKWj/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1744/2857] kexec_file: stop the top-down search before it underflows
Date: Wed, 18 Nov 2026 15:46:18 +0100
Message-ID: <20261118150304.098484287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe0201aec2a3f..fe7a21e9fbdc0 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -429,7 +429,9 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
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



