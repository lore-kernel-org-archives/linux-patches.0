Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062134;
	b=5FGDju7bO/2o6xD/SQA6lngKr2eGpybZlLi7J3O2SkV6WfIPTcX2s3eMWbNmSBr66pHf
	 32JfRQf7BEUKHJ5aJJ6viI7loGrenQoqm2VfTdMbknUjZT0VoetiDPlYZ3/f+/nG3UzVH
	 vC8iUiVS2+L/F19HDOdh0mn+40oTqWLa5VegCjdReK+2/tccuqOGFGCiK7mxpOXo0PapP
	 33U/jJdww2AMFnzFXl64Ggy7pJwVvX00kcYkl1Mne9jq+Pr8X+zQfP6U0K3w+B++vWvE5
	 URcXZT4kNzM4S/qsQMIylQjPWoomTbE035Mhu24t8pSNh3CeOimduYnL7mp44cv2u9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dA+YjExohBCSLjTPFkY44E9Xa4s74v096Jsjp9ATpww=;
	b=2lQXlI47Y/R+kkPU4I59ntqnZHZzO3B/lkNDw0mAD0n8DYMK+menPM5SJtEx0coS2j8D
	 ltOCyAPViL65aHtgrJK1x37vKS9N3+1h/gSINcL1sg7XyGgcFs9tY7qlEfLTsqo87nsUb
	 UZp7irF5pqEhWI7dkjXlesmQ9seMxVPoI0TwHBpHlX6QXjCpLPVqOnQQ2sHwA0wpcDQg9
	 5i9TPsSbxnaOxBhxahGXxvvqctpZ1l1OhVmp7WjaRPettVtb0TxtUwAybgQKQbeugKwBi
	 2iG+uLLyGKZUuS/YAIk97Sdg/MAqyORF7TMLO2xlSq4LU4yHim/LH85kh8ld2AEXLAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6utEvvl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD84860A6F79;
	Sat,  7 Nov 2026 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6utEvvl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7526D1F008A2;
	Sat,  7 Nov 2026 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062133;
	bh=dA+YjExohBCSLjTPFkY44E9Xa4s74v096Jsjp9ATpww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6utEvvliWX0uA2SFrcvGZyxjUMxK0MBl1czsR9pb5qdSxND6l9QVrA6KjoR15mGY
	 TK0o6a2n5ckQgv34mIwZMGsBzLVML9B1EJL68Y2w0sm0PRFgJ6rkcl7KOpisgtiFQh
	 tsmNELDku2BgjMH/vgWzv8SEF2MQI/dJ1LS3q5pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1100/1536] media: qcom: camss: vfe: Fix VFE reset while another line is streaming
Date: Sat,  7 Nov 2026 08:51:56 -0500
Message-ID: <20261107135028.595513374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hitesh Patel <hitesh@ebytelogic.com>

[ Upstream commit e5d4b0e69a4017fd39354499c9d7583f625f0524 ]

vfe_disable_output() stops the write masters of the line being
disabled and then resets the whole VFE. The reset is not limited to
that line.

When two lines of one VFE stream at the same time, which is the case
whenever a CSID demultiplexes several virtual channels to different
RDIs, stopping the first line resets the VFE underneath the second
line. The second line's write master configuration is wiped, the
buffers it had in flight are never completed, and the VFE is left in
a state in which the next global reset is not acknowledged. Stopping
or restarting the second line then fails with:

  VFE reset timeout

Move the reset to vfe_disable() and do it under stream_lock, as part
of the decrement that makes the count reach zero, so that exactly one
caller resets and no line can be enabled while the reset runs.
Stopping the line's write masters is enough to quiesce that line on
its own. With a single line streaming, the reset happens exactly as
before.

Fixes: 7319cdf189bb ("media: camss: Add support for VFE hardware version Titan 170")
Cc: stable@vger.kernel.org
Signed-off-by: Hitesh Patel <hitesh@ebytelogic.com>
Suggested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
[bod: Converted vfe_disable_output to void]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 76839898ace97..0eeba59dd933a 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -528,7 +528,7 @@ int vfe_put_output(struct vfe_line *line)
 	return 0;
 }
 
-static int vfe_disable_output(struct vfe_line *line)
+static void vfe_disable_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
@@ -540,8 +540,6 @@ static int vfe_disable_output(struct vfe_line *line)
 		vfe->res->hw_ops->vfe_wm_stop(vfe, output->wm_idx[i]);
 	output->gen2.active_num = 0;
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	return vfe_reset(vfe);
 }
 
 /*
@@ -553,21 +551,19 @@ static int vfe_disable_output(struct vfe_line *line)
 int vfe_disable(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
-	int ret;
+	int ret = 0;
 
-	ret = vfe_disable_output(line);
-	if (ret)
-		goto error;
+	vfe_disable_output(line);
 
 	vfe_put_output(line);
 
 	mutex_lock(&vfe->stream_lock);
 
-	vfe->stream_count--;
+	if (--vfe->stream_count == 0)
+		ret = vfe_reset(vfe);
 
 	mutex_unlock(&vfe->stream_lock);
 
-error:
 	return ret;
 }
 
-- 
2.53.0



