Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051789;
	b=W/MvJ3nrVlAi7t+SQLakiHshpDeH1/kMn7cBKwoHDWU84geUD/MTsR561SiJbQcTQY2p
	 Vo5nUfGsnWfhlKJaZmRCRbkOuYh6aN22eT1BRCEALG8EMNFZJ1dcZ7xWbAF8jCLXM18bA
	 AHeeSOp64ZLExWHVQlKzDf3lKZjbvD5f+YUoGUMAWpnfMWRaG+v4mBmDFZa1a0UG3NgG4
	 qERXZ89owALZ2mDRwxP8v5RR7C74CgYdWkiJVygo6qs+pD+ZzB3IJ5MvuLBczw8zxZIwF
	 OUCV/oG6MbT3lWUMMZpnb1a89B7hhdTPfzNYkmTiC0icf4s/mEzOePHPdBn3M+Y/LVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wjT5g9MTGJlRNUrCTYa/qsrEgKYIBIxFiDVl3jbgmDM=;
	b=mXX9otVzd6mXIOB53viyN25k7qWAIg7obST938XNyrIDOKGHMP/GRgG7IDbWEkEADxEo
	 ookoYbAGVNyeSNuORHGqLAcPd4I0JScVrXF1AaN36RJWyX8vQ1QrsXQk3XrkSN8D030nG
	 45iOsdXwJw2ay0j5ZE9Mmysed9E1OVYNEhH142MhKF+q5Q7MLenIwe08Kq4oFibbIAu8p
	 XOfWyai2lcd3SmWXkyIFJTcrsNYs5XO0crnPniUErmP6p+1qreCOIWeQIhIRJXj5+UI0V
	 V5KSdOlkzdCZksNFAXS2wVK35gRcvZ8eTHye3/oR1gw7wZRRqb+/hb/8IKmJf9B2UzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLZ2q6Vn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15464606A330;
	Thu, 19 Nov 2026 01:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLZ2q6Vn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650DF1F000C4;
	Thu, 19 Nov 2026 01:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051788;
	bh=wjT5g9MTGJlRNUrCTYa/qsrEgKYIBIxFiDVl3jbgmDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLZ2q6Vnq9aY7lAD1FURcY77yc4b0ZMwj0Lcdi76MHcTmHs01STjaN1fKaHizYwDy
	 BMLHyadBulwznCHYO0zBu20seJXg5dPhu6WNZmamzLz+kiXof00QPX1EUaa0WHUjzs
	 IZuscD4QK/D8Yufymtfi9GuvGB26sTe7cXp/NwGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0333/2214] ufs: fix ufs_read_cylinder() failure handling
Date: Wed, 18 Nov 2026 15:33:29 +0100
Message-ID: <20261118150023.833536340@linuxfoundation.org>
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



