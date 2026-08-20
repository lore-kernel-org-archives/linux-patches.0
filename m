Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2438F272E53;
	Thu, 20 Aug 2026 16:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244007; cv=none; b=IRMpKytWKeSsS2HmWQWpQdAmKbVJsA17gTZzeEMvFLlxGRCpmYgYVkJtgfjud1pmboIzs4rUSxcLERAL5u2mBmTkHHBGmHRzcOGAXB1wPagNkT0NydY/XIM48/+8cVNm/yzdo8Eq3JTPNw/cGXqGqgQs8h35XT2lPXAUtDjP2No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244007; c=relaxed/simple;
	bh=t314vxrqKjVj/khsECsqmdr5x8RKVDScVitYxKIhxfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgPcJnLMpaGh9a13wZYBXAtDwQopcU87w4WN/OgAPrh75aFmg+L8xCRTLd5itDePRFI94qIklUjwDNvfEm0rntM96Bx6SkmVB3ouOAkgl9lmpFQzAzjd059vv4EMvpkYzOgUvjyGxum1h4yWOzTiBleNAN+gomnOCXGRwPv6p8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOELxjxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOELxjxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800BC1F000E9;
	Thu, 20 Aug 2026 16:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244006;
	bh=xLifJRvb384rX4B1Fxs9d4OW1FsAmiTArbT/mAhdNE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOELxjxriQzBVWpz01vClRwx4il49/Xd2v4oVzVJR/loCCZGYqA4uNII8XBngzo9Q
	 YLMw/T/aMdwDKFEKU7Xr4+dSX0v0LdsmyLZpiGffPn+97s88fZp4qy7MJ48lUefjKh
	 Xb7fAKLCfV3Lf5ZErr06ocA6sMG6O6FIAJD7w6yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 020/235] Input: synaptics-rmi4 - propagate F54 worker errors to V4L2 queue
Date: Thu, 20 Aug 2026 16:54:16 +0200
Message-ID: <20260820145217.055685934@linuxfoundation.org>
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

commit 8786d74bf50e6797b6f655eb381ef6b25451161f upstream.

Previously, rmi_f54_buffer_queue() waited for the worker thread to
finish but ignored whether it succeeded. If the worker failed (e.g.,
due to a timeout or register read failure), the queue thread would
silently return success, delivering stale or uninitialized memory to
userspace.

Add a 'report_error' field to struct f54_data to store the worker's exit
status. Check this field in rmi_f54_buffer_queue() after the worker
finishes, and mark the buffer as VB2_BUF_STATE_ERROR if an error
occurred.

Fixes: 3a762dbd5347 ("[media] Input: synaptics-rmi4 - add support for F54 diagnostics")
Reported-by: sashiko-bot@kernel.org
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260626051802.4033172-6-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f54.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -100,6 +100,7 @@ struct f54_data {
 	u8 *report_data;
 	size_t max_report_size;
 	int report_size;
+	int report_error;
 
 	bool is_busy;
 	struct mutex status_mutex;
@@ -334,6 +335,12 @@ static void rmi_f54_buffer_queue(struct
 		mutex_lock(&f54->data_mutex);
 	}
 
+	if (f54->report_error) {
+		dev_err(&f54->fn->dev, "Error acquiring report: %d\n", f54->report_error);
+		state = VB2_BUF_STATE_ERROR;
+		goto data_done;
+	}
+
 	ptr = vb2_plane_vaddr(vb, 0);
 	if (!ptr) {
 		dev_err(&f54->fn->dev, "Error acquiring frame ptr\n");
@@ -606,6 +613,7 @@ out:
 		report_size = 0;
 
 	f54->report_size = report_size;
+	f54->report_error = error;
 
 	if (report_size == 0 && !error) {
 		queue_delayed_work(f54->workqueue, &f54->work,


