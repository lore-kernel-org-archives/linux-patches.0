Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3578D7E9;
	Tue, 23 Jan 2024 01:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972145; cv=none; b=qe0bZsV4oYLGBfOtaYH5LQAnSyVddeg0L4lYRILhBWmQ912+vig7YiLrIBTEaLkRiKrrzzR9l1JcQfXY2ZvXOPgutQgR5iIv0SPFXWogi/i0wfzXvD6DhXZztKmlzs9DWE4gWvdPy7/jbZok4vTjyt18MoRVqvxXzsCLIh5Ymdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972145; c=relaxed/simple;
	bh=Ewfl3mT50+zYIiik8oL/eWTJypf6oSS4lTSnss/WgpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM1ORiWgOIbrf6JN6yC4V3ZLPKHvNt1iIUiJ5nYSdagTGlspxbCE/5G5I1GxX0EX8JOJzqKwuoEDiynrqKQDYBzqFr3UWdiq7DGRGNhSiGfoNLqT9jxsudW/p0Ow+TVGZmgvzuQQiDKpbDN6gBtbv5gK1s1VeBcgRXGiBeAz8SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtIljjY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtIljjY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CE4C433A6;
	Tue, 23 Jan 2024 01:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972145;
	bh=Ewfl3mT50+zYIiik8oL/eWTJypf6oSS4lTSnss/WgpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtIljjY1a9ebheH0xlYI3ecLLzoFLsUMFvO9gssmK5mf243+oIY3KlCJw/FxyfV7m
	 QAQyUNvoCiRZXwtr6AzEiurwYV3AajdhmccoN4BM3hC3soKqbqlikKMga0Rfyv2I+8
	 Vu028+MMmZBQ9xcAP4RJH9h1Sn3rqWGNB+cD1fOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/374] powerpc/powernv: Add a null pointer check to scom_debug_init_one()
Date: Mon, 22 Jan 2024 15:55:30 -0800
Message-ID: <20240122235747.191950960@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 9a260f2dd827bbc82cc60eb4f4d8c22707d80742 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.
Add a null pointer check, and release 'ent' to avoid memory leaks.

Fixes: bfd2f0d49aef ("powerpc/powernv: Get rid of old scom_controller abstraction")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231208085937.107210-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-xscom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal-xscom.c b/arch/powerpc/platforms/powernv/opal-xscom.c
index 6b4eed2ef4fa..f67235d1ba2c 100644
--- a/arch/powerpc/platforms/powernv/opal-xscom.c
+++ b/arch/powerpc/platforms/powernv/opal-xscom.c
@@ -165,6 +165,11 @@ static int scom_debug_init_one(struct dentry *root, struct device_node *dn,
 	ent->chip = chip;
 	snprintf(ent->name, 16, "%08x", chip);
 	ent->path.data = (void *)kasprintf(GFP_KERNEL, "%pOF", dn);
+	if (!ent->path.data) {
+		kfree(ent);
+		return -ENOMEM;
+	}
+
 	ent->path.size = strlen((char *)ent->path.data);
 
 	dir = debugfs_create_dir(ent->name, root);
-- 
2.43.0



