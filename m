Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7791A9B46;
	Mon, 13 Oct 2025 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368741; cv=none; b=NVqHObQQfm8J8z/4p4k+K9OGXN6UWdSINBzkD+6GFYlH4OilB1kEoBfcZyk83xmRuBJ2sV5np1wHvZaaEf8Xu0FALLUhf3GrcH2GU9BmV3sqX2AiAuE3VZac5qSBlJGvOhxTpTZYUeMiAsu4Oe8ARwZLCgNGaF9CR7GTemIMZnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368741; c=relaxed/simple;
	bh=wM8hTHAZ6bE/gOYmyDWNjMxE2xZcRTTAcssTbIKvXU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATsHfveyOxPxBy2ekr4WllkN5AKYPQlNBbUgHPu2j/pgVstG7UnZEXM4apPumcJdT2WT48R4LeRZZztY1SScpeGVnd6R0grfsrH+F0xruJDLOw/+7iZPdbNIPPmQ9HbNbECtWuIhxCgGwjiTaI6WoeQEX9Ajlw6XKAgqesMBj1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7yB3Ifa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7yB3Ifa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FECFC4CEE7;
	Mon, 13 Oct 2025 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368741;
	bh=wM8hTHAZ6bE/gOYmyDWNjMxE2xZcRTTAcssTbIKvXU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7yB3IfaJyBrvDveQcxj9EZjAKWpQeR6f+oSK/+YIgyjW4LrqBmqki/gUfw0AP7Ew
	 +jG/4RDEfZ4FPNCwcWNmnz8m+lL6r/gpecc2Fhfpocvy1pE9OAKGTFmGZNnXUuKFPH
	 nHdUhIUaBDWY4wLk71ozbaVmeUXbkENj5JK49iHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 252/262] Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak
Date: Mon, 13 Oct 2025 16:46:34 +0200
Message-ID: <20251013144335.311665179@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

commit d3366a04770eea807f2826cbdb96934dd8c9bf79 upstream.

Struct ff_effect_compat is embedded twice inside
uinput_ff_upload_compat, contains internal padding. In particular, there
is a hole after struct ff_replay to satisfy alignment requirements for
the following union member. Without clearing the structure,
copy_to_user() may leak stack data to userspace.

Initialize ff_up_compat to zero before filling valid fields.

Fixes: 2d56f3a32c0e ("Input: refactor evdev 32bit compat to be shareable with uinput")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Link: https://lore.kernel.org/r/20250928063737.74590-1-zhen.ni@easystack.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/uinput.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -775,6 +775,7 @@ static int uinput_ff_upload_to_user(char
 	if (in_compat_syscall()) {
 		struct uinput_ff_upload_compat ff_up_compat;
 
+		memset(&ff_up_compat, 0, sizeof(ff_up_compat));
 		ff_up_compat.request_id = ff_up->request_id;
 		ff_up_compat.retval = ff_up->retval;
 		/*


