Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B903146A87;
	Fri,  6 Dec 2024 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496513; cv=none; b=A1zIaUEf4cZr56Wybri1ObO/myHWHoATmWxMDNkkGWCsG/ZDKZvD93cUQFbRfj+JC+eq4FJBnZWfvd4Vk4ZimAWqxPKQdminy2o/JdqFbo7FblQj/8uQueI1MqaOJdUf1OyQUPxtmWixeswBZvz623mW2WM04dLQeiHkB+YyXhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496513; c=relaxed/simple;
	bh=7Q427uqbF32r+wVYRG1/pUesMUKE4lmROGligOpgqg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbdWg90fI8wSa8A1Um13WZ+grmQrugoMe3Ht4ADklFErqBqV96v5RIkWqag5naK75R74gEZnWfE0gpwAOMgvxhI1YWBHuEF4nA9pguiVbcdx3xP46KXdrYdyj7nfTKIY6y3Zpc1ljcjl/2Zoy65W1ZqGaFsv/YkZnJfkWqJ3oe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBTx//LX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBTx//LX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71A7C4CED1;
	Fri,  6 Dec 2024 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496513;
	bh=7Q427uqbF32r+wVYRG1/pUesMUKE4lmROGligOpgqg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBTx//LXN8YmhYo6GUSZ2eYUvK9E2UDmNDDc9YmV5H+4cyfUVANv2CKvbdLGieqa2
	 M3FM0ngit92Ql17okWYnvlu2/o+8X2ZqND6rUVThXvHrvGCifPOy5zDAK/yijoPsR7
	 N0RS1wl2UcynLY3Ezgx++6dXIXpax6jcYE9LFdBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/676] ASoC: stm: Prevent potential division by zero in stm32_sai_get_clk_div()
Date: Fri,  6 Dec 2024 15:27:25 +0100
Message-ID: <20241206143654.380699496@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Yifan <luoyifan@cmss.chinamobile.com>

[ Upstream commit 23569c8b314925bdb70dd1a7b63cfe6100868315 ]

This patch checks if div is less than or equal to zero (div <= 0). If
div is zero or negative, the function returns -EINVAL, ensuring the
division operation is safe to perform.

Signed-off-by: Luo Yifan <luoyifan@cmss.chinamobile.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20241107015936.211902-1-luoyifan@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 1b61110cb9174..dcbcd1a59a3aa 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -317,7 +317,7 @@ static int stm32_sai_get_clk_div(struct stm32_sai_sub_data *sai,
 	int div;
 
 	div = DIV_ROUND_CLOSEST(input_rate, output_rate);
-	if (div > SAI_XCR1_MCKDIV_MAX(version)) {
+	if (div > SAI_XCR1_MCKDIV_MAX(version) || div <= 0) {
 		dev_err(&sai->pdev->dev, "Divider %d out of range\n", div);
 		return -EINVAL;
 	}
-- 
2.43.0



