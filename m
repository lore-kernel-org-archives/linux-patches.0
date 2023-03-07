Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A8ABA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBE3C4339B;
	Tue,  7 Mar 2023 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214357;
	bh=9T/al8eIGdT8vxCwtjbu6C8wCy1KNEyGHz2KZfcscdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR9F5G6MUmFdAn78qnpIn4TD7brKsu0sF+Ublu7frVrCFY/9zPzUF26KiGofKa6Io
	 pUPOSDueki4ANpON7AU51Qazz0erW1pc7YcEyOSjP+7Fhvlwadh03cM6KsDEQwlFz1
	 m7Gr72gQo3CL5U6SxWisADLRCSzN7wqadHhPvP6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pingfan Liu <piliu@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 794/885] dm: add cond_resched() to dm_wq_work()
Date: Tue,  7 Mar 2023 18:02:08 +0100
Message-Id: <20230307170036.402344566@linuxfoundation.org>
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
@@ -2578,6 +2578,7 @@ static void dm_wq_work(struct work_struc
 			break;
 
 		submit_bio_noacct(bio);
+		cond_resched();
 	}
 }
 


