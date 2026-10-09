Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42DD3B19DE;
	Fri,  9 Oct 2026 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556082; cv=none; b=QupnJKhyhBjk+vf0hOF0+QYLvDDG3QizPpI76aS8A+XF5eVCvNo6NNABSK/Lf0eZityhkkj2SThON6ZfO78xyjatPeWwR7tMJW30p8+zLNrTivoXvPEig92ogv2ruV7XkwWRs9sDVsdMR7DHn+ssCKgk4PEpd46KgpP0QFXfwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556082; c=relaxed/simple;
	bh=Vi8DIFbcok3Ar37t4NuHfID35tNClsHi5NAUUqVCslo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DehO6DPaKN3E/II9aWR99QgaFGwOafmCtetuQtsExiUGdBcuk62ch1BI2xteyjnOUrqUWS7c1IrUi+4pd6eg7DESYpd/P6QMrZXrsD8BHXPCMw/IqbNkMoesjTM6YMBuFLGbBG3uDmNWJ0Mj74u6cGyNANV9eQBCHHt9wvIYrEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nesjy7td; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nesjy7td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3951F000FF;
	Fri,  9 Oct 2026 14:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556081;
	bh=u8M/xGPrYJVLAQL9PZrbFqx8ThIhWnfPlEAqYP1NVLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nesjy7tdy7zibD8e6VX8iyhKUWKt0Z2GtFsVZw2CqkIbHoSqhVX4dIsAMPckd/zRX
	 /xtxO5QasWVPmME1ISuFc15fL8/4nX8WZ0XVxtrLTN75PWvYjICdxACOAqLMN83g+B
	 +z034Fq2ugGN5LwywUhf7S0Uz2C3eyZhitcLiJhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH 6.18 171/403] usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd
Date: Fri,  9 Oct 2026 16:08:52 +0200
Message-ID: <20261009140956.108989434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
 


