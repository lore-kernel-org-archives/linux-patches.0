Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969E45BADC;
	Tue, 23 Jan 2024 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970481; cv=none; b=aIvCMlOQUqpAM9ZxK3z8Mb6Jm4BVhRWVSua1Vfp+gQtJFlcibukBMXzGSdTdkKoWCja22k2afip7Ff6zZugdSr6P5u+qpj8aGOJnkEYkdLxO5EaKMhlTCcEwyuqVtYp935udjoqskEdEV9HfeoWWDD5MfJgwOkQEWqeFyxYMp0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970481; c=relaxed/simple;
	bh=j15tt0mqxuUYt3rmnsktuc3h5c2s4ZsATRzk1DH0Yuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv7fLw1gR69QNJOrbSOiTNE86/ankrUga+Pq7rrPLhbCWPvhAIrlnCuPTKeNl210WfGF6c0ZJQzETNb5Kr18A84hFwExbEqZvegGMSh9JLk3sqaO8PiNaScWv2ANIvqCHEpOMPBmag3FPBIJwRvdelNvIQB6KQJ/f9yge0e6qD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NI6yjK8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NI6yjK8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6484C433C7;
	Tue, 23 Jan 2024 00:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970481;
	bh=j15tt0mqxuUYt3rmnsktuc3h5c2s4ZsATRzk1DH0Yuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NI6yjK8n5+NT00o4rP7j/rCxRLMKJ6zb/deZ+fVy1hf1Y6TB9wtfCVtBZVZHIzQE1
	 dHj5p05fRm3STE/uevj0ZC2Huvy6rvAghf3J0sxvhD9r2QaK3jY46ccu1CrecOzXXp
	 JSybbdSxlnFb8TJi9/feKv9SJ9b4FKADgqrKzxqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/417] powerpc/powernv: Add a null pointer check to scom_debug_init_one()
Date: Mon, 22 Jan 2024 15:52:57 -0800
Message-ID: <20240122235751.823552010@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



