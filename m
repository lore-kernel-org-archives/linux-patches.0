Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2531221930E;
	Mon, 24 Feb 2025 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407830; cv=none; b=ib876Xy1J1ELQjwaIKGY7mpfpDRPq1vmme0snR4uyJsTYdhsRaICbZJ6P1VIYfAdf/FOBL3OH4VGGtBlGlDFWIQfAAoUa2UDGl64bjHb2AjCcwMQPV86sFWNkWsedA96OJj1sfZOgO6uSCSXnBojohvH8MCZXWggwwLPg2a7Djc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407830; c=relaxed/simple;
	bh=X5n/hGuvpsews2N/1WlK3iayPB/7XDv+1MUEmHUjVRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BA7HMpD23zoSJDff5udFxm2U/WhF+LFkZswt2BnPz30SBOZg5x45+VdcFA0nS1vPi+P2Ou5At+QiBLmYHuSFTXlB1ScH7h7xKfvxSDqGEpSN7KVE7JVj8A/BiBto78ObEe/ApeNWE13yn7eTaIfN52FfTt+1FVXeXIAWVHvjX4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnrDn4b2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnrDn4b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04B3C4CED6;
	Mon, 24 Feb 2025 14:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407830;
	bh=X5n/hGuvpsews2N/1WlK3iayPB/7XDv+1MUEmHUjVRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnrDn4b24AdNBnHHakXLFL7+/DYaFc6+K2wC2FOhEhv1BihVcggUyQV59OpUW+pX+
	 AVE9D+bGsKNGhxqL9mGA+FeyjroPbXz+If83MEjl3Ah/YSU7DiZ0O1W7S0X9L45WMZ
	 AqRcg+iBJi6RYPHUcDeDb5jzbHImNpKP6r15qWAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 021/140] xfs: dont use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
Date: Mon, 24 Feb 2025 15:33:40 +0100
Message-ID: <20250224142603.837722025@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 069cf5e32b700f94c6ac60f6171662bdfb04f325 upstream.

[backport: uses kmem_zalloc instead of kzalloc]

__GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
which isn't really helpful during log recovery.  Remove the flag and
stick to the default GFP_KERNEL policies.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -370,7 +370,7 @@ xfs_initialize_perag(
 	int			error;
 
 	for (index = old_agcount; index < new_agcount; index++) {
-		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+		pag = kmem_zalloc(sizeof(*pag), 0);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;


