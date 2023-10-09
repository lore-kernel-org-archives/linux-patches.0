Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC77341A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcOC9DfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02F3C433C7;
	Mon,  9 Oct 2023 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859296;
	bh=qyF+uiVNISqJB+4wetCHUMoeuTR33CU96RKFipLE/jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcOC9DfB4wQhacHmEXwpRj9KZSgo1G0EfbnHlbmxn0S+9ynInYMCy50+eilO/4nxY
	 JP8sCFO+HV8CsaxZakPNwjag+X+xGuBZutwzzFtSlcokqGOgDm0kqH8wvvtYmqSjMT
	 tVHms8LtVQx4oQasPBbn6Q/+MSQgG4Q6OFQ9HeAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 4.14 33/55] net/sched: sch_hfsc: Ensure inner classes have fsc curve
Date: Mon,  9 Oct 2023 15:06:32 +0200
Message-ID: <20231009130108.966422318@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Budimir Markovic <markovicbudimir@gmail.com>

commit b3d26c5702c7d6c45456326e56d2ccf3f103e60f upstream.

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
[ v4.14: Delete NL_SET_ERR_MSG because extack is not added to hfsc_change_class ]
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hfsc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1020,6 +1020,8 @@ hfsc_change_class(struct Qdisc *sch, u32
 		if (parent == NULL)
 			return -ENOENT;
 	}
+	if (!(parent->cl_flags & HFSC_FSC) && parent != &q->root)
+		return -EINVAL;
 
 	if (classid == 0 || TC_H_MAJ(classid ^ sch->handle) != 0)
 		return -EINVAL;


