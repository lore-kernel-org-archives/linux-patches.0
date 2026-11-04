Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828899;
	b=fmQV5Vl7fpEHLrUyrdVd0Xi6ZKU9zFk/GyUXAcdVgbMVAcjSjjEcSZCLrCrLUV+yW45X
	 KYJYut2HwNxU02Wsni2yslafHtS1yAWtdub6ZEdDa3vOJlfIRKyJxyC25T2Cx9ykkxSii
	 lWL1830BRDVl/WUjap9IYvh30zZXsw+/N0jXYXG8qKu/oWFbpoyEsPT/u1qyVTpK30oAP
	 c/iEy0UPiC8KR4LWSrnhI7K6t3swaN2hxueTRVxEjggrHpZzPkZck2xwZmP6vWZdg5nIv
	 I6xZUN+dvFRhoB70dGBY/XhPb44UlgmzMxl8cvzmwCjrE3AstfxLTILeMuAcj+PDzgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GP6O6Ep7CYi0YtKjmKx4n8ZgpZHpPNxLVcc3X5eWLzA=;
	b=L82N6QJvCdawUfh/jp2ciU5S39+Qllh4as+8sc//3tkow1O/ZWLWj5eM5DACXNd/wySw
	 PDDl6FP8MgiYEnQk0AHT0DowZjnQ25M6kuafY3ueiOkcbXGeWN+/CE/STOKRPjy39ZYwi
	 apwonuMIUSqt9MCDDU5I4hONpaSi6bxluILP8RUHjAwJxzbizqT/Oa/5WwTnQgH5arYvM
	 u4QQTezllF7KxrlM5ZHMU8Avutno4nrn8n4yHIKpKreuZHIDM0NF8NowmaPXyJN5vFuuA
	 r2YZdHGMaUs4+kc2fAbD4vTm7jvln3AfBBbwX6q9E1U6J/TzScUmd2FrZ0ua2Ekr8Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UTI6VX2+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313D6606A33A;
	Wed,  4 Nov 2026 21:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UTI6VX2+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA7C1F000C1;
	Wed,  4 Nov 2026 21:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828898;
	bh=GP6O6Ep7CYi0YtKjmKx4n8ZgpZHpPNxLVcc3X5eWLzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTI6VX2+MkthGUtGNJzupovwh4bTi1ST3smAk40lZVHmGNrj/jOr4NOlIdlHjLZS5
	 WQIV47IlrdLp6KVIr94t7TH9HZ52w8isn9fS1O9oAsffV15B+M5p8w/R4aYbS6OvjQ
	 hXRGpHsqlbq8FvHWqd4kAw8FA7wvg9MiAiPvZbwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 313/547] xfs: dont pass iget failures up when marking ondisk inodes
Date: Wed,  4 Nov 2026 16:08:17 -0500
Message-ID: <20261104211047.105292922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 7f5e8bf335e5e257fb82cf5b3521980ded60e863 upstream.

LOLLM observes a couple of problems with this callsite -- an ENOMEM
return is completely ignored and a subsequent run through the loop body
obliterates the return value completely.  Also, an error value
indicating that the list is corrupt can get passed up (thus terminating
the repair) even though we can handle corrupt lists.  Fix the callsite
not to have these problems.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1325,8 +1325,12 @@ xrep_iunlink_mark_ondisk_rec(
 		 */
 		error = xchk_iget(ragi->sc, xfs_agino_to_ino(sc->sa.pag, agino),
 				&ip);
-		if (error)
+		if (error == -ENOMEM)
+			return error;
+		if (error) {
+			error = 0;
 			continue;
+		}
 
 		trace_xrep_iunlink_reload_ondisk(ip);
 


