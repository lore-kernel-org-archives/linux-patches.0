Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA127C0BD;
	Wed, 21 Feb 2024 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524646; cv=none; b=RlxXUqyV8D93MtoMwYcUd80EgNDJnb/KJL8hc2W4PAbQCCsClhHP8Tb0w90bIJHniqY9va44V4fGKJG+uKE0ubykx5tUnhoZLDmdigfyqK5Fp4l9/hbtBm8qNwoBUxZDZSv1IqboQ6ELAvb8N82CiAJO2rpfRuRubqQmz0Qm1RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524646; c=relaxed/simple;
	bh=PTUblDmFXtoFAtIczjcb1R5D4x80gmw0/6NHVKzV4dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZQVleUyglvNbmYvR5Eg2F0HB7mB8sVwUKgVNw1VpLCXDVD0tAZE/gfcI4ulHkP0YbexkAg9VZpvBjFoiyvncPtV3fIi98rpP+TnEz/cG39bQkCWlsi+l9rqyY9T6r/9eAc9YXSUPg83/+N79vTDn9iYUzN3kbquWQ7gB5QxUlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Na20rqdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Na20rqdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7E1C433F1;
	Wed, 21 Feb 2024 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524646;
	bh=PTUblDmFXtoFAtIczjcb1R5D4x80gmw0/6NHVKzV4dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Na20rqdGfnPPyAipAF82ByF4d/NTZGYXk5CQv2QXjS5vzui9mBQGbYwbRS1ElFY0k
	 dAdx7S52NRXToAAi3MtGgQbN+3LsPErOvAysOEd+2cMwV1jDzp6ER9kPzeC2DkGfaO
	 mWb0apkg73PmlThX0KuIeuCoPCX6ubHWUJfyGpII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/379] media: ir_toy: fix a memleak in irtoy_tx
Date: Wed, 21 Feb 2024 14:08:05 +0100
Message-ID: <20240221130003.972166266@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit dc9ceb90c4b42c6e5c6757df1d6257110433788e ]

When irtoy_command fails, buf should be freed since it is allocated by
irtoy_tx, or there is a memleak.

Fixes: 4114978dcd24 ("media: ir_toy: prevent device from hanging during transmit")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 7f394277478b..cd2fddf003bd 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -324,6 +324,7 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 			    sizeof(COMMAND_SMODE_EXIT), STATE_RESET);
 	if (err) {
 		dev_err(irtoy->dev, "exit sample mode: %d\n", err);
+		kfree(buf);
 		return err;
 	}
 
@@ -331,6 +332,7 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 			    sizeof(COMMAND_SMODE_ENTER), STATE_COMMAND);
 	if (err) {
 		dev_err(irtoy->dev, "enter sample mode: %d\n", err);
+		kfree(buf);
 		return err;
 	}
 
-- 
2.43.0



