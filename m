Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356CBA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA64CC4339B;
	Tue,  7 Mar 2023 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216297;
	bh=NoYHxaClhaglRW9eEyOq/3GfVpQ0SkdBuI56aMnHC5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuUqCubni+Onb3G6WnO0GDg88zqhrfOR3WszLbFNpSZKaXRAX/TSuO40QRQ1UnLuv
	 TheXRNUFXtTqZcJNEok4L5v4eLQWA9XWvV6Q+nawhv2uXqGyikTFySS5B9Io6mzn+A
	 bOhP9LX73dX72n9iKZZm0VJaEjFQcHfDQVnj/ELc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pingfan Liu <piliu@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 506/567] dm: add cond_resched() to dm_wq_work()
Date: Tue,  7 Mar 2023 18:04:02 +0100
Message-Id: <20230307165927.889855121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
@@ -2305,6 +2305,7 @@ static void dm_wq_work(struct work_struc
 			break;
 
 		submit_bio_noacct(bio);
+		cond_resched();
 	}
 }
 


