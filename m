Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE177C0BD;
	Wed, 21 Feb 2024 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523576; cv=none; b=jrqiHqEZaCTcw/CF5Z+bt0+EMNfvm2gMhx8qgkSaoSixMYA4jTTE6mTHedxSNdGn39Bc/rFHZJ+Gi8wHJW7o+CxR4UfxO4MOIBSA3v4TqeqZvyPg6DvfSZw+Iu/DtPNhzhXvexa2USzTWKKkwlfBvhYKR5Vx+rb0KgxMfS4zKGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523576; c=relaxed/simple;
	bh=2CjHgdx1611UfKdHF+04xDBzMVrIqSuTfhRD7tIAvAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fL7dom61txYlYQv74NuLn+0K9sN+8CsOEH5ng85w14zpjer6/xhUfbyGuSBpY+cqzo+1guO3o33HtHxNbtQBrJTTPd6FRWlfGX6ErikkWwb9kZrGeqtFWh27pKLiBeel0InhFG2b4oyZoXNYhFfu4KqZaI/uvjZyaIQz2EmttXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLRI8Opw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLRI8Opw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F089C433C7;
	Wed, 21 Feb 2024 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523576;
	bh=2CjHgdx1611UfKdHF+04xDBzMVrIqSuTfhRD7tIAvAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLRI8OpwXyC7qlnua8yZt2+LLy6KspCBAT6BxP/6cAuwBKE9RLtPXxAqM3SPjt7Rh
	 Td8fOMrRM1ZW9I2rzUivS1bj6AAkElocEPXI4lzbS/ZYFA91yyDjz7C+P8YWUtb6eB
	 Kwhu4NwDGNUOkq0R3Nk4WR1rmhWL0XbkJSkzlNtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 476/476] usb: dwc3: gadget: Ignore End Transfer delay on teardown
Date: Wed, 21 Feb 2024 14:08:47 +0100
Message-ID: <20240221130025.577794706@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit c4e3ef5685393c5051b52cf1e94b8891d49793ab upstream.

If we delay sending End Transfer for Setup TRB to be prepared, we need
to check if the End Transfer was in preparation for a driver
teardown/soft-disconnect. In those cases, just send the End Transfer
command without delay.

In the case of soft-disconnect, there's a very small chance the command
may not go through immediately. But should it happen, the Setup TRB will
be prepared during the polling of the controller halted state, allowing
the command to go through then.

In the case of disabling endpoint due to reconfiguration (e.g.
set_interface(alt-setting) or usb reset), then it's driven by the host.
Typically the host wouldn't immediately cancel the control request and
send another control transfer to trigger the End Transfer command
timeout.

Fixes: 4db0fbb60136 ("usb: dwc3: gadget: Don't delay End Transfer on delayed_status")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/f1617a323e190b9cc408fb8b65456e32b5814113.1670546756.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1701,6 +1701,7 @@ static int __dwc3_stop_active_transfer(s
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
 	}
 
+	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	return ret;
 }
 
@@ -3710,8 +3711,10 @@ void dwc3_stop_active_transfer(struct dw
 	if (dep->number <= 1 && dwc->ep0state != EP0_DATA_PHASE)
 		return;
 
+	if (interrupt && (dep->flags & DWC3_EP_DELAY_STOP))
+		return;
+
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
-	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
 


