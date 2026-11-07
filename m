Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061661;
	b=q0vCXgWG+/qv5DXWDRvPlYoWf7U/M+WOekPhgA4T4UIjl8O7fTFz6JUDLT9GuwzZ+KZM
	 quOURPTEE9/87eaKESnwlR3KbGnOcuWqWSC17EZP4IA0tj3W4GuC2L2b83fpzZCKX7u9A
	 xlRKb1nDlkUGTFEdqp7W3WoKjZtKRj3VNrWm8DOMbvWat1LE585rJPAVDFAyXwmLlSyGf
	 EcoQb60Q0JXKGm7bG4X+yMTndgFZBw9A5Gn23ZRxS/PwtFIF09QoZMXCLFKjjNMINSj22
	 ElNJDWB4ynq8VSvq+b0T1fGyOmqBzCm6HKiAe6xkfc3qKk+BkC/c/dRTD8USCur27MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2d4IgPQP6H/DdYenbvw3Ti6NBx717YSP4QdHk07UhE4=;
	b=Zs7ju28ZY7lHTm1l3UIDq2XMHkwH7m7XjJJ6hZFea0oihtDLlykJp4sZIR5oUsveUmn2
	 JLfa8tgE8rqL/yT2ZxxcjjkAUD37ybr8mJk8NRlah9eCUsZTxC1srWcj8D7OGgKtGWROL
	 x0sulaUOD11BNLLch4dxPsC9Zx1MXHQjzIzRk78AwegLHzKjMXRY4SYnFDx/U+9eZrlg9
	 poTrRS2dPR5fFPQRDIk7RYn5AuqQqTUKoEHgZ0m4P4IXwqx+xuHmkLXE0KF6tAWuzreGX
	 i8vq2fsOj0nj/69U33EFXMbhY3rbje8agRdWziY6EpoGA5sH8JnH1G6rdLWq3kLLOOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9+8XXtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874B4606A32C;
	Sat,  7 Nov 2026 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9+8XXtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345E31F008A2;
	Sat,  7 Nov 2026 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061661;
	bh=2d4IgPQP6H/DdYenbvw3Ti6NBx717YSP4QdHk07UhE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9+8XXtQuSfB5+ca3KEz3QiBpeJCmKCG4i4MyaLoo0LeMb67d7SsBhCcYTHgdW3X7
	 CocJsNgDLmEhwoV/FD18GmZn5af18ApQRFyjtJoL7w1paOHUAzSRzt1THydkBh5wMq
	 ke/wJ/WZIO3ju7SND1HWdM4q9+zbDr4nQMUoLo5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0719/1536] ufs: fix ufs_read_cylinder() failure handling
Date: Sat,  7 Nov 2026 08:45:35 -0500
Message-ID: <20261107135017.691268408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 0bfd3e1078c537cd66a8addb1c01835de4234a4c upstream.

1) ufs_load_cylinder() should return NULL on ufs_read_cylinder() failures.
ufs_error() is not enough.  As it is, IO failure on attempt to read a part
of cylinder group metadata is likely to end up with an oops.

2) we drop the wrong buffer heads when undoing sb_bread() on IO failure
halfway through the read - we need to brelse() what we've got from
sb_bread(), TYVM...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/cylinder.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/ufs/cylinder.c b/fs/ufs/cylinder.c
index 5781c7db97276..b930ee1cf8530 100644
--- a/fs/ufs/cylinder.c
+++ b/fs/ufs/cylinder.c
@@ -26,7 +26,7 @@
  * Read cylinder group into cache. The memory space for ufs_cg_private_info
  * structure is already allocated during ufs_read_super.
  */
-static void ufs_read_cylinder (struct super_block * sb,
+static bool ufs_read_cylinder(struct super_block *sb,
 	unsigned cgno, unsigned bitmap_nr)
 {
 	struct ufs_sb_info * sbi = UFS_SB(sb);
@@ -46,9 +46,11 @@ static void ufs_read_cylinder (struct super_block * sb,
 	 * We have already the first fragment of cylinder group block in buffer
 	 */
 	UCPI_UBH(ucpi)->bh[0] = sbi->s_ucg[cgno];
-	for (i = 1; i < UCPI_UBH(ucpi)->count; i++)
-		if (!(UCPI_UBH(ucpi)->bh[i] = sb_bread(sb, UCPI_UBH(ucpi)->fragment + i)))
+	for (i = 1; i < UCPI_UBH(ucpi)->count; i++) {
+		UCPI_UBH(ucpi)->bh[i] = sb_bread(sb, UCPI_UBH(ucpi)->fragment + i);
+		if (!UCPI_UBH(ucpi)->bh[i])
 			goto failed;
+	}
 	sbi->s_cgno[bitmap_nr] = cgno;
 			
 	ucpi->c_cgx	= fs32_to_cpu(sb, ucg->cg_cgx);
@@ -77,13 +79,14 @@ static void ufs_read_cylinder (struct super_block * sb,
 		goto failed;
 	}
 	UFSD("EXIT\n");
-	return;	
+	return true;
 	
 failed:
 	for (j = 1; j < i; j++)
-		brelse (sbi->s_ucg[j]);
+		brelse(UCPI_UBH(ucpi)->bh[j]);
 	sbi->s_cgno[bitmap_nr] = UFS_CGNO_EMPTY;
 	ufs_error (sb, "ufs_read_cylinder", "can't read cylinder group block %u", cgno);
+	return false;
 }
 
 /*
@@ -166,15 +169,14 @@ struct ufs_cg_private_info * ufs_load_cylinder (
 				UFSD("EXIT (FAILED)\n");
 				return NULL;
 			}
-			else {
-				UFSD("EXIT\n");
-				return sbi->s_ucpi[cgno];
-			}
 		} else {
-			ufs_read_cylinder (sb, cgno, cgno);
-			UFSD("EXIT\n");
-			return sbi->s_ucpi[cgno];
+			if (unlikely(!ufs_read_cylinder (sb, cgno, cgno))) {
+				UFSD("EXIT (FAILED)\n");
+				return NULL;
+			}
 		}
+		UFSD("EXIT\n");
+		return sbi->s_ucpi[cgno];
 	}
 	/*
 	 * Cylinder group number cg is in cache but it was not last used, 
@@ -205,7 +207,10 @@ struct ufs_cg_private_info * ufs_load_cylinder (
 			sbi->s_ucpi[j] = sbi->s_ucpi[j-1];
 		}
 		sbi->s_ucpi[0] = ucpi;
-		ufs_read_cylinder (sb, cgno, 0);
+		if (unlikely(!ufs_read_cylinder (sb, cgno, 0))) {
+			UFSD("EXIT (FAILED)\n");
+			return NULL;
+		}
 	}
 	UFSD("EXIT\n");
 	return sbi->s_ucpi[0];
-- 
2.53.0



