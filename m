Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B46A13175E;
	Tue, 23 Jan 2024 00:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969092; cv=none; b=aUpkbJtB/B2bw8oYVuAB7cECMFJ2106+uJYy0LYcC8aHAyuJVHVqQE3xybzuSxVJksfNPQOo6/dthSvE5e59BMoJXZS6evk8DefNLwC9FMR+63nKNGib7VP4pYTwukF7nigyX6Qcka7ohjet1OvcjIZBIb3yCGIu/ejsfJa38oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969092; c=relaxed/simple;
	bh=vGwAIKp+fhLrnN2IeLI1sJgWizJ4fglpOxI/jaSpMEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBQCNLVRdpBGkT4f2Doml5blxs0jN8JrcpDLzkXXEj5rPFvn5/rLGQD0hhFP4gp6OcWjlBCPdjhIKRkpSj2dr1Iq8KyadWENqa2b+w2a523GqGHMubozbReKC2oB4Mdj4OFyL5BXY3ScvFuV45GSDzpGeVWCX9bQ2jHaX/g9SWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4ho1xwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4ho1xwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9481C433F1;
	Tue, 23 Jan 2024 00:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969091;
	bh=vGwAIKp+fhLrnN2IeLI1sJgWizJ4fglpOxI/jaSpMEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4ho1xwvOBLHXLgOVCW6seY2QSw++vyV/I5aTb3oM7RU0jUumaeIhruVAo4Db1HjN
	 1WicxQuIv7MImW/asE2ZuP42g5dyyUU22Np1I5Fs5MyLKUoGQYS3yImUjFmUSnMKi4
	 RPrc12mbYERZLYRROXNtwFAtFNTqXXSo4klBzs4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 016/641] powerpc/powernv: Add a null pointer check to scom_debug_init_one()
Date: Mon, 22 Jan 2024 15:48:40 -0800
Message-ID: <20240122235818.619927077@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 262cd6fac907..748c2b97fa53 100644
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



