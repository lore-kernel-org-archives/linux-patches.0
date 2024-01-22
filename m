Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892A51C44;
	Tue, 23 Jan 2024 01:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974052; cv=none; b=YNE2oK7MbyPkEkPvSwXF2BBgQeHPvuArq65zbkyDn9XoLFg9RQ3uuzlWuD20TgH+0wpTK0TEfniG5E3NKT76R18ctxnhhMi0ZTQzFvdXnD4yqMWaJvJjxd1yLp+UVqlCbXCVG2FtFcIjaeNGOJb22F+Pa/nkLpj9EaTrdArQHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974052; c=relaxed/simple;
	bh=tdIedISinqeeB2X6xbUziK5/BaBh/upHO/1Cc0aEGq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR+B5xjK9AMH/cJrTc2knU+p0qXPTQpDwlbSdlq/YUqKPtrkPcYvToH2Ja23LAMDZAWntWzNJPABC7zIS7KMOwLcsxIcRSbOwIbb20I1uMIqIc8O5rVy2EKWqTk2dQpk8UDzD7mNMHEEAHR4aLWN6knkM7ZGTtWEWfNHC8yW56o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTznXJwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTznXJwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C993C43390;
	Tue, 23 Jan 2024 01:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974052;
	bh=tdIedISinqeeB2X6xbUziK5/BaBh/upHO/1Cc0aEGq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTznXJwPKmER/gDg8mi+YeAtkU6qR7YEVpQbycunZKzcgB7cVrhUNxfAILgRQCa/t
	 o724o7bDCY64tl+Z4HohT3dNm7T2FyBIJGhczUEFOOZ6d1HC9QKNsbAjdq5SzvVtnX
	 yrFI6gPkHcSjmBBS29ZEvvD64EeuDlDtyzzFBS3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/583] powerpc/powernv: Add a null pointer check in opal_powercap_init()
Date: Mon, 22 Jan 2024 15:51:09 -0800
Message-ID: <20240122235812.773468809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit e123015c0ba859cf48aa7f89c5016cc6e98e018d ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: b9ef7b4b867f ("powerpc: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231126095739.1501990-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-powercap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal-powercap.c b/arch/powerpc/platforms/powernv/opal-powercap.c
index 7bfe4cbeb35a..ea917266aa17 100644
--- a/arch/powerpc/platforms/powernv/opal-powercap.c
+++ b/arch/powerpc/platforms/powernv/opal-powercap.c
@@ -196,6 +196,12 @@ void __init opal_powercap_init(void)
 
 		j = 0;
 		pcaps[i].pg.name = kasprintf(GFP_KERNEL, "%pOFn", node);
+		if (!pcaps[i].pg.name) {
+			kfree(pcaps[i].pattrs);
+			kfree(pcaps[i].pg.attrs);
+			goto out_pcaps_pattrs;
+		}
+
 		if (has_min) {
 			powercap_add_attr(min, "powercap-min",
 					  &pcaps[i].pattrs[j]);
-- 
2.43.0



