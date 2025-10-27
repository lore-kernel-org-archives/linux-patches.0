Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9131D399;
	Mon, 27 Oct 2025 19:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592756; cv=none; b=tsSk7e2EuloCovoe74YBLKOkFX3JNzjuO1kLOstmRDB/Sl6ix9oGpsv5+X7zMA2elSbISEwLe55Ts/JXleNQFoPBCp4w1M8uH5Su1DCUXzqc1g5kBDy6YgMKlieIYkqichDnVV0r9PpnmkGB5cug7Ee3AX6HFglK3bd8FrLAkMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592756; c=relaxed/simple;
	bh=xUUkteqWcu9hH5Hn00e9CklNpb08idsw3Y8Z1VsfKoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpCmzwC3qfr9IiJn6Y27Ps7xAU81UjmH1ywOAEmhYdsmJ8Dnj8I+wmk4oXh64TNGF4TsNuuOfhU0z0vasNYb+UeF3W/PsiSDlFUUuEk8V1Iq0nFPYeKyvPyZSD/FVY91Z/izgA6o6vsZ3OGDOKcSRcr4Xvbol3H0DA8DrBPkAYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKNZACVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKNZACVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB17EC4CEF1;
	Mon, 27 Oct 2025 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592756;
	bh=xUUkteqWcu9hH5Hn00e9CklNpb08idsw3Y8Z1VsfKoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKNZACVBGYbdbv+lR4wrvtRP8rwN0NHJfIxfR1CoifxsZMNPkTA9A0pQjt3wIEdZz
	 C04mMDTaj8Q6solY8nEAStmyM1yhpRY9Pqr0NajnGx62G7IcRdKcBlJ/9yd2TNM3+k
	 SOV9HVau0r9fw2XCIpffd0y8nmULY5UYrJOaXrME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 84/84] gpio: ljca: Initialize num before accessing item in ljca_gpio_config
Date: Mon, 27 Oct 2025 19:37:13 +0100
Message-ID: <20251027183441.053437059@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Li <lihaoyu499@gmail.com>

commit 3396995f9fb6bcbe0004a68118a22f98bab6e2b9 upstream.

With the new __counted_by annocation in ljca_gpio_packet, the "num"
struct member must be set before accessing the "item" array. Failing to
do so will trigger a runtime warning when enabling CONFIG_UBSAN_BOUNDS
and CONFIG_FORTIFY_SOURCE.

Fixes: 1034cc423f1b ("gpio: update Intel LJCA USB GPIO driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Link: https://lore.kernel.org/stable/20241203141451.342316-1-lihaoyu499%40gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-ljca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-ljca.c
+++ b/drivers/gpio/gpio-ljca.c
@@ -82,9 +82,9 @@ static int ljca_gpio_config(struct ljca_
 	int ret;
 
 	mutex_lock(&ljca_gpio->trans_lock);
+	packet->num = 1;
 	packet->item[0].index = gpio_id;
 	packet->item[0].value = config | ljca_gpio->connect_mode[gpio_id];
-	packet->num = 1;
 
 	ret = ljca_transfer(ljca_gpio->ljca, LJCA_GPIO_CONFIG, (u8 *)packet,
 			    struct_size(packet, item, packet->num), NULL, 0);


