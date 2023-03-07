Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296C3BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8450CC433EF;
	Tue,  7 Mar 2023 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214360;
	bh=OUKx0O9/qLVy2CVxU/LKgpYFGwRNlpTn5XASeLVUjS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn8dMGR4NJEX+inR8scmG5r+lT0dOHaBW0IH+22rZKhAlGGCV3FzhGoZrpI2dr9aT
	 7ewjILEyadKU1e7GKG67Y6kuVyLPEytgLOcBEv1ra0KJyVu/1CL4aPgsgU/TINDLSI
	 13XYP7MJLe2zG7j0dglxQwchWzF90KT1cQJc482A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 795/885] dm: add cond_resched() to dm_wq_requeue_work()
Date: Tue,  7 Mar 2023 18:02:09 +0100
Message-Id: <20230307170036.436147902@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

commit f77692d65d54665d81815349cc727baa85e8b71d upstream.

Otherwise the while() loop in dm_wq_requeue_work() can result in a
"dead loop" on systems that have preemption disabled. This is
particularly problematic on single cpu systems.

Fixes: 8b211aaccb915 ("dm: add two stage requeue mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1020,6 +1020,7 @@ static void dm_wq_requeue_work(struct wo
 		io->next = NULL;
 		__dm_io_complete(io, false);
 		io = next;
+		cond_resched();
 	}
 }
 


