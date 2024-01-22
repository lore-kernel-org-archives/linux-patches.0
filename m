Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C37B12A17F;
	Tue, 23 Jan 2024 00:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968780; cv=none; b=eiqX+sZ5Ma8vouXMbpm3z9hv+4PUYd+otFz9uqalmiSTDdQY6wlcgXOi5MWjYRsgMuI2NdoVBPCN1UWsi0uAx73T2FK7MUioh9+oZWp3+w1ZYFKJiZJufRvWG3MynNvhf1ZaYNHCd49ffTkSpAMZtG6Ax+z0/0WYMa5WVT3ZVlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968780; c=relaxed/simple;
	bh=YhBnLkZBCWt88kmErgPjH4SgLOXPwZqKfmjiBJAw1Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E95OQTzyBvPfR3shAHSFz37Kk+qkvf9mTI0dK3M8XHktx7gHpYeLXc2nbVpGob8fwRLoYtym6b16K0ns3cVrJV88i1jLzIHxrbyO6HQJJRBft97qkCFNkmvY+h5GHPl/aDeVyjSOu+qcqiiFsm5iZAy9o03wUaecPfnUj4qptRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUPs1DVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUPs1DVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4743AC43390;
	Tue, 23 Jan 2024 00:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968780;
	bh=YhBnLkZBCWt88kmErgPjH4SgLOXPwZqKfmjiBJAw1Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUPs1DVVTaRyDsTHDu5TE84vYceKI2sgbTF1kViRC3Sy4Omxx0XC5pWYL8jqj1EWS
	 WlKdEy7J1/r+ZReMv7L3GPyxBcagO38V8bZlXeFyAMsg22M0vqXID4skuU6YB8K+yC
	 W0PhRf6yH7brgEkodmhEifR7aFNTGkKwrahAGS7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/194] powerpc/powernv: Add a null pointer check to scom_debug_init_one()
Date: Mon, 22 Jan 2024 15:56:17 -0800
Message-ID: <20240122235721.232125171@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fd510d961b8c..d5814c5046ba 100644
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



