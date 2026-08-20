Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6745D246781;
	Thu, 20 Aug 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244123; cv=none; b=W15M9NxWJmNKKM4gqXWEJUIfdI+BB5iLds1WnPrM5Cv7psMzEpoel1YQoRiLRFSdUJbsvLzTaqIt9BAzpwhvuT0OM9v4jQgMb+NEkFAAsa6jrRMb6naog9FYd0Dm+9PORKYGvkb9tNnDDxPmSrJdGptYS2cc+GnQQnz9DP1znQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244123; c=relaxed/simple;
	bh=bJ95jdF7B/2tqXepWUnePPocd8KdnyCcBl64P3hSD2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9QYFSnP+Amuq4qLEkq2LFZowkDSrX1jKJfjfsnHKvom/qsnmuLCcpxgx+LPNcq4Cggrs/l9o4VYDajZqtQ4ZitejjE9xd3x27pN5JtL9wysK/MBR5YGNBuhL4AFLZAf55SWoUB3hNQRWi0xezayvtjLvesW1Lw2rjdU4sNJWvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AKjDZIB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AKjDZIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0C01F000E9;
	Thu, 20 Aug 2026 16:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244122;
	bh=Lw/nt6OnoaSJ4a28r2YxZlXMXj6pLczpp1r7Og4EUVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AKjDZIBG5qCOsPkHLj7vry86dFdKySAOc3e3nqoWsOyX16SLB5Y0EmKeY7sijS7J
	 M8RdbqGXOE61txzOg2bpp9Dm4ehgSt4IPZOiJSkRdL+9xbYRNcqtdDM8SJO8Zyps4N
	 Yi24Hv2iSof181KQbkMAQW/94b5KMeM6TDdjOeGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 019/235] Input: synaptics-rmi4 - block s_input when F54 queue is busy
Date: Thu, 20 Aug 2026 16:54:15 +0200
Message-ID: <20260820145217.026452316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -441,7 +441,12 @@ static int rmi_f54_set_input(struct f54_
 
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


