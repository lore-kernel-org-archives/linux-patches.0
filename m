Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5E03BF2E4;
	Thu, 15 Jan 2026 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498032; cv=none; b=bhPFn5WrSnbZ6LoBkdQoTzdFSycISQDDiWNDLYy0Dz4oPHleYUm+KTja8aRIzeRa8MRf2c3f1UVigv9zdAFLMKTcW8etYRVkU56q5t+28j/bD5J6+hGCFHHz9dK8auQkqhPgmGJp9U/YQbr1pfS1MikDNPd8Hy4BRu0WCK+VCY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498032; c=relaxed/simple;
	bh=BGjsBhKsI7PpcYlZ3rPq3Hs6fe6C6JTbYj2VJXJPWWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLU8mZNtRCsTI4OlhFGSWO1YdD04HuOGpQ9QS/P2XI3bG8CEYqPsVIEq+FZEtlJlD6Dpa24J7Kf5qWUIiZwFgo19p2RuV1lS2whk1PZ+HUWRqIcFVAjNCIyjzYJaQFlE4KJz5N+1V6gqwWlIpgZQSFZDxE5dmezb5nYtBMIgEkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzpRawcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzpRawcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6BBC116D0;
	Thu, 15 Jan 2026 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498032;
	bh=BGjsBhKsI7PpcYlZ3rPq3Hs6fe6C6JTbYj2VJXJPWWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzpRawcF/BGViGdIQiOvLyQEc7I80NDCrrxGk9JlpTqazhISjW4mfS8ub3NJlx1fj
	 E4MeTsgxlNDr25mDVKuxbaQGvoBNw2VqhW98GgtoyDX0OaP4JsZor7/HyFlLYuyrQv
	 ibrvqcf+4+wgCRWJ8qbRDYLBB4MJX/LbDM21RMpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 290/554] media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()
Date: Thu, 15 Jan 2026 17:45:56 +0100
Message-ID: <20260115164256.724233252@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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


