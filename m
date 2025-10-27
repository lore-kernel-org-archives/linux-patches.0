Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578CF314D21;
	Mon, 27 Oct 2025 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591169; cv=none; b=QANEfUfA8J4qTOSgvCZ5u2IJq9rCeZlcugmh5C16a/erRFGiiAeYSbmTXyrER/ip+y0VUWNH28BE5Czj5v7YIepZ0q9/dc7E2Op87HHvqRqB35GCHxU+QARqpxQ4SiIImCbtDgYa9niV43ZUHK9WxxEWv8F0kPF4VrqSzeG7uL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591169; c=relaxed/simple;
	bh=FzKQMoepavOTdBmiRKocKa5h+FnrFgBSpAUHUr0OH2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNlYOq1oXgyIqhX3AnAdNMb8Hie0PQ+IX8jzBK2ovS4mzMaaVtIIHmPiMp1QRZ9OpLPhJITsPa0M2l0i6ODjinsZuZ/ayRK05P8ez27v5CfNk4/+DIN1mjLiJ27uRs5G++Dc9LWPSiJ6vxAE+KaDyO2G8bJFFMr7RH7BceOWcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJI+K7ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJI+K7ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFDBC4CEF1;
	Mon, 27 Oct 2025 18:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591169;
	bh=FzKQMoepavOTdBmiRKocKa5h+FnrFgBSpAUHUr0OH2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJI+K7ze5ebTeTIgspJfQa3g3k+zme2kN5by+LkGLoTpunAMx+m7wbF9Z0F3yI4E/
	 V/deVWwolbJHXGq3zzDTNwguTd9T+69j+gjOIxYafIQhhaBJeTE/QdMs7C/ra49+mp
	 wlBWdgg1hz3gbTLuVgXa297NEToGN++P3JqphVJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 093/332] Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak
Date: Mon, 27 Oct 2025 19:32:26 +0100
Message-ID: <20251027183527.077148470@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


