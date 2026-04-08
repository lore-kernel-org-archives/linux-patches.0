Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD33176E4;
	Wed,  8 Apr 2026 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674520; cv=none; b=aud2Pcb+GtN6mrFQnbD/Fpbaxzt8xzxkFmXHYw08ySYLmsyi+JU2Amvj2eKkWbONPQUKa3ZRaLe/AXqiDAt0xcjyp6Dt2i0QBxEmpyF6n/PItYQ7J+ey0HuAK4+CLkyYuVl0JmfyvrZZef1cVId1xdNv5l+7cgcP/P7N0tdtNh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674520; c=relaxed/simple;
	bh=Kb0et+H1niiquJzjifBRoWw2ROZhcVCSMH5zAOmDdJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCuwjAAN0xLpbfIjBu9+92qQ6Vv4lGsAeQFIX6bDGrNbMwj3pG5rPhyILKZwGc6f+rf1YhgwR2pi0xKysSliwQvbevC508Wur4kG0RlOnjTw03x/opxqZ2ZV38xTQE8xagzwJdBzo7gti3/XtOd1yajCNUCwAQezjiBqSpaOjmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrY0UMuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrY0UMuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF5C19425;
	Wed,  8 Apr 2026 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674520;
	bh=Kb0et+H1niiquJzjifBRoWw2ROZhcVCSMH5zAOmDdJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrY0UMuQ3uLiUsCXcdyDXStZqHUduKGLqbGzk+RdfWIMc+HAcP+iJZqTWLCRQau6k
	 FXHETXu4WQnPKh/CEyWIVOFcrar4G8pWAYFLot733KQ42wLnRiu2oF0nj1BtUfax1B
	 LpF58PV72Ii/X/LYHwEumxrbN7VoHYNXGtbxCNE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 129/311] gpiolib: clear requested flag if line is invalid
Date: Wed,  8 Apr 2026 20:02:09 +0200
Message-ID: <20260408175944.233474000@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit 6df6ea4b3d1567dbe6442f308735c23b63007c7f ]

If `gpiochip_line_is_valid()` fails, then `-EINVAL` is returned, but
`desc->flags` will have `GPIOD_FLAG_REQUESTED` set, which will result
in subsequent calls misleadingly returning `-EBUSY`.

Fix that by clearing the flag in case of failure.

Fixes: a501624864f3 ("gpio: Respect valid_mask when requesting GPIOs")
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20260310204359.1202451-1-pobrn@protonmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 2e33afbbfda48..04068f4eb3422 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2466,8 +2466,10 @@ int gpiod_request_commit(struct gpio_desc *desc, const char *label)
 		return -EBUSY;
 
 	offset = gpiod_hwgpio(desc);
-	if (!gpiochip_line_is_valid(guard.gc, offset))
-		return -EINVAL;
+	if (!gpiochip_line_is_valid(guard.gc, offset)) {
+		ret = -EINVAL;
+		goto out_clear_bit;
+	}
 
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled, for non-sleeping (SOC) GPIOs.
-- 
2.53.0



