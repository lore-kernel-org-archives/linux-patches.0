Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FB211710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CD6C433C8;
	Mon, 11 Sep 2023 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445530;
	bh=pgA3MA68Rh+S2Bp0iOM9A2/8kKD89lufIfj7Ecs6Mws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2/yUTZ6tK2kTF0JzD7c4lcVTalW4SQpoKUM8SAQbY3wN3z9wHFpCM4vAbMc1SBrH
	 IWmwB8qwst3l3UMkToVOEyNbqREMBMwuVtqY1L//fb8RdQDmKyfp0LrsBjDwNPlOAq
	 uPIMdW50cSWK50VgS+ZSyIqJ0b3OSD8qPIgz5N4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 380/600] powerpc/mpc5xxx: Add missing fwnode_handle_put()
Date: Mon, 11 Sep 2023 15:46:53 +0200
Message-ID: <20230911134644.888020305@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit b9bbbf4979073d5536b7650decd37fcb901e6556 ]

In mpc5xxx_fwnode_get_bus_frequency(), we should add
fwnode_handle_put() when break out of the iteration
fwnode_for_each_parent_node() as it will automatically
increase and decrease the refcounter.

Fixes: de06fba62af6 ("powerpc/mpc5xxx: Switch mpc5xxx_get_bus_frequency() to use fwnode")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230322030423.1855440-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/mpc5xxx_clocks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/mpc5xxx_clocks.c b/arch/powerpc/sysdev/mpc5xxx_clocks.c
index c5bf7e1b37804..58cee28e23992 100644
--- a/arch/powerpc/sysdev/mpc5xxx_clocks.c
+++ b/arch/powerpc/sysdev/mpc5xxx_clocks.c
@@ -25,8 +25,10 @@ unsigned long mpc5xxx_fwnode_get_bus_frequency(struct fwnode_handle *fwnode)
 
 	fwnode_for_each_parent_node(fwnode, parent) {
 		ret = fwnode_property_read_u32(parent, "bus-frequency", &bus_freq);
-		if (!ret)
+		if (!ret) {
+			fwnode_handle_put(parent);
 			return bus_freq;
+		}
 	}
 
 	return 0;
-- 
2.40.1



