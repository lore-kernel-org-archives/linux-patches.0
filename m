Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861273074AC;
	Mon, 27 Oct 2025 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590938; cv=none; b=UsmT2ZsS/tdbMzf5VRDUbd1YaJw/nX1QZR+LZd32ribwMB9s1RL9hBPW4jQ7ki4rPfB7Yd3RxdUGPS7lF8+bH6znTCl0j3E33wFUoTHNtyDPOqIEqBr/w9r54oTrg+x4LdEwqOZNf+IgAWJOHgPx6dAqwZx+Xwk63itDqwtCs3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590938; c=relaxed/simple;
	bh=tD26AhonlKVBMpceCuY6p07KsFtRPeIw7AkMOOBVnx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKQCV1HPj1+hH+sGWxh9LlbpPnShRooBoM7S+I8G6Vbj1hyQmgtbvUkOdp4Aiy384f3kQiMIbeZjyW9ht9qX4UO/SDnwZTinzS3WlpDsdfWHlBRKZvezkBcYd7fcWXXv7yA5RMRST6UA3M8y66qghV72v3dNxDWDOYpV+CmZZF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHxD3CCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHxD3CCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F2CC4CEF1;
	Mon, 27 Oct 2025 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590938;
	bh=tD26AhonlKVBMpceCuY6p07KsFtRPeIw7AkMOOBVnx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHxD3CCLK+l47VR/1BOAghEqWkJTr7nFQmc5d8hKhGiAanpqfEvSPfdoVMb2RHG1e
	 /8hGklEo6EDOtEsIea5Eg0wZblR18Y+SkZTZDbX5NkfKOG2dlYNvPOBjYNY8qKWL9S
	 ThwTib3Ie/KSTToMVOIlZw9/+tFIpJ97X/0Evpno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6c3c066162d2c43a66c@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 206/224] comedi: fix divide-by-zero in comedi_buf_munge()
Date: Mon, 27 Oct 2025 19:35:52 +0100
Message-ID: <20251027183514.290061490@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 87b318ba81dda2ee7b603f4f6c55e78ec3e95974 upstream.

The comedi_buf_munge() function performs a modulo operation
`async->munge_chan %= async->cmd.chanlist_len` without first
checking if chanlist_len is zero. If a user program submits a command with
chanlist_len set to zero, this causes a divide-by-zero error when the device
processes data in the interrupt handler path.

Add a check for zero chanlist_len at the beginning of the
function, similar to the existing checks for !map and
CMDF_RAWDATA flag. When chanlist_len is zero, update
munge_count and return early, indicating the data was
handled without munging.

This prevents potential kernel panics from malformed user commands.

Reported-by: syzbot+f6c3c066162d2c43a66c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6c3c066162d2c43a66c
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20250924102639.1256191-1-kartikey406@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_buf.c
+++ b/drivers/staging/comedi/comedi_buf.c
@@ -369,7 +369,7 @@ static unsigned int comedi_buf_munge(str
 	unsigned int count = 0;
 	const unsigned int num_sample_bytes = comedi_bytes_per_sample(s);
 
-	if (!s->munge || (async->cmd.flags & CMDF_RAWDATA)) {
+	if (!s->munge || (async->cmd.flags & CMDF_RAWDATA) || async->cmd.chanlist_len == 0) {
 		async->munge_count += num_bytes;
 		count = num_bytes;
 	} else {


