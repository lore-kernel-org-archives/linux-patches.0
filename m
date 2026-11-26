Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705602;
	b=TY/Qxmxy9kLq+eaekJwJiLpaNRCWIf5/sjgbCs9w2KLM6578mT0kLbPr+mi8g4iJH8X/
	 JVBiQz6I0oJEgHbLByDGYOUETD85dr6DSn/5s3iprFl+QFjspR5m/dwtkgQGW/cHbcF9J
	 cCR/KaGKG4mKCNSGmuGMOqJL1xtgWBOwM5PAaheewF+pIuCTYqdPmxms0OxtDXeMfGCa/
	 jF0F0Bxj09iCRstkRlXj8l4JKQC9ADXvuiFG6c6cXw2eexYbb3sCn7AtP/A3Oq3wNZcuB
	 5XjG2wrirLkNNm0btCWR88DcZSP4MfYrYtA8k5Ujb/6AGbod+iNxdXbSdFWnTOUDjYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dT76koQ744mikKqt+M4s0wy81w6kNwRSuXfVyxwMKVg=;
	b=zSXNDfWjHAL0rosZ5/4iwLrg9aLYQ1L1v2b9XB8+DfHoVkKG7WN2w5xtdoHy4pHN5L/b
	 JgGJmuRKlqAlKYlPSiv5u6E2T+aayFrOPg5gpGR+ksR0VAu5L4OGuwaQz71FLvX40eg+L
	 XOmJr+B6aaKLLVOdVR4odF7ldL4wGRPZhTLILfupIp1VO4hrsvo/EqHNqL9KT75G1lQbQ
	 1arOL8jj3GLJPaXbABT+f068qwcFdJZGCrQiYzjuQ2JN1vNPKY1m86DREPIkrL+qTbqIN
	 cFZq/J+eaRpoNJrILqAZ8ucvJqXy7uUb3cTCsvU2iT7cQRZ3jTVSIHSVbdqi++t3uRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3ppDV+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7C7606A326;
	Thu, 26 Nov 2026 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3ppDV+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACDB1F0093E;
	Thu, 26 Nov 2026 15:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705602;
	bh=dT76koQ744mikKqt+M4s0wy81w6kNwRSuXfVyxwMKVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3ppDV+Cgu547rFjayhDzEhhQuS5leThD81w5A0HPcmozPAh3HXnww6iUxYYWcNAx
	 Pf70VNMdvTCr5Ut3j3KpOwLBulb4P/XsgpkGaSa+LYQLY3GWvTDn8mYCLR/KF9cDWV
	 1G3IKEBS+YyN0C/g12FxxhZRenGTRbVOK4q7jok4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 252/319] dm-cache: fix ending a cursor that never began
Date: Thu, 26 Nov 2026 15:40:20 +0100
Message-ID: <20261126144012.431756056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 421420758be348cb90715bfaa26e1211a12ff1d0 upstream.

If dm_bitset_cursor_begin fails, dm_array_cursor_end(&cmd->hint_cursor)
is called. However, cmd->hint_cursor was only initialized if the variable
hints_valid is true. Thus, we must also destroy hint_cursor only if
hints_valid is true.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-metadata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1444,7 +1444,8 @@ static int __load_mappings(struct dm_cac
 					   from_cblock(cmd->cache_blocks),
 					   &cmd->dirty_cursor);
 		if (r) {
-			dm_array_cursor_end(&cmd->hint_cursor);
+			if (hints_valid)
+				dm_array_cursor_end(&cmd->hint_cursor);
 			dm_array_cursor_end(&cmd->mapping_cursor);
 			return r;
 		}


