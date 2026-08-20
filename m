Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6DA35200C;
	Thu, 20 Aug 2026 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238164; cv=none; b=snVWXQVYAJowT39lsQCt11iYJUCvbYg1KbJuAVorpiPlPu9nlEg6yeUwLDTZW2WmKGezWvHbMsTuAJTgRc8ILKvUdcoCdCbFCNsfqUbxlBcU9NGdYcog2LylfwDDJdXuIgrVoG7jIm0r6dGmb5gGKdDHbDX/HmlmGubnyx2Xdpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238164; c=relaxed/simple;
	bh=n/MDtF20pUNQ8xovEUpUOTCPNc2ARUwEpQcO4z16S5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6smbWnsf88uMlg04+prseVzmSYcFhy2ujJu9Nh96ruJhsn4+6qgiA4bT1uNvx6h+6TI6JTyjEd/VSk6Mjt8JKuIR/F0CbOmae/rom9IofYnAu68rQOtSnTHyx+xXnn21igxakbbkytwE3476enYFeKGyc4MKrhGqOk9Kv7k5z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWMWnuiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWMWnuiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968DC1F000E9;
	Thu, 20 Aug 2026 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238163;
	bh=+S6JRPHDQjvC62mSbLrYgNnV40+PFoZBUfLOrLf8kaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWMWnuiWQJgA+vX6JIdlWVMIrCBpzEEYu3KxRk1hW8AZCsstwiVtQpwkE4Y3EzoOs
	 Eu1slkijVViiZBtUZFNL3xiaZgVCKrxzKyXoWRCq1e+4yPXQqILl+trahXf8RClrTo
	 +a1oB9ya0B2sLiLtT7igHs2oYXJ4iND0J894c0vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 052/228] Input: synaptics-rmi4 - zero report size on F54 work error
Date: Thu, 20 Aug 2026 16:53:14 +0200
Message-ID: <20260820145246.054241616@linuxfoundation.org>
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
@@ -545,7 +545,7 @@ static void rmi_f54_work(struct work_str
 		dev_err(&fn->dev, "Bad report size, report type=%d\n",
 				f54->report_type);
 		error = -EINVAL;
-		goto error;     /* retry won't help */
+		goto out;     /* retry won't help */
 	}
 
 	/*
@@ -556,7 +556,7 @@ static void rmi_f54_work(struct work_str
 			 &command);
 	if (error) {
 		dev_err(&fn->dev, "Failed to read back command\n");
-		goto error;
+		goto out;
 	}
 	if (command & F54_GET_REPORT) {
 		if (time_after(jiffies, f54->timeout)) {
@@ -564,7 +564,7 @@ static void rmi_f54_work(struct work_str
 			error = -ETIMEDOUT;
 		}
 		report_size = 0;
-		goto error;
+		goto out;
 	}
 
 	rmi_dbg(RMI_DEBUG_FN, &fn->dev, "Get report command completed, reading data\n");
@@ -579,7 +579,7 @@ static void rmi_f54_work(struct work_str
 					fifo, sizeof(fifo));
 		if (error) {
 			dev_err(&fn->dev, "Failed to set fifo start offset\n");
-			goto abort;
+			goto out;
 		}
 
 		error = rmi_read_block(fn->rmi_dev, fn->fd.data_base_addr +
@@ -588,16 +588,16 @@ static void rmi_f54_work(struct work_str
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


