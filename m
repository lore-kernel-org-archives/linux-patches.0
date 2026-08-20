Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5438146D2C9;
	Thu, 20 Aug 2026 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247537; cv=none; b=HPOJQcqICC2cucqddx4FvYEdY/PsU11G1vPJr7s0pMKYr9ZvkaVS+sHopnOrexSZPOgczXGgmVVtao9f4z1FBp989kyNkzc1bgxj036uGx+CNF+sk9QuG8gn/0OeYbWaW4yBuPDNKnvaS0nGgbl/k/QaK9+GFdyUzXtwDsFKNCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247537; c=relaxed/simple;
	bh=5CUNyft9UkDHu6gBtgF2/1qES8KUQVBSAhJECTHth1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P71kQIpozrQISvx/915A/Z4GuSV7oMkBPHREAmwA7izBZtCoZZp4QkBCuDDX2zdeNhFKsazcB2OhbMmFkmSpPW8xxeQt66uOfDeTj7J0N5/RMSGxrg11bVT/91IJVNusuLml/1OigQn9jYdVw3E1wnZW2Wcgj38Jscylcm2VnJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrEnoG1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrEnoG1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEEB1F000E9;
	Thu, 20 Aug 2026 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247536;
	bh=0Hgqx4FW3CvVg5n4rARXecf3KCBDxbv5lNhv1fdL3p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrEnoG1SwD6OG32McP5f79eUCpRb23NnBLCpMcloWMpfbcXBMAzKtf/mBSgJz9XIj
	 RP+5zG9QVxPpNzjNIfEFS5kWHFCXd/c5FlM0NjGMIo0qRrGyvVNn4qRqBCqbbJzGIG
	 hpaziWWWk+xJPwkfxpJzc62Ey8tMx2n2SiluhX3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 031/166] Input: synaptics-rmi4 - block s_input when F54 queue is busy
Date: Thu, 20 Aug 2026 16:54:50 +0200
Message-ID: <20260820145212.120345805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


