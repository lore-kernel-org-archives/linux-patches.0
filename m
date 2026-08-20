Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC01537DE87;
	Thu, 20 Aug 2026 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238170; cv=none; b=KQyC2T9e0g5A6TXfjaYu3r4fJId9y/wD3DP8cYLvFW3+4WEXgCdkY1v0Gx44rEKlMkb7s0S+yOVr2IXH2UTjrpaQIjz5Ffs56SGYtDywRVckoptf4Ye9J4EeZcuTd2Ypk89R8d0bj2mhfBrZgLcYgBvoS717e8ha6EcqR1u5KXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238170; c=relaxed/simple;
	bh=A6ASgg3K3G11Gt/js094N5voYOx9lc5Y+2by8StPzqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyVS2Uo0d1jXAt3EEn+TidiJcd49oxOvbc2GHBrF3KHUTqLxn+/zIlVxyIPPUdEyZO3I2SXvaMmTzNqJEy4qTHEyEM2AiMTW2yF0PKIQdK2BQrsJXg+4XRdDWAeHMtkhuipZH4n85G2fIu63gAlHmWDcAm2NFl1L7X2dlZlTfdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q96lEAhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q96lEAhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E9E1F000E9;
	Thu, 20 Aug 2026 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238168;
	bh=2fhSW2ftgLmyAGAWlvE3Duk/CEkwlp2q+G/pPzo2cus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q96lEAhU7J/NlYEL7alwtNs4p6vVXuLens/hGnOjyyTFVe+wFrAJ9Mk4XP0X8Rpim
	 e5D7mM3Mr5tVJe+vBs1nigLKS2Z0ll6h7O7gS6k+H8JXC2JCpjW9OnJLFIYjJySTSU
	 iUd+Jjc/Dphxzi3Np4n50tbpLad5sBy/wbIZcSKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 054/228] Input: synaptics-rmi4 - block s_input when F54 queue is busy
Date: Thu, 20 Aug 2026 16:53:16 +0200
Message-ID: <20260820145246.118064207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -445,7 +445,12 @@ static int rmi_f54_set_input(struct f54_
 
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


