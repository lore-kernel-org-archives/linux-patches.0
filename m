Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5394FC8D8;
	Tue, 13 Oct 2026 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895043; cv=none; b=XVgXEFryoOwS4waFY6UaKRarwIx7cvwev/qAdMnGD8WDZqSiilEaDMdYC0BXOGrJmFqb7omMN9yf2ZdV9ifipVGVQrKaQqOU5B0QHSF1q17lKjZbAt9w7MB8AlCeBT1+hAGH6RtbWpMUc9ksiTZy06/Ym+59+3qowQEi9S1CUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895043; c=relaxed/simple;
	bh=1IFqTLvNXdpKaBTTC0Mugk5HejZrlmG3GFvpk1xDsuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHdAefjOPVWfzFAq8RAcKUJ5fhLvS1j/0drH5R3WW8vNwjsJVBTxTKn+qo5TPDdVW5XDSk+FxTYHV/ZptFjRlNjtqWbbVqsNBFPSPXrQaFrxM4sfe1Mj5VnyQNH3Lwf87OWYZswQiHpJB291gXTztdCephJJPoOTDeIHYiqu0EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X21utSYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X21utSYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412501F000FF;
	Tue, 13 Oct 2026 12:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895042;
	bh=rcuZnbhDJtvk6HMeaAWnZIrB10FVp96awjdaawuUf/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X21utSYicK93Z6vF2GNI20ECN8ZxIAcUncuUDH18xYaSZuVWvsh/c7NNMbTak9tpr
	 xM4zD96LK8PfYTQCOTwgle+HaY43Z0c8EOUFShHGuYiyfhD22pEyGqtYh++7YuPN+X
	 sboE8tToKpCmyLVzBPmna7wvjk7ZWX9bOfc6jKOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH 6.12 143/497] usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd
Date: Tue, 13 Oct 2026 13:35:10 +0200
Message-ID: <20261013112911.282315974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Liu Chao <liuc63@xiaopeng.com>

commit 9062d50e75c24dc7911be05c9b1719b3b256af15 upstream.

generic_set_cmd() and generic_get_cmd() use the low nibble of
ctrl->bRequest as an index into con->data[]:

    u8 cmd = (ctrl->bRequest & 0x0F);  /* 0 .. 15 */
    ...
    con->data[cmd] = value;            /* OOB when cmd >= 5 */

struct usb_audio_control (include/linux/usb/audio.h) declares data as
a 5-element array, so indices 5 through 15 write (or read) up to 44
bytes past the end of the array on the heap.

A malicious USB host can craft a class-specific SET_CUR / GET_CUR
request with an arbitrary bRequest value, triggering the out-of-bounds
access from an IRQ completion handler with no further preconditions.

Add an ARRAY_SIZE() guard to both functions.

Fixes: c47d7b09891a ("USB: audio: add USB audio class definitions")
Cc: stable <stable@kernel.org>
Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
Reviewed-by: Ivy Lopez <skunkolee@gmail.com>
Link: https://patch.msgid.link/20260921072551.3708191-1-liuc63@xiaopeng.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac1_legacy.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/function/f_uac1_legacy.c
+++ b/drivers/usb/gadget/function/f_uac1_legacy.c
@@ -797,6 +797,9 @@ fail:
 
 static int generic_set_cmd(struct usb_audio_control *con, u8 cmd, int value)
 {
+	if (cmd >= ARRAY_SIZE(con->data))
+		return -EINVAL;
+
 	con->data[cmd] = value;
 
 	return 0;
@@ -804,6 +807,9 @@ static int generic_set_cmd(struct usb_au
 
 static int generic_get_cmd(struct usb_audio_control *con, u8 cmd)
 {
+	if (cmd >= ARRAY_SIZE(con->data))
+		return -EINVAL;
+
 	return con->data[cmd];
 }
 


