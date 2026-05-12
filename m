Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000953537D0;
	Tue, 12 May 2026 18:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609381; cv=none; b=W460IVWUDmOGd+GuOUUtDQwX975EeAC/g+2lML3ZBAIQATlmbbxQDyDAR0wpwzOU/Jtbj6cWTddjZi+231naAgYkv+qJTeu8WDnvt7pikv7iuRo7S/mKl0p/ub7JuLcQXSwPIpY2DevGddwY+qjtPGp+5+HFACYwXoLvGn5WYbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609381; c=relaxed/simple;
	bh=NYIBzE7IHGujvOuOWHxOA9q0ZytjvIyg7QCPirC3pRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmLamVgMqJTZIS75kPMB9IekempQEkjWlWX7Bf4h+h9zeAUL9kkueKRxul2CzQCzyJ4zZ4uXCLfLFC994g/Q83zMx9KhkXfCMHvY4ZbNLuGYSH5hZQ+7apZixXBTbmB/C52II97HMk0o5TvHNEkchZj0DrGAORRpCOIcKRhNT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AigZDkP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AigZDkP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8C4C2BCB0;
	Tue, 12 May 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609380;
	bh=NYIBzE7IHGujvOuOWHxOA9q0ZytjvIyg7QCPirC3pRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AigZDkP9Oxz73GfB0ZfCOZNoWwmFhC3QAJA4qryHGVmng9FPfydBIrlOXYJxiRFWb
	 d+X/dCCwM9fqAMYbhHQb7KXyKEJIeB/YyZsMl0WgMNcoZx5posAfVUm6+0GQNRPeY0
	 YXYV/I/O804U7H1p1knY/bU4fsVpU8D5DHvBXK1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 174/307] ASoC: qcom: q6apm: remove child devices when apm is removed
Date: Tue, 12 May 2026 19:39:29 +0200
Message-ID: <20260512173943.790040801@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 4a0e1bcc98f7281d1605768bd2fe71eacc34f9b7 upstream.

looks like q6apm driver does not remove the child driver q6apm-dai and
q6apm-bedais when the this driver is removed.

Fix this by depopulating them in remove callback.

With this change when the dsp is shutdown all the devices associated with
q6apm will now be removed.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -764,6 +764,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
 


