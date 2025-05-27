Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE0227FD73;
	Tue, 27 May 2025 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364845; cv=none; b=DYObhDOD8C7kEMMU/QF2L3W4BuaGMIFxsrDyXluWOeygavooCbyBK8OwrPjtN6Q7IqSKRjQQy2HJgaiPzjNJ0sQpYfLXGKvYRlDLfVMNCxicG/g3XABYuXq6LHdYywDk6spvYTVrAmOFLw5V+z/tIFVVSmZvMv1njf1zYlAq3jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364845; c=relaxed/simple;
	bh=X10aKGSuOQfL8Goqge+OUG0Muxp4MqWhJdsVzbGycsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc3jHLuX3QI2Q60c+OtosPopHYN2SkMDO9r9GWlKz5wJtzg8L6cfZzrjPNMhRH4FazzoN5ZtXSGHQKgMmDGo18F/cAj5SSB2JCQ+HmJqjO7BF8aHl1bFcXDkl43Ua26Kw88syl/Y4F8RY/wyrWAPv3h+vI92CnHJRNd0+j9Qtfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXKYdMAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXKYdMAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974EAC4CEE9;
	Tue, 27 May 2025 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364845;
	bh=X10aKGSuOQfL8Goqge+OUG0Muxp4MqWhJdsVzbGycsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXKYdMABxuAjOLpg087ifBaU7fzXa9PEaDtx7tddNoBtmybCtqJmSbHOpC7E321a2
	 2EUzfepm0fSPc5x6Jm57ULj6M15d7TKX5+VgJ1Xh3LqzUUrQd8fNaDJ2+6NrVo5qRE
	 l6KwfjWMY995wSjuMm0SnjqZLj0uk2aSSgCeOGHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/626] thunderbolt: Do not add non-active NVM if NVM upgrade is disabled for retimer
Date: Tue, 27 May 2025 18:20:37 +0200
Message-ID: <20250527162450.880218735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ad79c278e478ca8c1a3bf8e7a0afba8f862a48a1 ]

This is only used to write a new NVM in order to upgrade the retimer
firmware. It does not make sense to expose it if upgrade is disabled.
This also makes it consistent with the router NVM upgrade.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/retimer.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/retimer.c b/drivers/thunderbolt/retimer.c
index eeb64433ebbca..3488be7620674 100644
--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -93,9 +93,11 @@ static int tb_retimer_nvm_add(struct tb_retimer *rt)
 	if (ret)
 		goto err_nvm;
 
-	ret = tb_nvm_add_non_active(nvm, nvm_write);
-	if (ret)
-		goto err_nvm;
+	if (!rt->no_nvm_upgrade) {
+		ret = tb_nvm_add_non_active(nvm, nvm_write);
+		if (ret)
+			goto err_nvm;
+	}
 
 	rt->nvm = nvm;
 	dev_dbg(&rt->dev, "NVM version %x.%x\n", nvm->major, nvm->minor);
-- 
2.39.5



