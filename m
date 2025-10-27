Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EF431BC91;
	Mon, 27 Oct 2025 18:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590602; cv=none; b=oWdrl26kJvVsAbzp3FchXqg2ImQqkm/C13uWQRySt2pF9RqMbEIoIzY+jlYVfZ/u6Pp7BWbYJh1rSvyRCe0BehepfIQ7UCAvAi1niSzMOsayYnVY//uuZ70KWVwXxaJaU0SH5QpV6hizgaOdfvjtYzFjP25yCiBr30vTPSxTFhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590602; c=relaxed/simple;
	bh=vNLKUsFt+t3SWg0rb5WLCQPdZ+HL1CRkUQZG+6KdQyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dg/0Y9oDuMITXuZcMDIPmiGr5R78+EVgIeE2ar3PlQ3kLqjeIpashfALQjpl4/JlXaztK7tvpo7uJnd6IPSAPIPeK08vI25Cr0DeyoFJIpNDqraVOnBUmbbkpwzOwpAOjDFbire6vXwxQCYUjfzupdgFsVmokc0d1tcDkkWs3rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByWBP+te; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByWBP+te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF80C113D0;
	Mon, 27 Oct 2025 18:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590602;
	bh=vNLKUsFt+t3SWg0rb5WLCQPdZ+HL1CRkUQZG+6KdQyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByWBP+teDzM65ThK7JWe2jl3dPMpr0ZFR5TBNBjeedU0TQ5/3dtMagDIoq1sIuA1n
	 ivU8OKK5mEJdeo1rmaoRM4EF0hfjbRQc2Nb7egThOZ/W9I8CtEPCYti18c0v7ZIj/8
	 u/xnqqsBHpwmP63j4zeIY2oJ1OWgQ/t8pSvB+f6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 076/224] Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak
Date: Mon, 27 Oct 2025 19:33:42 +0100
Message-ID: <20251027183511.032691383@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -740,6 +740,7 @@ static int uinput_ff_upload_to_user(char
 	if (in_compat_syscall()) {
 		struct uinput_ff_upload_compat ff_up_compat;
 
+		memset(&ff_up_compat, 0, sizeof(ff_up_compat));
 		ff_up_compat.request_id = ff_up->request_id;
 		ff_up_compat.retval = ff_up->retval;
 		/*


