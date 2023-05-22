Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83862171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11369C4339B;
	Mon, 22 May 2023 19:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784953;
	bh=vXan6ghnTa/OgQMAM08m3wIj4/OYe3PiSnDwFnLcIHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v70NvN/zjSRbTn3oZ3767T2djxXlHutT0weWkek623PZg7vNaSWw0oIX39c5Fhs0K
	 7qBNbpFg9txHbu+cx84LZdvtU5aM6RNYjo12lAICkKM4SIiyd8v0zEJnOjNKSieFEX
	 kuRoguy/VgOf0lWJNrg7hifS7m9UbUzRqc3nHTYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Fiuczynski <fiuczy@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 259/364] s390/cio: include subchannels without devices also for evaluation
Date: Mon, 22 May 2023 20:09:24 +0100
Message-Id: <20230522190419.178040550@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit b1b0d5aec1cf9f9a900a14964f869c68688d923e ]

Currently when the new channel-path is enabled, we do evaluation only
on the subchannels with a device connected on it. This is because,
in the past, if the device in the subchannel is not working or not
available, we used to unregister the subchannels. But, from the 'commit
2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")'
we allow subchannels with or without an active device connected
on it. So, when we do the io_subchannel_verify, make sure that,
we are evaluating the subchannels without any device too.

Fixes: 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
Reported-by: Boris Fiuczynski <fiuczy@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 8eb089b99cde9..d5c43e9b51289 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1111,6 +1111,8 @@ static void io_subchannel_verify(struct subchannel *sch)
 	cdev = sch_get_cdev(sch);
 	if (cdev)
 		dev_fsm_event(cdev, DEV_EVENT_VERIFY);
+	else
+		css_schedule_eval(sch->schid);
 }
 
 static void io_subchannel_terminate_path(struct subchannel *sch, u8 mask)
-- 
2.39.2



