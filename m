Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD1F30FC10;
	Mon, 13 Oct 2025 15:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367944; cv=none; b=q01+5N5ZuZKjPJzSoMzEdCaVX9MO4sLmZUW5GTO7dsXxYWjUniZettazYEHd+RVGCByp0xBkuiYjT3PSHNL3o7bnWbwZZwDhcet6qVz+H6GnSmznvRmnesjBqpzUpkiXff1yACL3p9xnR4furxGIUVPvTScqH5Km9hDNWnMBXxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367944; c=relaxed/simple;
	bh=v2UOH0b8afPAFa9/Q+1i7ytvCXaqR/xEtWV0yPqpbOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYQv+wGNTtDc1rxxNDVCDw6E4NqQZQAkftXsKjD+Nx5YEyWTrFHXzEc7zEyg4rWICfz+d7B4Ka35wwDyKHqNQF6D6uHv46lfys4+OBDBda81LwYijmTzHdV6D7HK4xRq7ga6jAcRbh3ziPAkeyE5EBXMAbtIMQQzXld9eYFIhmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0EQFhRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0EQFhRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1B2C4CEE7;
	Mon, 13 Oct 2025 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367944;
	bh=v2UOH0b8afPAFa9/Q+1i7ytvCXaqR/xEtWV0yPqpbOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0EQFhRJpB6MhR0l9iQqCNaHR6AfWIwjYSdnTI0yJ/fBEm3q+xdsZwyLPGaFhSqco
	 IJOtHSt3roBJga9NNMwUWgdznC+1MYv5gD+wJAIekwEtooH89wq1VD4YbdhQPqeZ2Z
	 goZwIGsIPoYwW6Jt1czmLpYwmKoPQEoqk6iAEGn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 188/196] Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak
Date: Mon, 13 Oct 2025 16:46:19 +0200
Message-ID: <20251013144322.108029263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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


