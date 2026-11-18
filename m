Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035326;
	b=PvyBIur7DjajtN7aESODdTnRe8m1H3W+vHrDZqTdjlQKgxTHGXQuKsfD0/WZeKEBhEzy
	 Y3qJaMHSMndmBGDo9F9UNN7zPuCjn8AcvpozWjqX76wr/GE0JGd2Kqbsdl01y/+CBbJGv
	 k4YJcZRg0EMJ7A/xxoXAOQBXS+gawbouLGz8bHfCOHL4BYDKaQancvkoWgTa5x6ci0iLJ
	 JK6HL5hVWbaeZDeigctHW3qd/V9YUmuqWKacuZ3jLmvqqmEkYqfaNpbqBDFkyvWtATo19
	 w5H5gWFlxgHfyZ8muB0dgx74yNjuCAmrOm4LSIXba5EYTHYHc6IxvlGN3pF5xVoFALw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nNwZbxkt/9vRxVnFLY97KERc901fQwYxOWgUzJnHI/Q=;
	b=SFHtb5ooMyJvw99kWeiDVAX8mc4ZtE16c2g0P35jgInio/iHjYpWudulr9BZBofUaFa2
	 BLzARxkkSsi2v7E8ObchuO1xn7zCLEo2bXhJ9VS2ZXA3VCokW3GCmjhGomDnOz4pgMGeu
	 64HEYIGCFOqL9y8GOZgFQC5n5wSV3pzrr4fW6gurx2cBhSNm/ClVDQdkdnEPS3RAv4f6t
	 uKUyK/njohFCibvxc1MuhGlW3dm/vM6RK9641ArWQgdBURiZLyHdr0Y4afZaqksnRHO+7
	 yi1Vg3G1+lW9FQsX/31/M92gkQuHeiitLhK8ca1yFYg7sjfDTthpiIZG/Clvno/uLqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6PEsQya;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DA6606A31C;
	Wed, 18 Nov 2026 20:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6PEsQya
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78F41F000C4;
	Wed, 18 Nov 2026 20:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035326;
	bh=nNwZbxkt/9vRxVnFLY97KERc901fQwYxOWgUzJnHI/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6PEsQyauoK38sSugO0tfzQ3MzqfHMQ2YmN0e1p5O0v/UE8V7BetYfGvDtyCfmU//
	 dPqctLxiG+SUXpApyEOos6/nzaT/svCFGm1gAoeORwvq5IHl969U+1vB1fA0rJAHyC
	 axT8JBKFQe3YW6aGzNjtjMOxap+kEFBAPRg7qjac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0664/3318] ufs: fix ufs_read_cylinder() failure handling
Date: Wed, 18 Nov 2026 15:21:26 +0100
Message-ID: <20261118150338.007993947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



