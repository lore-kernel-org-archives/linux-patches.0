Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3D8168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A4BC433EF;
	Mon,  8 May 2023 10:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543167;
	bh=eUicCCTacN+4HZa4ZS17SedqqLgYkcBdUACFtoKMKHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQ0GGkkWbN5R66yfMy2Ud5Z7Z2ESp9QIfU9axNKoDiiHcS1shtAOrdpTMW+OlPpPB
	 tcb5HePD4/KwXXb8GhvrSevyZciJDd+KewAQPsIUetzgqC9//pxJOGjvGU3pKamkJi
	 glCV4HJPugAXZ+NoEGEVp5pjQ6h2BG1rpwmTdsPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.2 637/663] clk: microchip: fix potential UAF in auxdev release callback
Date: Mon,  8 May 2023 11:47:43 +0200
Message-Id: <20230508094450.607584891@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

commit 7455b7007b9e93bcc2bc9c1c6c73a228e3152069 upstream.

Similar to commit 1c11289b34ab ("peci: cpu: Fix use-after-free in
adev_release()"), the auxiliary device is not torn down in the correct
order. If auxiliary_device_add() fails, the release callback will be
called twice, resulting in a UAF. Due to timing, the auxdev code in this
driver "took inspiration" from the aforementioned commit, and thus its
bugs too!

Moving auxiliary_device_uninit() to the unregister callback instead
avoids the issue.

CC: stable@vger.kernel.org
Fixes: b56bae2dd6fd ("clk: microchip: mpfs: add reset controller")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230413-critter-synopsis-dac070a86cb4@spud
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/microchip/clk-mpfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/clk/microchip/clk-mpfs.c
+++ b/drivers/clk/microchip/clk-mpfs.c
@@ -374,14 +374,13 @@ static void mpfs_reset_unregister_adev(v
 	struct auxiliary_device *adev = _adev;
 
 	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
 }
 
 static void mpfs_reset_adev_release(struct device *dev)
 {
 	struct auxiliary_device *adev = to_auxiliary_dev(dev);
 
-	auxiliary_device_uninit(adev);
-
 	kfree(adev);
 }
 


