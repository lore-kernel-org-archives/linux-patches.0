Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C5427B320;
	Mon, 22 Sep 2025 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569641; cv=none; b=bz9dHeMAv8gUZiqafxqMroDSkVo3RgsDTah8bcNQfNhAENRlNAEIw8n+3Fv/0PwztsFVApiLpbIOrrPJ2NwhrQ8FrT6RJD36IqBmtmouKZ902Mbo1HaJUEh4VVWhGvthJFD62NMySALlUa8VcefQkPMVDp0JaR61x8PIFEOns8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569641; c=relaxed/simple;
	bh=aVGAztniQ46RBPjK2LSyXI8wTj5fx4VZXyo2rgqeWy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz9rDFUEAO5Bukm8HTqFQe0PoFl4thPVFaFsXT/zzibDp6EstD/Awd2CZd2IASSKX8ZnPnSEvIqZLu74a4LSVE/1By0WtF9PRAFv5Vioi/Dkklx7Q/B0V0m8DH6yQ6A+Gh+mDunEUBi4zj8AmyyIJY+8X8bq52gA7fjZ1hpqSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kID8ngk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kID8ngk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16423C4CEF0;
	Mon, 22 Sep 2025 19:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569641;
	bh=aVGAztniQ46RBPjK2LSyXI8wTj5fx4VZXyo2rgqeWy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kID8ngk7/ClLArjUdo6NPHZAXTy+qjc5PxqKwPUl7yjosNqZ3f91yZehOCVphD7hF
	 K/YpdIQmiMycQNlpoOKT7SyA7g4FlMKFDF2jETSnuAztl/tsoZ9EAdlU3ULFxFuhtJ
	 aQl6B9pomdNu8kklhBqaCYgustzySZxEOfnY2b20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuling Ren <qren@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/70] bonding: set random address only when slaves already exist
Date: Mon, 22 Sep 2025 21:29:11 +0200
Message-ID: <20250922192404.805885064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 35ae4e86292ef7dfe4edbb9942955c884e984352 ]

After commit 5c3bf6cba791 ("bonding: assign random address if device
address is same as bond"), bonding will erroneously randomize the MAC
address of the first interface added to the bond if fail_over_mac =
follow.

Correct this by additionally testing for the bond being empty before
randomizing the MAC.

Fixes: 5c3bf6cba791 ("bonding: assign random address if device address is same as bond")
Reported-by: Qiuling Ren <qren@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250910024336.400253-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cd5691ed9f171..291f33c772161 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2042,6 +2042,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		memcpy(ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
 	} else if (bond->params.fail_over_mac == BOND_FOM_FOLLOW &&
 		   BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP &&
+		   bond_has_slaves(bond) &&
 		   memcmp(slave_dev->dev_addr, bond_dev->dev_addr, bond_dev->addr_len) == 0) {
 		/* Set slave to random address to avoid duplicate mac
 		 * address in later fail over.
-- 
2.51.0



