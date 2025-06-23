Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AB722257E;
	Mon, 23 Jun 2025 21:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713509; cv=none; b=f1pzjRdGvLwnla6WvDyKWYVNahYVBI+qWWzJklBI9G5pn65geBvh5p2HnvIm8JeEkauER5L2xG5g/hXYf7IdcYXBzi8Drsq/cAqQHKDGVpu0UnyhGwaqGV7kT+z43f9f0Qr8YRpfMVBNjEGMc9yWY2KVqQuzHPPoN6dSyr7v9Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713509; c=relaxed/simple;
	bh=E93B4ZPeqLDUVQNzfJlxJeXZ/beby/EEtOd9ZL3yyQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyTDfoZd5despGkTpGkuBqwKBQ46SvdhfYMyYzCI2k8mI7AKDbeOQmHY7TAw9Ax6YbW7vVsPax68RYJvJGa6mCmVbYlA+t9vkBg7veFRgf2zetLMz57ZV0z6PHPOiw64dadLVjQ7bO3w9fwdDm6EG9UtIzrqV5O/uLRAnXjJRWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jgYTLqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jgYTLqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EDFC4CEEA;
	Mon, 23 Jun 2025 21:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713509;
	bh=E93B4ZPeqLDUVQNzfJlxJeXZ/beby/EEtOd9ZL3yyQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jgYTLqdgKJJ2Dlfy4EjQCYqtOQWmwgIge2QzGfU26MhrV2PyB0nDpil/Gf9yQA65
	 kBhXV0wzhBGWq1i63Uoyef8u3Aam+UMapDc8zF7RH6gr168c4jTu5BYnRvt3+PUVvF
	 CdiUoUbmGLly7CIqrG1VFucEKAb2qStr2K2OLfOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 351/592] xfrm: validate assignment of maximal possible SEQ number
Date: Mon, 23 Jun 2025 15:05:09 +0200
Message-ID: <20250623130708.795304810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e86212b6b13a20c5ad404c5597933f57fd0f1519 ]

Users can set any seq/seq_hi/oseq/oseq_hi values. The XFRM core code
doesn't prevent from them to set even 0xFFFFFFFF, however this value
will cause for traffic drop.

Is is happening because SEQ numbers here mean that packet with such
number was processed and next number should be sent on the wire. In this
case, the next number will be 0, and it means overflow which causes to
(expected) packet drops.

While it can be considered as misconfiguration and handled by XFRM
datapath in the same manner as any other SEQ number, let's add
validation to easy for packet offloads implementations which need to
configure HW with next SEQ to send and not with current SEQ like it is
done in core code.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 52 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 784a2d124749f..614b58cb26ab7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -178,11 +178,27 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay seq and seq_hi should be 0 for output SA");
 			return -EINVAL;
 		}
-		if (rs->oseq_hi && !(p->flags & XFRM_STATE_ESN)) {
-			NL_SET_ERR_MSG(
-				extack,
-				"Replay oseq_hi should be 0 in non-ESN mode for output SA");
-			return -EINVAL;
+
+		if (!(p->flags & XFRM_STATE_ESN)) {
+			if (rs->oseq_hi) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay oseq_hi should be 0 in non-ESN mode for output SA");
+				return -EINVAL;
+			}
+			if (rs->oseq == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay oseq should be less than 0xFFFFFFFF in non-ESN mode for output SA");
+				return -EINVAL;
+			}
+		} else {
+			if (rs->oseq == U32_MAX && rs->oseq_hi == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay oseq and oseq_hi should be less than 0xFFFFFFFF for output SA");
+				return -EINVAL;
+			}
 		}
 		if (rs->bmp_len) {
 			NL_SET_ERR_MSG(extack, "Replay bmp_len should 0 for output SA");
@@ -196,11 +212,27 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay oseq and oseq_hi should be 0 for input SA");
 			return -EINVAL;
 		}
-		if (rs->seq_hi && !(p->flags & XFRM_STATE_ESN)) {
-			NL_SET_ERR_MSG(
-				extack,
-				"Replay seq_hi should be 0 in non-ESN mode for input SA");
-			return -EINVAL;
+		if (!(p->flags & XFRM_STATE_ESN)) {
+			if (rs->seq_hi) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay seq_hi should be 0 in non-ESN mode for input SA");
+				return -EINVAL;
+			}
+
+			if (rs->seq == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay seq should be less than 0xFFFFFFFF in non-ESN mode for input SA");
+				return -EINVAL;
+			}
+		} else {
+			if (rs->seq == U32_MAX && rs->seq_hi == U32_MAX) {
+				NL_SET_ERR_MSG(
+					extack,
+					"Replay seq and seq_hi should be less than 0xFFFFFFFF for input SA");
+				return -EINVAL;
+			}
 		}
 	}
 
-- 
2.39.5



