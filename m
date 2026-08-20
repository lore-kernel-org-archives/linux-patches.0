Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901BE381AEC;
	Thu, 20 Aug 2026 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247861; cv=none; b=RqJgrjBjjoNXYjkU8fvIU7O0ax3Y0Xk+ytGTTJG+6BnR44E0mQ4nEL8bxHPmfTYPj9U522Cn8KtZIVjn6qpOCK3Vy6X9LfwnLkslrN+Y2KmOyC1Ot2R0Xp37i6CybYdiVso1NPEoPO6rY9AqIM6/s7j11pUos2tv2FE8r36Mc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247861; c=relaxed/simple;
	bh=W8fuc0rjMiAiyrqYLtqxdHB//Aq3ocSCPEs0z+ncUW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrzlEMKXlMopUIPNfosgR736Mtgn4xI4aNOcjtnLVq5WzXBM+iCCGfrdFFXAsR2haDK3wqAhvCWqHYSpXfH0/tIzn4xdgEKuNUNM9c5/kazgQLhACt1EdtfPGpacZr0P1xHID66SX0N4HXC/ucWebD9Pj2WoIzk8hE1iwx2zgAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGXCMtHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGXCMtHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6761F000E9;
	Thu, 20 Aug 2026 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247860;
	bh=HsQSoMqOi1/TOx4DP9VJSoThOe9EIQotTBLwkM2xY4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGXCMtHkVT34izgkIKkd51aA7drUftydAcPoTPk8id3ZyrL81VE1NSEHhnZBavOSg
	 HQYDtUEjpYaufD0Q9e7ZvfYA/ha7UFE0bixeTCQ8upHUsBAvZumaTo4s5w36basazK
	 10Fuwt1svytYff+LjIN6Um+iRpsVHRqqPE/V4EKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 028/303] Input: synaptics-rmi4 - block s_input when F54 queue is busy
Date: Thu, 20 Aug 2026 16:52:44 +0200
Message-ID: <20260820145254.029004149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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


