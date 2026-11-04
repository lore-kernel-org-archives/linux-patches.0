Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831749;
	b=X4UurVg3Rbd4jns2Ly2F5cpO2J6Oq+/XqOeV0/5+FGUbzVFPCVuyJhLv+1akkQ526UNs
	 xb7TCMkRurSffm1Fl/FnMNWVTu+am6hIkjt+FZLoEBtEcNo0lBeJUwdBqDSewuSal5eBn
	 Cbnd9wK459VGwwoKwKsjG3K3Azznl9yb2fiZA0tjdkD4RkDz26s7E2fQS+ug7xgaDThY+
	 rzzwM1hg774yiStana68y3odd24ZXbKS471ZAV98bG7DaVbPU3Z894uZuo7IJmcRcGdNz
	 QPXqKFuXbaEzURD7CQSy9QDaGf0fyyZOKvKpGNCDwrckZttXRj8Ka26mykGczDCY6Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKk+aS1F+iWRPjo7U382UZZqjQtmHHBDBci8iTA/+YE=;
	b=d41tG2WSf20AGHCci5N7qedfB6QrLcdrrJzlQKWipHFErEZ9cdidFY90kjB4fu7R8kNi
	 y4r1ulGa3Q9MUWR+99U6e71T2pI9zeBpBTepfKGgDbsZeEBErmLZZv0WdVM0SjmOaxz69
	 TjKP2NvuDmBryqio8IkScWz4/bBeIln21AiRxdiDQKNt1mrod1SGis3xFpHPV+B2M+5e7
	 5rH3kohlIHXeEnvG+eoHr9or3PptY3FXFprL6ixxzCnTYTOCpw37HKXXgg0q/jJbXuY3R
	 3KWkgwThk691+906wfpyx3ayFROxzjPN70mczwUPHp4bkyTexPMAnnhR9Ow7ePoyNIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6k2SMyK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3946606A31B;
	Wed,  4 Nov 2026 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6k2SMyK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166441F000C1;
	Wed,  4 Nov 2026 22:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831748;
	bh=EKk+aS1F+iWRPjo7U382UZZqjQtmHHBDBci8iTA/+YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6k2SMyK9yPOwf9Cpvo80waN1ZWQlIb1Sdk++eEsJeztY4cWhHwFi0TOWWF2TiXIw
	 9SSdACiWTaHDXWcO0pdkeaN4VqD59vi9hv0zVVaAptxC16o5fSkf8vxZGbW2OfIMnl
	 XIsBbQkyz3k0UXIHKc4+fbJulQPKvGgzrIa2kKlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0844/1005] xfs: clear set[ug]id mode bits when zapping attr fork
Date: Wed,  4 Nov 2026 16:09:37 -0500
Message-ID: <20261104211106.962349918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit eb20a959760c21e3547cd811d0d9b0b29df98959 upstream.

LOLLM observes that zapping a file's attr fork could result in ACLs
being removed from the file.  Because we have no idea what we're
deleting, we should clear the setuid and setgid bits in addition to the
access mode bits so that nobody can access the file.

Cc: stable@vger.kernel.org # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1307,7 +1307,12 @@ xrep_dinode_zap_afork(
 	 */
 	if (dip->di_format != XFS_DINODE_FMT_BTREE)
 		dip->di_forkoff = 0;
-	dip->di_mode = cpu_to_be16(mode & ~0777);
+
+	/*
+	 * Zapping the attr fork could remove ACLs, so we clear suid/sgid and
+	 * all access mode bits.
+	 */
+	dip->di_mode = cpu_to_be16(mode & ~(S_ISUID | S_ISGID | 0777));
 	dip->di_uid = 0;
 	dip->di_gid = 0;
 }


