Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065577;
	b=WVOrORlaxAG2U1PLLc0bpcyPW/RwcLH6Q5at1zLfeXU+YV/0cUgyzVkWAJFa5sagouNQ
	 w4UKtTG6CVt+yRrvKmOx0owC0T/BI9KYb9J5eB+s3lUBvt1RDchFUmVYa3btSkQBEtLCJ
	 yJg90NdPh4iRvX6QRbbm6fBv3hCVHS4Phnd0e47plTgOYiTGEF8MAG5hAxezwwOfopeSa
	 uwqrZ26ZM0Zlnl112j0ug0/zZ1t9FZZU7rkkas9gOtxizhR0YRHA2Sh5NAfZkpx69mMWm
	 OaPwjfYcnSt87BTW0bmMvfrDlwmKD4eHvWJzSpQwrRFukJkadL6WrNOds96DoO6jk1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MipFZibjioSMiO9VjvY6WWaIXrID7dSSvXni6YGqmaI=;
	b=DcIq+7K4iu6Tgxptej9+cdM1iORdWPQIbD4HJD1rZHHbQzwzRP9IRjQ0dNq1nNCk1qle
	 ny4lxbBP2+4RQtJnyYpP298FGbB0cA1rVZ6K51j4Ek6d+Yh2WLBHnJRhkqe5vHN0t73vZ
	 J01qCAxI1SqPLa6JM1WNfTheUETGPumtgGC/6F69292EKfCUSC70q1rS4kD5ymWp2Tvqj
	 A3paNI3OY8OgEZXtQRO+mQxM5RrxB/+1ZUrtEthbBSRt4dkGxOeIdQoUDNDyw2zN5R9s9
	 zBrbytib4u95iUay32kFTOlBM6lRY9/vEj+E7x4+I6N30KRh9Wgw8ff7dROSTnQJzRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0Qm/0nbn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4884606A32C;
	Sat,  7 Nov 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Qm/0nbn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726881F0089F;
	Sat,  7 Nov 2026 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065576;
	bh=MipFZibjioSMiO9VjvY6WWaIXrID7dSSvXni6YGqmaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Qm/0nbnqPJPLseRWxW9ufwhrq+RZTLfmkd22Ht10nfiFvZFkNP2RMvSDlHKDRmXf
	 VIQPC432KNukshmyeKUEX9cC+7E1026OfmZ+rFrEnkBlqoBudvORPzQ24SlQe0ZLmH
	 aGGa+10zGS+9DtV4TddcJUYIwbB111aRrZxiUD0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1237/1257] apparmor: avoid potential double free when remapping DFA tables
Date: Sat,  7 Nov 2026 08:58:53 -0500
Message-ID: <20261107135013.502669713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 7713484f6a36e..ca30a4292c422 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -397,7 +397,6 @@ struct aa_dfa *aa_dfa_unpack(const void *blob, size_t size, int flags)
 		/* check for duplicate table entry */
 		if (dfa->tables[table->td_id])
 			goto fail;
-		dfa->tables[table->td_id] = table;
 		data += table_size(table->td_lolen, table->td_flags);
 		size -= table_size(table->td_lolen, table->td_flags);
 
@@ -414,9 +413,9 @@ struct aa_dfa *aa_dfa_unpack(const void *blob, size_t size, int flags)
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



