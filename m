Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727035200C;
	Thu, 20 Aug 2026 15:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238177; cv=none; b=F+Ar4ZhDanY3/fjWsnFpjFwLea8RYecRAVYB7oZBtt7yZbQiULxc7Eq+j9DS/PXENMqRHwc3mPdngsPwdqZwXiL2y56XCkxbkrYfVpsF8hRp4EcwpVQ2b0CCA7Qfwzq/AdRpS7R+LQZ2mwd1H2q4d9z0yySaE1xSj1777JiCIfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238177; c=relaxed/simple;
	bh=7VHbay2uLtdzzrj0xvRNvfBa1VHOA5UQfeO7S7XT4ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcEtfdvcCAv06xhZRDXuuDshL4+90F/EF4exjUZkK28yIDs0e9gMKzykl2EQNubyY7hJIPVc3Mz4/WVbidcJQO6ABkivxRWdUfDluXjdWpzQ2aj6tFOtNdp5iFWcwde6jkxvFXcffdkYpIMbcCDLS37671E+C0FCyxRyqfRRE9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJn2hqu2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJn2hqu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288FE1F000E9;
	Thu, 20 Aug 2026 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238175;
	bh=8U4lWgtd2172JpkpeV53lsi9NgveAlugr7ODe0D6g3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJn2hqu2LU2qeTvAcaYVnWBz2DX09mCWHKx6ayFucL3dZCrxu9HWaAvUhSq1cbNHq
	 5lDS3n5zkECW5rlE8LZ/z/q29kUmWrcdnII3Xb5oNdkkTkaY+pbM5G0HqFNssSR+3K
	 uzHhdFtSgRbtJfOFOsE1bG6iRaL/++tScT22M3Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 055/228] Input: synaptics-rmi4 - propagate F54 worker errors to V4L2 queue
Date: Thu, 20 Aug 2026 16:53:17 +0200
Message-ID: <20260820145246.147976888@linuxfoundation.org>
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
@@ -106,6 +106,7 @@ struct f54_data {
 	u8 *report_data;
 	size_t max_report_size;
 	int report_size;
+	int report_error;
 
 	bool is_busy;
 	struct mutex status_mutex;
@@ -340,6 +341,12 @@ static void rmi_f54_buffer_queue(struct
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
@@ -610,6 +617,7 @@ out:
 		report_size = 0;
 
 	f54->report_size = report_size;
+	f54->report_error = error;
 
 	if (report_size == 0 && !error) {
 		queue_delayed_work(f54->workqueue, &f54->work,


