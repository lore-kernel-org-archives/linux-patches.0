Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441FF5FEFE;
	Tue, 13 Feb 2024 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845125; cv=none; b=gQEsTT+Q+9blzm3BrytD8EhO40nTHmnRyf0j3cnbXnfiuZMp9LTT5MzdQJs4Kh8Bj7P6Ia72jljwM8zRCtWpwCAAKwTdh9kxdbeoCS3bPw/77+CYlq8oLCnv2LTRnFptzB46cLH3qSgHSlJdil+Iu7C7X8uoNXcUerpNUBqrUH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845125; c=relaxed/simple;
	bh=QX5VOy/lj6xWBIcbfkN/VtZhbLV1paXakFWr2/gx2MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVGe7xQhwI2FOEHdAHEdUBRiS4HVhiZEGYHhN2SeDi40Ej14p9V7h89k+puNqSKDZI2LRUOdgTZ4DbQngA3scuVo02CbWw+uI8GAz3/ZqSgayOjZtM00IPOonWH/Aya52e2rYTW9x+vHNtFOCoQOg8Z1S00tVNh8/OifrriPhgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjOpcuD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjOpcuD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B066C433F1;
	Tue, 13 Feb 2024 17:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845125;
	bh=QX5VOy/lj6xWBIcbfkN/VtZhbLV1paXakFWr2/gx2MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjOpcuD1os/Cv1bVcbHlqEds9p5OYbJlsrtslzIuGO6weURK7iCQxTL/fWftS2Br+
	 LhjE6j5Zgx6v4862kLeK0gJm3x2V2FhochNZtheNvm4PhaE+005lYkJ3m1/g+yrz7d
	 xtzezPw/3S/V5aiKecWI9YP2u/DJMedjbHyySiPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 54/64] xhci: handle isoc Babble and Buffer Overrun events properly
Date: Tue, 13 Feb 2024 18:21:40 +0100
Message-ID: <20240213171846.431299262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michal Pecio <michal.pecio@gmail.com>

commit 7c4650ded49e5b88929ecbbb631efb8b0838e811 upstream.

xHCI 4.9 explicitly forbids assuming that the xHC has released its
ownership of a multi-TRB TD when it reports an error on one of the
early TRBs. Yet the driver makes such assumption and releases the TD,
allowing the remaining TRBs to be freed or overwritten by new TDs.

The xHC should also report completion of the final TRB due to its IOC
flag being set by us, regardless of prior errors. This event cannot
be recognized if the TD has already been freed earlier, resulting in
"Transfer event TRB DMA ptr not part of current TD" error message.

Fix this by reusing the logic for processing isoc Transaction Errors.
This also handles hosts which fail to report the final completion.

Fix transfer length reporting on Babble errors. They may be caused by
device malfunction, no guarantee that the buffer has been filled.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240125152737.2983959-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2381,9 +2381,13 @@ static int process_isoc_td(struct xhci_h
 	case COMP_BANDWIDTH_OVERRUN_ERROR:
 		frame->status = -ECOMM;
 		break;
-	case COMP_ISOCH_BUFFER_OVERRUN:
 	case COMP_BABBLE_DETECTED_ERROR:
+		sum_trbs_for_length = true;
+		fallthrough;
+	case COMP_ISOCH_BUFFER_OVERRUN:
 		frame->status = -EOVERFLOW;
+		if (ep_trb != td->last_trb)
+			td->error_mid_td = true;
 		break;
 	case COMP_INCOMPATIBLE_DEVICE_ERROR:
 	case COMP_STALL_ERROR:


