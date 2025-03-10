Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DFC2D023;
	Mon, 10 Mar 2025 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629400; cv=none; b=fzeqaUoeAO4GVe9t7WqNQ+ST12dC3FoaJE4NNmGdKSvX0DMWzD4s3VAptw5FfUf0g1E8TvZjxZ8UA9eWeMDMfMCJ4d8+/zPvz5nOBk7btWdu+ZoHfMlXaZBCq9aUJ8ZayboKpR5XdWMNxDh1e8NdVtNzYPx3rT7yJ2cznFkIQe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629400; c=relaxed/simple;
	bh=EAp2qRpiwyEw4hq7TjdgdRckAzusFFzb5lwXrQMI1D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1eJL5TThmlxWWuY3zb4u4h3sjooaq4BZyvHZTn9wiBymOHClulgDWw1Rcf22Bj5S3L36ewUB2VzoWEx8X+eZPxL44k4E4BsNaM+KtdLoTnu0YWUuEKWQH+fMSEcYMmmTOvf3MgRky/2FZ1Tml6qvi86GjoGOIR2YZCEoHF4ilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpmeaLcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpmeaLcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A46C4CEE5;
	Mon, 10 Mar 2025 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629400;
	bh=EAp2qRpiwyEw4hq7TjdgdRckAzusFFzb5lwXrQMI1D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpmeaLccS1BwP+/kmtqYyJqQy5JKn+jf3kZsy03eawdNyyzAeZrO/i86uWxycGErl
	 4+Eb3gvpLo+Ohf86n/EbU5j4LcgrxjLzM6WU0MXFoBgvsjocBiIwab7dkQfasrhlm1
	 hlNuOAaJY9mOWGCXStUP1HcGk/ashcAGXBeUzNb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 280/620] usb: gadget: f_tcm: Translate error to sense
Date: Mon, 10 Mar 2025 18:02:06 +0100
Message-ID: <20250310170556.667361536@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 98fa00fd3ae43b857b4976984a135483d89d9281 upstream.

When respond with check_condition error status, clear from_transport
input so the target layer can translate the sense reason reported by
f_tcm.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/b2a5577efe7abd0af0051229622cf7d3be5cdcd0.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1065,7 +1065,7 @@ static void usbg_cmd_work(struct work_st
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+			TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1193,7 +1193,7 @@ static void bot_cmd_work(struct work_str
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+				TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,


