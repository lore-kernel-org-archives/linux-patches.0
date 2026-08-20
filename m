Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B726B361657;
	Thu, 20 Aug 2026 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243225; cv=none; b=YTIrKQGhlkSpqTSRUJBDdvK7ANNbc2osd+J6UbZbhyakS1p6MMIOaNDScFifNQsry4m7Kd/krSe7JGKMtAyvbEs4FBAElFB6Ra3BP1aQckc0pE+hBHFoRDnzCPTnu6Xl6I3VyTkYIKNljZgMMG2hdcImfKKIH0vDDQPO122z4RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243225; c=relaxed/simple;
	bh=5ZJPdMZ9jw8ZmAiuzNH7twJFhdVLyPGKlENI1+c5dsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2DpZWzfjuoNHQ+W7E2d/5J3PlirDRRK97b9To6TDGOH2/I/wDQTSjI2I55pu0WryX33dRrudpmHw69R7xQTlmt3dNAYNa7Z+V1UAmoavozvRYEa2HaBLDAo979sorPbKj5aqCgyJu/cXqHjlHXv5ByMZ03XtpvQQeTYMUl3aZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSyImsMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSyImsMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C241F000E9;
	Thu, 20 Aug 2026 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243223;
	bh=i6fZRVfDLcXiimJ2Jn4xdyDoH5FD+0eHscWhi/1cTgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSyImsMq6VVD+B7R9dJ9IrKbZ+ktCKlVIQmHw762OLtdchx9JVd1CocWxe4M1IRGv
	 Aj2LhtWFXOSWZ5WFrgB9VwRPaXhJDqmRqnKgpCZ5V9rpRVxVc3mqnfNuYfuE9wQ4QL
	 m+6LFfmWLiDg+/Nvq8zA9ot01bm92hMNtHULJcc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 020/272] Input: synaptics-rmi4 - zero report size on F54 work error
Date: Thu, 20 Aug 2026 16:53:24 +0200
Message-ID: <20260820145231.839559704@linuxfoundation.org>
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

commit dc76c3c8e8ad09362b8c1561f3928288c15cba2e upstream.

In rmi_f54_work(), if an error occurs during report request or command
verification, the code jumped directly to the 'error' label, bypassing
the 'abort' label where f54->report_size was normally zeroed out.

This left f54->report_size containing its previous successful payload
size. If a user then altered the V4L2 format to a smaller size, and a
subsequent run failed, rmi_f54_buffer_queue() would copy the stale,
larger payload size into the shrunken V4L2 buffer, causing a heap
buffer overflow.

Fix this by merging the 'abort' and 'error' labels into a single 'out'
exit path, and ensuring that f54->report_size is always set to 0 on
failure by checking for error and zeroing the local report_size first.

Fixes: 3a762dbd5347 ("[media] Input: synaptics-rmi4 - add support for F54 diagnostics")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260626051802.4033172-2-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f54.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -547,7 +547,7 @@ static void rmi_f54_work(struct work_str
 		dev_err(&fn->dev, "Bad report size, report type=%d\n",
 				f54->report_type);
 		error = -EINVAL;
-		goto error;     /* retry won't help */
+		goto out;     /* retry won't help */
 	}
 
 	/*
@@ -558,7 +558,7 @@ static void rmi_f54_work(struct work_str
 			 &command);
 	if (error) {
 		dev_err(&fn->dev, "Failed to read back command\n");
-		goto error;
+		goto out;
 	}
 	if (command & F54_GET_REPORT) {
 		if (time_after(jiffies, f54->timeout)) {
@@ -566,7 +566,7 @@ static void rmi_f54_work(struct work_str
 			error = -ETIMEDOUT;
 		}
 		report_size = 0;
-		goto error;
+		goto out;
 	}
 
 	rmi_dbg(RMI_DEBUG_FN, &fn->dev, "Get report command completed, reading data\n");
@@ -581,7 +581,7 @@ static void rmi_f54_work(struct work_str
 					fifo, sizeof(fifo));
 		if (error) {
 			dev_err(&fn->dev, "Failed to set fifo start offset\n");
-			goto abort;
+			goto out;
 		}
 
 		error = rmi_read_block(fn->rmi_dev, fn->fd.data_base_addr +
@@ -590,16 +590,16 @@ static void rmi_f54_work(struct work_str
 		if (error) {
 			dev_err(&fn->dev, "%s: read [%d bytes] returned %d\n",
 				__func__, size, error);
-			goto abort;
+			goto out;
 		}
 	}
 
-abort:
-	f54->report_size = error ? 0 : report_size;
-error:
+out:
 	if (error)
 		report_size = 0;
 
+	f54->report_size = report_size;
+
 	if (report_size == 0 && !error) {
 		queue_delayed_work(f54->workqueue, &f54->work,
 				   msecs_to_jiffies(1));


