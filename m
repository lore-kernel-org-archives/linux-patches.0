Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828961;
	b=25bASjoAzdUlXAoVa599aFd3T0Q8p3gfIgDHjC5vkByXYiy/uGrDfWbMEd3AOBSEfU/I
	 uuOdre/F6jIcXNFC6Hu2RLgwAeS9clWN6HLQnU5GCu5+Sm5BSaXbggOGxFzcpIiwaqopq
	 f2PeSy/4xS5OkzgWDA/ZstR3tPVUJtnBVtzd/m/0ptLpPJx+arGpl4uvtHl8T1V8CxVJm
	 lZivdw+0tiPQ5Wit+3z3AhP86fLr9dEaELb2ABp1xgZJwm8mxPZdQt2YzZzi+QM0sIuuF
	 sy8sF/tYs8O+2yt+GLXOwtNWZ+75ld263u+icQqBSxz0DLxsX+gMgqtO/ASrw6dvwuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4xduEtonw52mk0KZMRBzd8EPGrgWjH7A20T0i88kJwc=;
	b=w1O4zpBn0GnIA9YAgqrx70Oi6j5sdwY6qdgLPBKtQ8J+ZZ10w1tEVWVrzYlxoGQTyeay
	 J70FbSC8wXJP/zQSlyFJVI2e7hYADPAP+9MRR3hHbYKaZQN0FAHhcqsZSlkIDKPdhym4T
	 aV9escX5GNAWbbPZ5AZ6MS2vCz0txmLzGSZ+uGAP8zoJv8f86ICSHMzi2mddJUUFRPJI+
	 DQthxNM/UZzJtwqwrrI1N5fi+OnVu4YIze+Mmo/a0Y3SECrjuFdPO1PquOxRk6coZqfSs
	 +Cbpy2qCMCYbFWDGRvjB8fIH1+0gYluERQEbBalnaN+7kg4NNUjYP+ZXAFHbLNKioyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PeifXugn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691D76070433;
	Wed,  4 Nov 2026 21:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PeifXugn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061B31F000C1;
	Wed,  4 Nov 2026 21:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828961;
	bh=4xduEtonw52mk0KZMRBzd8EPGrgWjH7A20T0i88kJwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PeifXugnm2xXh0EGyvUpnjxqzWN6R+w8pA7IkhebFEr4ZsAlmtnfVn69iwycFAeXT
	 vHLpZmyBQkbwJuBEdu40PdwXnX528taDE/WOsX9MhmCmivNh4awNX6qmPbkHQV3ABZ
	 FETj+NSU94vK9PTXB+b7Xf4MqEZNdHPCLp0UGMTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 355/547] xfs: dont allow sm_agno for non-group metadir path checking
Date: Wed,  4 Nov 2026 16:08:59 -0500
Message-ID: <20261104211048.367696063@linuxfoundation.org>
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

commit 20c5a56bc4f2329872d21561e4a2d4b8576004c9 upstream.

LOLLM noticed that the metadata directory tree path checker accepts
non-zero values in the sm_agno field for non-group metadata.  Make that
case return -EINVAL.

Cc: stable@vger.kernel.org # v6.13
Fixes: a74923333d9c3b ("xfs: scrub metadir paths for rtgroup metadata")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -129,6 +129,8 @@ static int
 xchk_setup_metapath_rtdir(
 	struct xfs_scrub	*sc)
 {
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!sc->mp->m_rtdirip)
 		return -ENOENT;
 
@@ -176,6 +178,8 @@ xchk_setup_metapath_quotadir(
 {
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!qi || !qi->qi_dirip)
 		return -ENOENT;
 
@@ -192,6 +196,8 @@ xchk_setup_metapath_dqinode(
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_inode	*ip = NULL;
 
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!qi)
 		return -ENOENT;
 


