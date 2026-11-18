Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019794;
	b=ZiQTZAswL0l0UCdM+j1QiXzFp2NJlvXmgTDODUfJJUZr/OgQlTeEPB/woqul+l7LQP8k
	 CDqKFvEVSsELkAClZXFUe3yd31sNJ5Uhbjv4NCFMT4Kxe8nigPivZFdeDSrA5bsfXtu1x
	 6lNUxT7biHisqFuqmH1IDlYTJi97yTBwUN+O1aJfJkqJPX8kBPB0Ww+cERC963RUVSvvJ
	 QHaaYEdhc4wYDybgq1PUx7b8z220VvHKNwrOXrl5hduakX/XlfadY6tIiCyt3fvxHtLwt
	 T1CJkYop/Og54vHN4pa7BTgoWvHWF0s9S0WW5dbRstAaFDHGTOeGkyjd7Q/bEEHSxxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ILoMiJWpFXquPaaZyV5U8dKXrf6iK4vQoRTvDOUqVbY=;
	b=M5iuaqliJe+X2gXNbPxBWZPesKnTP6gRyL15ZzXX/4feXdAXuF9tudzQyf1yJ0xy7Nrb
	 trf/fPLSb8D7hb/QhunjWP+k7Z+UklecrYMpJAQ7Bt7aQ43H1y6ue1klBhR0muH4BppE5
	 G3vZT9u3sE6uMYp55/X+53TRs6dC02w2ZolnRtKo2dqzeu3dMeU3xp9cytXtin+kmw6qA
	 0gSuA/rUFhsHo/BFQI7meEY38B+Uzgw474UsUXrvNWDxBhCz9Lgd5aJaGpuZZzwEBu64u
	 ENJ0ySWayBM5C9F+y2i9QH6n3cta0SFTLzyxa5qjt1pl0nI0XWKvq8dEDsJFYXcLumw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaOo17oD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23CD606A31C;
	Wed, 18 Nov 2026 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaOo17oD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2101C1F000C5;
	Wed, 18 Nov 2026 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019794;
	bh=ILoMiJWpFXquPaaZyV5U8dKXrf6iK4vQoRTvDOUqVbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaOo17oDX+wD0DLPYr59TpJVsApPeO05dAr/8g+lBhUJyfO10z5SC2g5G+mZphi8O
	 N4pCMLgsBEkrq+R59nn7sfnk1pKgxFfiGwrFs+yompB5oUx1JMNblZQxzEfUunScXV
	 mtUicHVebwOkIfWnGIoSNksetLo1kBeOKxXt1c4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1723/2651] fs/ntfs3: fix ntfs_fnd leak when compare function is missing
Date: Wed, 18 Nov 2026 15:49:23 +0100
Message-ID: <20261118150349.663482021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: liyouhong <liyouhong@kylinos.cn>

[ Upstream commit 86ba91170c03e02eee767d82a9a7f2048e51a5e4 ]

indx_insert_entry(), indx_delete_entry() and indx_update_dup() take a
finder via fnd_get() before calling get_cmp_func().  If no compare
function is available they return -EINVAL and never release the finder.

Jump to the existing out path so fnd_put() still runs.

Fixes: 3a2141b2f1c3 ("fs/ntfs3: resolve compare function in public index APIs")
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index bfc6d1f6d2fc1..9efd2ef024672 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2058,7 +2058,8 @@ int indx_insert_entry(struct ntfs_index *indx, struct ntfs_inode *ni,
 	cmp = get_cmp_func(root);
 	if (unlikely(!cmp)) {
 		WARN_ON_ONCE(1);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (fnd_is_empty(fnd)) {
@@ -2415,7 +2416,8 @@ int indx_delete_entry(struct ntfs_index *indx, struct ntfs_inode *ni,
 	cmp = get_cmp_func(root);
 	if (unlikely(!cmp)) {
 		WARN_ON_ONCE(1);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	/* Locate the entry to remove. */
@@ -2806,7 +2808,8 @@ int indx_update_dup(struct ntfs_inode *ni, struct ntfs_sb_info *sbi,
 	cmp = get_cmp_func(root);
 	if (unlikely(!cmp)) {
 		WARN_ON_ONCE(1);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	/* Find entry in directory. */
-- 
2.53.0



