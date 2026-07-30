Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38E9384CDD;
	Thu, 30 Jul 2026 16:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427674; cv=none; b=h3mjgRuMlX9kWQsNLXcXOYTWHSeNerSuPD3HK3eo+E/x+JwpQd2Jw56iG4BgXBD1ae8zUueth57lGTnxqktDFSf0rS+wIg18L42BcYW6J1fG++Gijx4OlawgVceoWNSvTP/rRW3HPWhE/dI2+LzQKu0TZYrFOQCjcLWRtodlTaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427674; c=relaxed/simple;
	bh=wrkmXOCq7Hw7NxTtf22qPeVzB60vxQsCaS0Qa3CwKxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRLJsmxyeLbMuP6jfpccK1RbpuHbw3YinQWsEArg8Pl++Cu3/KavX8DT3mu76aM5YLPQzzKuroNxd3HHj5SoFAfIufUY/W/KsJKPcBwSObzxer5QA8TMfi6VBX+HRkCdfNr3mD2G2o9R92AolC7lL3IvozM3iPNZtl17LOSfWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyxG1Qs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyxG1Qs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EA31F000E9;
	Thu, 30 Jul 2026 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427672;
	bh=hCF4O0uPyu/yhfcT6vhAZ+dRBDLg4tfnHbnzv9KlfeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyxG1Qs1QCSVs82QY1Y50edXdc4oJa6OLPkQf9vwm6ry32enza5muoqaF7bI8Kvyi
	 YbSEKCDZL8BhGtrVGIso+qTxmf0KSI52ve9YDsGWHNzvBthVfhlvbkaDJYZgReatMr
	 RjBLc0onQJ9BzJ+HfV0f5Lyh71vowXfLVW61ieLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 253/484] media: radio-si476x: Unregister v4l2_device on probe failure
Date: Thu, 30 Jul 2026 16:12:30 +0200
Message-ID: <20260730141428.984907921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -1495,6 +1495,7 @@ static int si476x_radio_probe(struct pla
 	return 0;
 exit:
 	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	v4l2_device_unregister(&radio->v4l2dev);
 	return rval;
 }
 


