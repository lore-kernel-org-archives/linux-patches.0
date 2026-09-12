Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537C7378D8D;
	Sat, 12 Sep 2026 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205422; cv=none; b=ah0zubd4uc08CuvWMK/zps3H/NA0U6u+vdZ8J/tyx47RTuOfC4SJf9v5y2GID/WQuA68+q8i7YUpZltfTMUnTclp8zz8pk/Ju9a7RzbfeuhpGFlB/CJlr0rXMLI2GAFLOm65TvTh52THr8S9ov88M4g0LMY3QsDF0m8+cpcdaI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205422; c=relaxed/simple;
	bh=bXEB8OrMJaLTRvSvgFQLOPxlLJ3H00R3fzXhk8K9N/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKoZXQxMWOzUKdq0XN+lQOrZ7MkUhuBudVRyK4pcxhG+mkwooRPxv9ceFQsnLlxcwYONZxX9h9BWQGurSFnXWH7lcN+xq8VXnCOtzvM8SWT5ymnJzFc+CdRWks3xauGGGLc+v5UHPhbDuiRtWRiozeIFhKHsHrG8Iy2p2eNP5qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=le83HS0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le83HS0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DC71F000FF;
	Sat, 12 Sep 2026 09:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205421;
	bh=tuK0D07inE2k9KcddkhWGlBcEAt+a0sLdh69wmoGr6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le83HS0dmRtv0U01Ca5eHX6y6tHeUuUyy/DnHDsEZZySJcPplqX4JGKckXyVihD8Y
	 8licohZPF56EBGfwl+11YymR3mNfUf7EGL1BAkhgSZbOS9GyYohVqmhCY5Zg6NOIH/
	 pfXiF18wfYdz0FvjVNQ5hzFiEvmGMpBspb+/BtTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1813/1815] Revert "esp: do not unref managed frag pages in esp_ssg_unref()"
Date: Sat, 12 Sep 2026 08:59:23 +0200
Message-ID: <20260912065731.604841912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 0fda52de8bbd4ca9a852c8a7ef6536cf82bd71fd ]

This reverts commit 21697720ff43b8dfa25b8e8d9ca7f56f4597fc80.

The patch does not fix the issue completely, so revert for
now and wait for an updated version.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 7 -------
 net/ipv6/esp6.c | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index fa1710e27e505..dfc81ee969ae0 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -104,13 +104,6 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb,
 	struct aead_request *req;
 	struct scatterlist *sg;
 
-	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
-	 * per-frag page reference, so we must not drop one here.  Mirrors
-	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
-	 */
-	if (skb_zcopy_managed(skb))
-		return;
-
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 7d216b9c59f04..296b57926abb9 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -121,13 +121,6 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb,
 	struct aead_request *req;
 	struct scatterlist *sg;
 
-	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
-	 * per-frag page reference, so we must not drop one here.  Mirrors
-	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
-	 */
-	if (skb_zcopy_managed(skb))
-		return;
-
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
-- 
2.53.0



