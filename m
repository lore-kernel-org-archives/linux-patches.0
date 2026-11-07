Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063761;
	b=pIv6QVYfyButZqsA1q/OKfa79W2sc227BLs7LiG40p8qnIoLpeT14hP+jrQsFj7m3MAh
	 xt5ettXlq8TBP0LE7tWke+Gya+NBwd/EE4rrMJ51kEcTgpeGX2ZpIaxC6/Z2lPulGgNq3
	 34AWFvHD8K30xyS35H2HIMq/31e15C+LIOQXj0t1F4SktQJzGW+85Q0nECbMBrzY39AW+
	 PkyM09iogLRrGyqm9hKREmyWb0WQNhUN3e7h3UuDzBXHBE4Pas4AsIVjdJe7ybMyaz8iX
	 VMiEsyMPc+iXRG/37J3P8CtSGzlmK/JTeOQV5Ktj5VoRbQOwIu3h5jO2vn5upN9UCKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ewSO2obtSolPvDRTT37tE5dH7mhdNQuvgKqg79bAxhM=;
	b=bBYwgiDAuNUJJ1PdT4no8l7uY8qkWjKrKKhq0boOOWagFdY52Fx4QomLKU64kWmTMUlK
	 zklJu8ZvkDHAxOl/a8gRWgOmQX1TQ9Una6L1zaoxryb0sNFU8ndRCWF2EnehimWJAa1Rc
	 G3g9B0SFlGTgkiC1AcJgMwZShhrsFNDc6NY7gtTJkJKO5HFnZadUGFlnYooQkMEj1O9l0
	 kf283yWMCGeqUqUjTMcxgMc63YEJtp1DTKGmhMKP4glZZpAuGijzk51fifFQ//7N585Lg
	 VS0iMt+WqVBSFgk5QJnNG02FIBd+bTsDbZzT9wQG5NQjArC/OzyKaS17FaCtfMIIbAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVUfcF1K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21A76083637;
	Sat,  7 Nov 2026 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVUfcF1K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906EF1F0089F;
	Sat,  7 Nov 2026 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063760;
	bh=ewSO2obtSolPvDRTT37tE5dH7mhdNQuvgKqg79bAxhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVUfcF1KAvkrecchto1krBfoqe9eS6I6lQyQ5lmAmRaS85GJu44CnS/kYISA5+pdz
	 Fmkds18Awx5ss+5IWB2BlJBD30KjjAi2AlqucZeywhkz3o5dH6J8SzuNz5o7es6ajx
	 TWfJ89il/8CA0CnkjD1iGUt5qsbEW/4w6OFP2U7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 854/869] apparmor: avoid potential double free when remapping DFA tables
Date: Sat,  7 Nov 2026 08:58:56 -0500
Message-ID: <20261107134921.729563903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 7ccd884a5e5386f4c7d98625113f4924f70286b4 ]

When unpacking a DFA, aa_dfa_unpack() stores a table in dfa->tables
before attempting to remap a 16-bit table to 32-bit.

However, remap_data16_to_data32() frees the original table when
allocation of the new table fails. This leaves the corresponding
dfa->tables entry pointing to freed memory. If the unpacking then
fails, dfa_free() attempts to free the same table again.

Only publish the table to dfa->tables after any required remapping
has completed successfully, so that dfa->tables never contains a
pointer to a table that has already been freed.

Fixes: 9208c05f9fdf ("apparmor: add support for 2^24 states to the dfa state machine.")
Cc: stable@vger.kernel.org
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/match.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index b2a4bee4e3939..e4ef1057e2c06 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -397,7 +397,6 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 		/* check for duplicate table entry */
 		if (dfa->tables[table->td_id])
 			goto fail;
-		dfa->tables[table->td_id] = table;
 		data += table_size(table->td_lolen, table->td_flags);
 		size -= table_size(table->td_lolen, table->td_flags);
 
@@ -414,9 +413,9 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 				if (!table)
 					goto fail;
 			}
-			dfa->tables[table->td_id] = table;
 			break;
 		}
+		dfa->tables[table->td_id] = table;
 		table = NULL;
 	}
 	error = verify_table_headers(dfa->tables, flags);
-- 
2.53.0



