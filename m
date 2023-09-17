Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2916FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A3CC433C8;
	Sun, 17 Sep 2023 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978421;
	bh=Sb3G0DRXqlR+3yge2tpBe3D60g4AtKyGAX1UAnYlEW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBUIFmFuon/pUytEAKD8xXIUYJUYucVmsRMUQUEUtwgXC4oEvTlJr062FxF7Pp8HC
	 1d9E95URMIYlkJIDz+X5Kk4shot4UCe7/loC6CBpH9ArXcR7h36AhgRcdisF5LZ47r
	 SzzHQO233vnGeZpOP4FUFCJIoKdDYJ3MZN1KZSnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/406] media: pulse8-cec: handle possible ping error
Date: Sun, 17 Sep 2023 21:08:03 +0200
Message-ID: <20230917191101.924576227@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 92cbf865ea2e0f2997ff97815c6db182eb23df1b ]

Handle (and warn about) possible error waiting for MSGCODE_PING result.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/usb/pulse8/pulse8-cec.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/usb/pulse8/pulse8-cec.c b/drivers/media/cec/usb/pulse8/pulse8-cec.c
index 04b13cdc38d2c..ba67587bd43ec 100644
--- a/drivers/media/cec/usb/pulse8/pulse8-cec.c
+++ b/drivers/media/cec/usb/pulse8/pulse8-cec.c
@@ -809,8 +809,11 @@ static void pulse8_ping_eeprom_work_handler(struct work_struct *work)
 
 	mutex_lock(&pulse8->lock);
 	cmd = MSGCODE_PING;
-	pulse8_send_and_wait(pulse8, &cmd, 1,
-			     MSGCODE_COMMAND_ACCEPTED, 0);
+	if (pulse8_send_and_wait(pulse8, &cmd, 1,
+				 MSGCODE_COMMAND_ACCEPTED, 0)) {
+		dev_warn(pulse8->dev, "failed to ping EEPROM\n");
+		goto unlock;
+	}
 
 	if (pulse8->vers < 2)
 		goto unlock;
-- 
2.40.1



