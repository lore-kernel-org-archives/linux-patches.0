Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C2F30DD24;
	Mon, 13 Oct 2025 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367384; cv=none; b=Igq7mhpKfQdFFVCt4ixiLVPn/333WKqzvsYv996G4V+HnU+9KbXjXsMywC/w6jDMhpSb4t8AuuwZZwZ24ey5qPi73xeSdxybzN+zGGL5hsY6IPHh07yJDNbV8/tAAV9CA/3SPhawv9JW5rRNVdwvLBPjY5X0WqepnH+nrFTnC9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367384; c=relaxed/simple;
	bh=NRU6DhYo1slGQD9ZV3RPLoNnSOsD5M9cK1jNW9Pb1CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izt4w4jrE4CfiewRIUENTc/qLdFjxb2OcXCPu5kwRRfOwWBsKyp/XJC83hcmphI6hZtEPlK6v0lh9ZDTwtz7lH7CJ/YPC45mMbj0VnOnHaOHAUjVId69/NbYjYetlTjZXtPOUNWVs65h61XrcMg3Aqy0G0VWdPS69RCWIfCOVO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/0z+LE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/0z+LE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EE6C4CEE7;
	Mon, 13 Oct 2025 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367383;
	bh=NRU6DhYo1slGQD9ZV3RPLoNnSOsD5M9cK1jNW9Pb1CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/0z+LE0rL6Q2l6SZNqqq8q0LkCxcfNW3OWDa6OPO/z+DIUKkJZayiGGHw0JTfZJC
	 Ue/ub7NkAIJdjPE4EOsJH0kSQ6iNpEj2LtJwdjX2Ng9kiE4DkIb5XwTyG21fDh3jjT
	 k8QHjEBmSMU1BUlT8pr5NDKNjKke79cxGczOxOMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 188/196] Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak
Date: Mon, 13 Oct 2025 16:46:01 +0200
Message-ID: <20251013144321.492516144@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


