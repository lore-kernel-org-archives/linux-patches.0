Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D935817BB01;
	Tue, 10 Sep 2024 09:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961787; cv=none; b=XkJJVFZ/e2M4BgOZOsOB/HRXhn7btOBBwqR7df1Dk8pY3x9bfpqFVDtZo8pXy2XuTMMOThP2WyNvTinOTRWrOjXpg4O+g5zBou5dQwETU4r4J/r0hABAKLBRb49/lOonWMglpytAPjGXVcsY7S+RVHLX0filfczLJhmZ2barG+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961787; c=relaxed/simple;
	bh=bFMO1Z0DDkzsr/NNjETRFeA6LElEdvlVXCeiucxpMIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxBmF9fTI+Rr0VnQmggP1DqsbCl8Bkz1R/D1jq/82ir6fBx3TrnHZCzfU7k4p8r0RHoBTy5aXIsDv4pvGX089Y/xGzc2wyX3w5QjJR44jZKsvk+esaDqrw6kZsqKKN+e+SZsX29ok3EOI4JJyCcLI8rrcT7nW2vcxKdYhVtSgBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0dN/06/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0dN/06/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB54C4CEC3;
	Tue, 10 Sep 2024 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961787;
	bh=bFMO1Z0DDkzsr/NNjETRFeA6LElEdvlVXCeiucxpMIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0dN/06/D7HiDCtPTOvayAIffnw4Zpc7mCjPoM/ZYmz8X+S/tDNQteNFF1292U4gT
	 ABbP6Xy2WqrUMYa7VFAqIZB+ngGI5COT8k63ZOCrYELlPrPkyQrgbT428w+cg53L9G
	 KhPG/Wf3Luj2MYUa60NMxFaTO+RW9JMTpcryBxRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 188/375] net: dqs: Do not use extern for unused dql_group
Date: Tue, 10 Sep 2024 11:29:45 +0200
Message-ID: <20240910092628.806528882@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 77461c10819103eaee7b33c744174b32a8c78b40 ]

When CONFIG_DQL is not enabled, dql_group should be treated as a dead
declaration. However, its current extern declaration assumes the linker
will ignore it, which is generally true across most compiler and
architecture combinations.

But in certain cases, the linker still attempts to resolve the extern
struct, even when the associated code is dead, resulting in a linking
error. For instance the following error in loongarch64:

>> loongarch64-linux-ld: net-sysfs.c:(.text+0x589c): undefined reference to `dql_group'

Modify the declaration of the dead object to be an empty declaration
instead of an extern. This change will prevent the linker from
attempting to resolve an undefined reference.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409012047.eCaOdfQJ-lkp@intel.com/
Fixes: 74293ea1c4db ("net: sysfs: Do not create sysfs for non BQL device")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Link: https://patch.msgid.link/20240902101734.3260455-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index dc91921da4ea..15ad775ddd3c 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1524,7 +1524,7 @@ static const struct attribute_group dql_group = {
 };
 #else
 /* Fake declaration, all the code using it should be dead */
-extern const struct attribute_group dql_group;
+static const struct attribute_group dql_group = {};
 #endif /* CONFIG_BQL */
 
 #ifdef CONFIG_XPS
-- 
2.43.0



