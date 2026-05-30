Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356A1366567;
	Sat, 30 May 2026 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160891; cv=none; b=so/wkxUhlX+aJA2YxaM+SCGKxhaWA3uiKDLO5KLEdfEfYH011ll4+2qgIOo0HK7OcMSSzE+6SjmdWmzRQECE7TiIxA/MzrLjUrUHNFEumEzIcn1ZIRrT02gy41Z2R5oGggmOIy5DL1KGrrJUV2wHPySdvK3xIK9UzuE5D5nUOzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160891; c=relaxed/simple;
	bh=z6n/aeRbdeqh5PGj9YGVUiyXyCAYwxoiGZ9pdHpZQm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ik6wrrGEd31yAC3khiytOWtaWeil/sWRsJD2Npzdzidi/vzybf6P6jiqdl3N5v6+yc7iD23ok08S+x9FZfoyPDnKFXWYEbiKY7xmNk7jGQc92qXyFugmWRMx4RkkXKSkg5L56aLwsaInSRCI85azyYlHDvzOXfVaN0YfgClxmRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3PdMao9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3PdMao9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8027B1F00893;
	Sat, 30 May 2026 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160890;
	bh=i6aZxCM6v2JJxw/tm1LKK+avZPJlWeUAepAka5yXnqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3PdMao9l18gjReqpSf79pV/zd8wBA4u+e4mWK1mcVbQUlJ/8xzSau0WG8Jg7btof
	 +jORgtvVkAKwr0PEkCzk9ue30b+4oDz1PlQxpkCG/SGMLeGxHpVC3JdWfn31sq7Su3
	 ttUlv0MVqjdqvVsmulNr4kE/mvFqqphG+oNmnPeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 437/969] devres: fix missing node debug info in devm_krealloc()
Date: Sat, 30 May 2026 17:59:21 +0200
Message-ID: <20260530160312.334961952@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f813ec9e84b4d0ca81ec1da94ab07bfb4a29266c ]

Fix missing call to set_node_dbginfo() for new devres nodes created by
devm_krealloc().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260202235210.55176-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 9d0ea5c14bc50..2b4f866a61db6 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -909,6 +909,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!new_dr)
 		return NULL;
 
+	set_node_dbginfo(&new_dr->node, "devm_krealloc_release", new_size);
+
 	/*
 	 * The spinlock protects the linked list against concurrent
 	 * modifications but not the resource itself.
-- 
2.53.0



