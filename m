Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BA24657CD;
	Tue, 16 Jun 2026 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625641; cv=none; b=lf+BZsAN/NqWil5socXXGEH5Luf01b7yA8Wvl0ktfhBf3qkd6h4skj/4k2VwraRc33mYUmHTiYvegWy4R7s8dqn7EwZnvVd1D7yM8FawyiE2tTve/tsiVSPtDjHGvBON6A89O0E0c1KKaLdBkBndtESTZYT3qytCfQ3608hNQS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625641; c=relaxed/simple;
	bh=yWN4QZFl2DLHoYnayDS9GttKQLJ2Za6AeDxWpGXgoww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stVVoFWU1i4uSCYfXX6x8umhEUMOVFmRagwkPJAa4XDE4MOkn6J39RNWig2C6juADeZXN6zHASMGcWjslb/+y97okby0FReq+gAvOwo/0iRE3jfiNKZEugECg1zH/H0GORrTt4bMrS/gdzFRF0g2n05KTFeIXjTiEuZvVOuzgVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj23G2lA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj23G2lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD581F000E9;
	Tue, 16 Jun 2026 16:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625639;
	bh=JIrW8RDabOPgyrcmK6HeheU3DsKo+BUnFIR/nZIgAlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kj23G2lAg5WLmaF4ob2W9OvAUAGc6cwOiX/xLYhgXtl7rdvBUgYt+nMsdCN/+wHx/
	 KAB2CC2w9tDj6lmQT4DXO1RsK6FAt4iTE33q3Yf2rvOPvTDhQwTkToRoorl6gfOoqY
	 nXbyVeMEJTg1Ssm7cgVi+WT81SOcowwIVXghIiJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takao Sato <takaosato1997@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 172/325] xfrm: iptfs: preserve shared-frag marker in iptfs_consume_frags()
Date: Tue, 16 Jun 2026 20:29:28 +0530
Message-ID: <20260616145106.419104370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takao Sato <takaosato1997@gmail.com>

commit e9096a5a170e7ecd6467bc2e08668ec39897cda7 upstream.

iptfs_consume_frags() transfers paged fragments from one socket buffer
to another but fails to propagate the SKBFL_SHARED_FRAG flag. This is
the same class of bug that was fixed in skb_try_coalesce() for
CVE-2026-46300: when fragments backed by read-only page-cache pages are
merged, the marker indicating their shared nature must be preserved so
that ESP can decide correctly whether in-place encryption is safe.

Apply the same two-line fix used in skb_try_coalesce() to
iptfs_consume_frags().

Fixes: b96ba312e21c ("xfrm: iptfs: share page fragments of inner packets")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Takao Sato <takaosato1997@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2170,6 +2170,8 @@ static void iptfs_consume_frags(struct s
 	memcpy(&toi->frags[toi->nr_frags], fromi->frags,
 	       sizeof(fromi->frags[0]) * fromi->nr_frags);
 	toi->nr_frags += fromi->nr_frags;
+	if (fromi->nr_frags)
+		toi->flags |= fromi->flags & SKBFL_SHARED_FRAG;
 	fromi->nr_frags = 0;
 	from->data_len = 0;
 	from->len = 0;


