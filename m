Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71D3EC841;
	Thu, 15 Jan 2026 17:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499451; cv=none; b=m3hR4VFINgZWdOvUrf+UJhE08ArzX4Nvqmtk7nA0StXz1H69jSd4/0/fNiX17DjpfPiYgr9FvUsZ6JBaP/4IoppSzOFCU06eJNg2XbEQzAPG6IuYhdlLYP4JW4B6J5jJNUDEAP/wjck9yy0RjNYHz1uY804nUyh+8rNWFsYeQa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499451; c=relaxed/simple;
	bh=JBMmKRVcl455zW5kIC+O9BVDalO2oatGMYjiUoLBOt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCeLCzD6En1jc/VBXw4bbIBBmibzcoG0HmCNiJa+KiiPvoI2zeVBaq/RZ7QQvhXMu6+zFR2R49mBvTGdczY7kr1WH09/U3btkNWRuXkD+zl6w7SkjQiEyjY2gqSnVzcX+VcYATvc4UfgeMttQ+ddJIQs0a3zNCJE+LFCfhMtpew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLx4RJy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLx4RJy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91785C19422;
	Thu, 15 Jan 2026 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499450;
	bh=JBMmKRVcl455zW5kIC+O9BVDalO2oatGMYjiUoLBOt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLx4RJy8SsU9iLHA5yfyauOwC0+IU45tPtsOT/ivYg/wcmUwVT6RbeqE3hpEQJlPy
	 xHRP9Nm2EFM8K2nTqMfVHTL/hjuFyJPAKavIhHPVTio3FZLAMYWO965a7FghEWyu9e
	 uqqm1SZ1PXWmQFk3om1X2oIk/VCugAou5egRUX+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 230/451] media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()
Date: Thu, 15 Jan 2026 17:47:11 +0100
Message-ID: <20260115164239.214809550@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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


