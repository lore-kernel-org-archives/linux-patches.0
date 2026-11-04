Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829020;
	b=4fOH3R8whIND07eEt+UBofSa6Z8p214t7NYHlhkOpLUGttXWpuazULfCuS8VpwQxqv2M
	 GeL2wWZmbFWqo9O0HA17jRL3A0RupcsrDA5Ra9q39ubrpjUFHLvatBSswGd1N2A8r6vlU
	 7DmKBPosPZNi8BHp0SHHCIzm7Z9H/ZV4KzbXn2k3C9g/lGVx95kH12qTKLmyX1tNNHkl8
	 G7aYDSHk6p/t+jNQXFlTQUMli8wyGGLKjP11fZWfJMXO/4h+e4PmDA8N6Duw3mQXW5DMO
	 0hODF9J95Z3jXKHpr5jmBvYFlr7E52jCYYL8bxhMXRfcMYULXQ4RZ5ixEjhwjSscqSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H5dQIgjYkShDyjf5znICFSRiH1eU5/uVz51feRSDN4Q=;
	b=Mxaz1qO3e/BYDO8ki1P12J3MhU6uGmBkmPoI91d8bETyUgSUE54lAfUaUxyMo/H+L699
	 zH7PqANcYzbQ5wdGNAD04ond3woHHenaxrjWjgmmPLpyPIvFQOedTaflJwLSQR3XRT3Jw
	 wRvQpfWpL0mxLJcXJ80nt5Y9TFIVA2dpWdMJc8pe05likvRmPuVEzU+4M1tvFhByldDJS
	 AJIZRZSA1pS0TbcMJEDVpH/GrNpGWVCAjMbNvI8SYYPAODFV6R+AolOD3jcIYdBz42cFn
	 0zVKL398fJ5r900G8Oxp6AmRNBYqgeyRy3ERKh+h93LQZS4bisThJuj1l3P0zkaymdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tDhjNt1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626A607074A;
	Wed,  4 Nov 2026 21:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tDhjNt1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F241F000C1;
	Wed,  4 Nov 2026 21:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829019;
	bh=H5dQIgjYkShDyjf5znICFSRiH1eU5/uVz51feRSDN4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDhjNt1gPx7GEgsh4wXeeO4N9WI2PHALQ2v9vEPc/BSY6ZJMNvm6t10AkTl4viWg2
	 zqwqZcpX9C9xpw4JlleAavV3IFEleZ864GKSmGrJ1jIO1CJiBzG7pmg+766MKcmDSL
	 lkV2FA5+8EnF6KZOAEl+CDO/JhRlIsbhwtv4t488=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 353/547] xfs: clear set[ug]id mode bits when zapping attr fork
Date: Wed,  4 Nov 2026 16:08:57 -0500
Message-ID: <20261104211048.304291452@linuxfoundation.org>
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


