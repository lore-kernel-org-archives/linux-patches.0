Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E7C33032C;
	Fri,  9 Jan 2026 12:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962350; cv=none; b=XXSNGBBW3h/ICGIcAr8cxD6QEpPQQT3E187nR9Ymzt2OnpVpjcgI+CND5kDUc2CApgEtSXoObYwcIAL3LLSetZqbUeeboV5V37NZSHp3niMkYO/CNzHSpPInhgiv0DTkssaM9CpXJEtG4Vzd9tuiKl6V6UH+otzVQqydVZaf0GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962350; c=relaxed/simple;
	bh=5wwyXNYWIYB4N/OFHg4+kTOR1Q62taN9LSMME/FDdCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyNu6AAk9Cag0/b4m0wd3SeZ4t7J0wjdkiG5jgass6i82bx8sx5KQpkQ90+iWAQjC0DN7RjoyLryfYJsd3LExvevFTybasemTi6nV058ASYu+gfyz07zIF38pYRKTNeSQG0v562J0ywSJXb0aHXX8ksbsiBEQ7yJqMKFibhOfCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7jVi1/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7jVi1/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCFBC4CEF1;
	Fri,  9 Jan 2026 12:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962350;
	bh=5wwyXNYWIYB4N/OFHg4+kTOR1Q62taN9LSMME/FDdCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7jVi1/F3kOrCbMUfLXHLFk3O63lmvl1NBsapW/P3LYwwRWIhXOzMsat9ZeYE2BOA
	 +OiAjhTmGi+IGFlBE3v2TOG+LjSzzaKCYctoaLjmioep1DhdI0LxiR6pzowROWFQ0E
	 4Ct4+BY0+4s++7yXq12GPsYxvqStzhOKyS8jIBH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 334/634] media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()
Date: Fri,  9 Jan 2026 12:40:12 +0100
Message-ID: <20260109112130.093514841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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


