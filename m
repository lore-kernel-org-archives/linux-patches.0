Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CE56FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C757DC433C8;
	Sun, 17 Sep 2023 19:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978648;
	bh=1XJfGIs45dWgZ5GUFAHp5XvJFgwRUQoBVAxKIC1HokQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUusplV93+Dj8Ea5+z0q/yDHRZFpAh+eziSixQWGlhZ5GXn3aSp6CuaLc3hsJssrO
	 mltJ/d23NeDIXxU+bSyQEWvCoeCmKrJUgzIAuxG2os+uRjEB8uL/nPEGGc2N+Hk7ma
	 bT2G790JfZCLgkwVsiVAM1svhVH13cMdpbXGaL6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/406] net/sched: sch_hfsc: Ensure inner classes have fsc curve
Date: Sun, 17 Sep 2023 21:09:34 +0200
Message-ID: <20230917191104.306740187@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Budimir Markovic <markovicbudimir@gmail.com>

[ Upstream commit b3d26c5702c7d6c45456326e56d2ccf3f103e60f ]

HFSC assumes that inner classes have an fsc curve, but it is currently
possible for classes without an fsc curve to become parents. This leads
to bugs including a use-after-free.

Don't allow non-root classes without HFSC_FSC to become parents.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Signed-off-by: Budimir Markovic <markovicbudimir@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20230824084905.422-1-markovicbudimir@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index cdc43a06aa9bc..6076294a632c5 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1012,6 +1012,10 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		if (parent == NULL)
 			return -ENOENT;
 	}
+	if (!(parent->cl_flags & HFSC_FSC) && parent != &q->root) {
+		NL_SET_ERR_MSG(extack, "Invalid parent - parent class must have FSC");
+		return -EINVAL;
+	}
 
 	if (classid == 0 || TC_H_MAJ(classid ^ sch->handle) != 0)
 		return -EINVAL;
-- 
2.40.1



