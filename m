Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DA28827
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB762C433EF;
	Fri, 10 Mar 2023 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460677;
	bh=OQlBTEhtwxe4JUMf5/dydUaSJOpJcrSCS02H+Frc+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctxgDXj8kUQzaWesciFhIxsgpXmVDwXq+Vv4armK7DLROcz3bcXeKHonkMlPxsUVJ
	 suA0Xaga6E2hIiqhkpQik0x/KuO9uUelo3uUkjsi1UPXhT95ytxD0SqcIa7RRHne7a
	 dCavKOrHN2czHydAfauREF3jMNm31XIpMYWvXN8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pingfan Liu <piliu@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 385/529] dm: add cond_resched() to dm_wq_work()
Date: Fri, 10 Mar 2023 14:38:48 +0100
Message-Id: <20230310133822.852943231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pingfan Liu <piliu@redhat.com>

commit 0ca44fcef241768fd25ee763b3d203b9852f269b upstream.

Otherwise the while() loop in dm_wq_work() can result in a "dead
loop" on systems that have preemption disabled. This is particularly
problematic on single cpu systems.

Cc: stable@vger.kernel.org
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Acked-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2393,6 +2393,7 @@ static void dm_wq_work(struct work_struc
 			break;
 
 		submit_bio_noacct(bio);
+		cond_resched();
 	}
 }
 


