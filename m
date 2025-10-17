Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74813330B00;
	Fri, 17 Oct 2025 15:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716316; cv=none; b=giIPXvdQo71Z1bLFwKx5VQ023hWoZiSJ6nky1sUP7uDlZtvUQY6swY8M7IdhkY8EnELQf1TKqwCf53yKWQVMfJZHRAIgvPveHi4MIx53O3/DrdvlZ4i/44FTqd54bXDjEevQn/dqpgZpIeRsFbnlo5XayCcPM1UH8HozdgVDDrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716316; c=relaxed/simple;
	bh=dM7wZMLBGA632tBXlln4Z9GSGYlNYGrdUTF50y/koe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIbJYOzDtZNCAmyTRS5AVu8rtT246nz0BRaw2KxFp7ay3IkUscHfy21CWCq2kZSzILGqXTiNC8GSPUkt6QZIsKa9mxxnVPRhBI/fk+2JSNgHHJcNMK+g5RT5KKDQfEVnNG1LkUHVMZnUia1t4MUie2fe/+2xdcYlr1SRAmwvO2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvgzt3tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvgzt3tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A7C4CEE7;
	Fri, 17 Oct 2025 15:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716316;
	bh=dM7wZMLBGA632tBXlln4Z9GSGYlNYGrdUTF50y/koe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvgzt3tOz9d7H7o2pIEXR7YccFactZTZ9j8t+AsmNhHwJAaPt1t8eaWzBKH8JAel6
	 /prDFz48Fko3kVLOa9FtRDbkYlCAdbx2FMJBagsr2PRUmSmte3fD92desvwZFy7c1J
	 zT5J4yNsAv8tr6IF9uJgxIsNPmb/W5Ijea1GQJvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 116/276] Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak
Date: Fri, 17 Oct 2025 16:53:29 +0200
Message-ID: <20251017145146.712460044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -741,6 +741,7 @@ static int uinput_ff_upload_to_user(char
 	if (in_compat_syscall()) {
 		struct uinput_ff_upload_compat ff_up_compat;
 
+		memset(&ff_up_compat, 0, sizeof(ff_up_compat));
 		ff_up_compat.request_id = ff_up->request_id;
 		ff_up_compat.retval = ff_up->retval;
 		/*


