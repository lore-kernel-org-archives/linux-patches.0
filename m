Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DFF315D5C;
	Mon, 13 Oct 2025 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370304; cv=none; b=opnOWnJ1uk2cVe2TcO2eesCN1cg3GE7LYWuyptgCKDJ0DE6fd+tGIYa3PjX53np4VWQukbsrxSigY/4Eo4lRhYF6wGbznqloNT6zoa6QUDTxkPj2vEuMEOe3eAHTY1awHP8c2JkLqY4M7lbmgMUfT9XAFbrhatX+34sRBaH8sLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370304; c=relaxed/simple;
	bh=F+TwbUBPoRfJ2z8LJAxoGVqWQinc8RkptiQJbAXzBDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN44K0AxvtY9o2yFYniFvjFYc3/uI11pFkVT3UNSostsLBDQX9wph2MuLEgIUEfcVfJifuC2G5ZelXyT1Vlj/2Mc0bVlTIfqFQwvVZeOql4qzmQC9MVxwDqQdIVW/5iVFlUIK5QQmIgk9xCWQuqJOLfmuNgqXYZIzDie3la530k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBbaoTQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBbaoTQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26850C4CEE7;
	Mon, 13 Oct 2025 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370303;
	bh=F+TwbUBPoRfJ2z8LJAxoGVqWQinc8RkptiQJbAXzBDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBbaoTQlaBIdIM+Vff97OsyJdR5aeT0HPXNRnOHbbzNqK6Z15Kjyzj2fh9cnWTKOs
	 B00440Fp739DlD+FJMlO+qi9Cvq4sh8NdyKf2rHBsDQax4jOCWt8sMyaUBe0Q9Olp9
	 6m6fuso9qwBwfNZRTB56Xfa9GzweTmvzBLBZKlpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.17 548/563] Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak
Date: Mon, 13 Oct 2025 16:46:49 +0200
Message-ID: <20251013144431.158033467@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


