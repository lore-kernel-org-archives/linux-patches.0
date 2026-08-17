Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1D43A80C;
	Mon, 17 Aug 2026 14:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976970; cv=none; b=LLKgOLmg7WRCuubJLCg0/tpPkOAPN4E9SESkrlQpmdIZ+yBeNwkYhryuZ4n6Fvn9NWqste424uQUOlSuELpEqYMre7DbyYFPQ6koiNuanPFB+TZNQmgSsHyw4vY/Lh9/T9zA1BzhjNQrhVRO61IuoshjIjd51MNpymm5t8HDd4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976970; c=relaxed/simple;
	bh=21eEraFOSBEi9IBVJv968dmXdvSw5HdebOHblX102g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiMbj/4Q0YWLErgqQfPfzzv9YLnUG91G691iFrjWuW98rr/AvbISKGSfbYYAukVM8YTj7/+/dyfDTa8aUHk1HfGrDQpmCzfrQKgXw3bA2LUISFpraP9YmQbqu5MUvcZ5DTvHwOADOGKhew7fOo1uGBgcFeZxjh8IygjUYW8c/oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul/fFPp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul/fFPp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C06A1F000E9;
	Mon, 17 Aug 2026 14:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976968;
	bh=u7A6AmuW+hFQfj4VzsAX+FytDiWEkI4N+sa8GbAGGWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ul/fFPp6QO4q+irtqhgbNzdz6+f4njkK8JSnyXJcuZWG2Y5UpQUZL0QG46DlO4BK+
	 S7sSZz9X8Fy5wrVi869DnUCP/S9hRChWxF57lTj5p75ig7j89IB8fMrt3HjHEOZub2
	 8UeBnDVIZAwCz+emuB6sSFGbE/SsOQ29eNLJY/Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 167/456] media: radio-si476x: Unregister v4l2_device on probe failure
Date: Mon, 17 Aug 2026 15:29:17 +0200
Message-ID: <20260817132546.629395885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -1504,6 +1504,7 @@ static int si476x_radio_probe(struct pla
 	return 0;
 exit:
 	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	v4l2_device_unregister(&radio->v4l2dev);
 	return rval;
 }
 


