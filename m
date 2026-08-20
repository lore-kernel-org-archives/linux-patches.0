Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B86D442B2E;
	Thu, 20 Aug 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243230; cv=none; b=sSQCrfrt0WAOANKbnCRvoMmXlwMciN6FusRuftg7EyWMYOcGf9q2Ac2SiBRz3sz19pk4QajFuSvLMD0+C9lk8FuP98ZPCIhORB44jYc+qrbPHz9joWKhTnZDW9t75a6VY7miQSdGhVmxEvCMnN11NpAwVF8DCfQo7f7o0jx7zVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243230; c=relaxed/simple;
	bh=WSgQ6+p9l1GO6XKnd0gm0Il/jXwBhVTkwkJ0j3Mq86Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=py+pPtCbg9eKIRJ8yJCxaPnt3C/FDYP9VwY8LG0SrhMeIt43EOVnnLfcZ0m9TdkOJBT84z+FJd8IG08Y3AVUDQcHL5r81OBkepaAVfSXUfYL1wcGsXO5OEPU93zc/+n7Wc0cw6+eQCchliWcx7V+cQ5pBSHbWrqqmHLyocZOKVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqNhCuee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqNhCuee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F801F000E9;
	Thu, 20 Aug 2026 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243229;
	bh=FgKOLC0JtiQDQBrcDT83DD02fqTbN9+LsKUOvTmNGKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqNhCueeatcFvAEGkIbsm8QaXQnxjtI/IPoXlTIHjuh65I9ZW0wlF0GJuWU9VGLY2
	 Xsy3mRMB6rkI1HC/J3w1wSG51nlMr4TsmnS+wmEJhh23e4ROtLKY12yCZsnNeLCv/+
	 LV+0I/vZ+yFPBV6SURarUTfw/OhxfWCyN2GXRd+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 022/272] Input: synaptics-rmi4 - block s_input when F54 queue is busy
Date: Thu, 20 Aug 2026 16:53:26 +0200
Message-ID: <20260820145231.899171055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit fbfd76746adc16d64be29ff113f673b70bc3f5c2 upstream.

Changing the input (diagnostic report type) mid-stream changes the
report size. Since V4L2 buffers are allocated based on the size at
stream start, changing the input while streaming could lead to a
heap buffer overflow if the new size is larger than the allocated
buffers.

Prevent this by blocking VIDIOC_S_INPUT with -EBUSY if the V4L2 queue
is busy (streaming).

Fixes: 3a762dbd5347 ("[media] Input: synaptics-rmi4 - add support for F54 diagnostics")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Link: https://patch.msgid.link/20260626051802.4033172-5-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f54.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -447,7 +447,12 @@ static int rmi_f54_set_input(struct f54_
 
 static int rmi_f54_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
-	return rmi_f54_set_input(video_drvdata(file), i);
+	struct f54_data *f54 = video_drvdata(file);
+
+	if (vb2_is_busy(&f54->queue))
+		return -EBUSY;
+
+	return rmi_f54_set_input(f54, i);
 }
 
 static int rmi_f54_vidioc_g_input(struct file *file, void *priv,


