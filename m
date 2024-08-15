Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530C619DF9C;
	Thu, 15 Aug 2024 13:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729965; cv=none; b=isnvipod52mbhZ7w+8BATXP2zyROGDBFQPxf2aZD7Gl2xEk0bGjKxlt9xDtcT0GLgl0HVG2r6rbbxU/UG4XU7H3dqoFZBLmKnxayfPmT4iiZV+2Tmbp27Yju+07Emes6HOEdDYP0dvL+6FRSeekwsGDvk1ykN9VyC1uTn/mGwqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729965; c=relaxed/simple;
	bh=WdcVYcTrow0OLqLF0c+DI567Trjtuiyt4bbcG0fscXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puph2Ivq5EiX2cSU8qUdt+NOk/VOwsLYkcFjhBtJbR+jXKV9PS1f/RUZNehnQL4qntWJ+atiCf5zRqNGlIYmwZAEi1ACW6K0CtkhSPVc127qqYJ9hkPo9t9t2GIS/xc2Wf54dxOBN7x3x0OC+Lui/Mmaf0iHtKNWoZjq90624Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AucyLxrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AucyLxrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA41BC4AF0A;
	Thu, 15 Aug 2024 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729965;
	bh=WdcVYcTrow0OLqLF0c+DI567Trjtuiyt4bbcG0fscXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AucyLxrR9i/OMARNONhePyPi0ctbSmvUui5zTUzVmyrbiE1iboKxuqLKKUYYOItcV
	 pIwNzucx4tMb7mH3cCbHgBWH1eCs2fluVXppjVXFbp4qxee0/yPtjAnHc0b1Rdnglc
	 UoaRWVEUs1h6AvoOS+d4q7h7YXcRrr50+du2spnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/484] kdb: Use the passed prompt in kdb_position_cursor()
Date: Thu, 15 Aug 2024 15:21:59 +0200
Message-ID: <20240815131951.483179933@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e2e821095949cde46256034975a90f88626a2a73 ]

The function kdb_position_cursor() takes in a "prompt" parameter but
never uses it. This doesn't _really_ matter since all current callers
of the function pass the same value and it's a global variable, but
it's a bit ugly. Let's clean it up.

Found by code inspection. This patch is expected to functionally be a
no-op.

Fixes: 09b35989421d ("kdb: Use format-strings rather than '\0' injection in kdb_read()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240528071144.1.I0feb49839c6b6f4f2c4bf34764f5e95de3f55a66@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index a4256e558a701..b28b8a5ef6381 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -194,7 +194,7 @@ char kdb_getchar(void)
  */
 static void kdb_position_cursor(char *prompt, char *buffer, char *cp)
 {
-	kdb_printf("\r%s", kdb_prompt_str);
+	kdb_printf("\r%s", prompt);
 	if (cp > buffer)
 		kdb_printf("%.*s", (int)(cp - buffer), buffer);
 }
-- 
2.43.0



