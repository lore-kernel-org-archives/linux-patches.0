Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFAD35DA67;
	Thu, 30 Jul 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426173; cv=none; b=d+6gv6fhuANKDj3bQjcDceGqNVqqhrADPt0yz80VOGMQF5Oh41DmsQlv/W/X2XR4uL0BsTv4QBghbi9+Ha+k+YxL2PE02xQWCwtYjMPZg0TJkP+XB6DTVfIM/JqkOvzNryC3F0Q2FF48hUlEZNwn1kco2xP0guWlrsQOY0iZtAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426173; c=relaxed/simple;
	bh=1DY4tOp0NNMpwin+O0Ku97rxMnV+enF3fOgGLXcXx7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS/4aNb2SHqVE3DY5BacSr4fNrG3kADfuo2Nd5cSPKOyxY5S8NMqsdhYBnriZiUkv8CneE4ySvDSlpAzyzDYbi+4MZeEXTE4LVYVcEonBuDkaQNS3Nh2cAveYVlzX6WxWaGpOH1g9E60olCwf+immsbC1jtI25N2wevhNVcnznQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJLULjoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJLULjoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A461F000E9;
	Thu, 30 Jul 2026 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426172;
	bh=w7rJmMkSTsGiwAMGshAtxBqNqeTnUtuJ4mimJYsCbBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJLULjoPS6WAcQFbCtoitthkPvUBTBY3P/8vxkHrps5e4sj0sW2tfnT1QYu/cgER/
	 jBm14TCJBkQy7XCe8JEOPSPHNkABONZq/0IupGSv6nUFTlN0u/VelmR1gfZRczibAu
	 d+ttftn/R0iy1NpqyiywnxotrUIEn1VrowtdPWhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 324/602] media: radio-si476x: Unregister v4l2_device on probe failure
Date: Thu, 30 Jul 2026 16:11:56 +0200
Message-ID: <20260730141442.773958064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 436a693af04ffb889aaf87cb69ec1f2b21d3569c upstream.

si476x_radio_probe() registers radio->v4l2dev before allocating the V4L2
controls and before registering the video device. If any of those later
steps fails, probe returns through the exit label after freeing only the
control handler.

A failed probe does not call si476x_radio_remove(), so the
v4l2_device_unregister() there is not reached. This leaves the parent
device reference taken by v4l2_device_register() behind on the error path.

Unregister the V4L2 device in the probe error path after freeing the
controls.

Fixes: b879a9c2a755 ("[media] v4l2: Add a V4L2 driver for SI476X MFD")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/radio/radio-si476x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1493,6 +1493,7 @@ static int si476x_radio_probe(struct pla
 	return 0;
 exit:
 	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	v4l2_device_unregister(&radio->v4l2dev);
 	return rval;
 }
 


