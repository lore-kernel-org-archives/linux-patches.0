Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F248BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F4BC433EF;
	Tue,  7 Mar 2023 17:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211558;
	bh=R7x8If99cTU/5nAGKBun0SS5Eq4YVcWDNfkLb7+eTrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aa+4vyfHmMBd1zUrhL5qcEI4un4y4gsyp8j3T3/OsHNLndYPshBT2FsYqztQd75Z+
	 HXyc1SHrNszyGMsmlQUfNDODcD2yMBKMb/k1CX2E1hsqqb9hpIodVyyFjPtwOya1yk
	 XUVvD72+DL/nSbChyPO3Q6WrnvUgiCjiOQm8+W6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 0902/1001] dm: add cond_resched() to dm_wq_requeue_work()
Date: Tue,  7 Mar 2023 18:01:14 +0100
Message-Id: <20230307170101.150016466@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
@@ -1007,6 +1007,7 @@ static void dm_wq_requeue_work(struct wo
 		io->next = NULL;
 		__dm_io_complete(io, false);
 		io = next;
+		cond_resched();
 	}
 }
 


