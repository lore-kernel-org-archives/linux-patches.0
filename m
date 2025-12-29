Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CEB3191A7;
	Mon, 29 Dec 2025 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025724; cv=none; b=pDA1dtvF4s7pPc8v2kXVGIhEQ/a5awXZwb9HWlYN3QwPALxOVbd6pRUL5Pp/r81KKBDmG0RF+s4XBfW1djVZcTnur8fmF+lONzzpYeslvfMWK76vcLeTN2JZEHkpFNrRQsU+l9K579v+aLc0Yc8R6ww/jorVc7YpMo/j3gjn7Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025724; c=relaxed/simple;
	bh=hYxGOAoykxP55MUzs8A09ga8wXR+CFvvhu/Ketq8gtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWsK/dtSF0wejmCFrjr1mdaMrOEe/O2pgaonyaZ8nZfv0iUCMfh1WjEuKuULlwP8EFp43FcuNSdeESzDPv9mEAwlfpEq4KhNfgGnn33CK4EpXKUDaI8q0+1K3RkqISSIV+gtdyQU8WJQmYq1+Elbk04/3RBq7Icwufz++FfLXiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGwkFVuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGwkFVuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966C7C4CEF7;
	Mon, 29 Dec 2025 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025724;
	bh=hYxGOAoykxP55MUzs8A09ga8wXR+CFvvhu/Ketq8gtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGwkFVuDQvFc4h0zbRen0sakfPEdMJZPEqq2P4zlIbw9lX3+3YnMyB96R3aI1/ld4
	 er+bVyyFa1ZQPJECjMGqwzLafdKTJMcc5W0OeAVm4KKSfakoprXa2ZJga5sHOe6fnX
	 epo8DsUK22f6HWgTrqVS9aFdSktTRKV+0cAl4mkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 281/430] media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()
Date: Mon, 29 Dec 2025 17:11:23 +0100
Message-ID: <20251229160734.688092496@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit b91e6aafe8d356086cc621bc03e35ba2299e4788 upstream.

rlen value is a user-controlled value, but dtv5100_i2c_msg() does not
check the size of the rlen value. Therefore, if it is set to a value
larger than sizeof(st->data), an out-of-bounds vuln occurs for st->data.

Therefore, we need to add proper range checking to prevent this vuln.

Fixes: 60688d5e6e6e ("V4L/DVB (8735): dtv5100: replace dummy frontend by zl10353")
Cc: stable@vger.kernel.org
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dtv5100.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/usb/dvb-usb/dtv5100.c
+++ b/drivers/media/usb/dvb-usb/dtv5100.c
@@ -55,6 +55,11 @@ static int dtv5100_i2c_msg(struct dvb_us
 	}
 	index = (addr << 8) + wbuf[0];
 
+	if (rlen > sizeof(st->data)) {
+		warn("rlen = %x is too big!\n", rlen);
+		return -EINVAL;
+	}
+
 	memcpy(st->data, rbuf, rlen);
 	msleep(1); /* avoid I2C errors */
 	return usb_control_msg(d->udev, pipe, request,


