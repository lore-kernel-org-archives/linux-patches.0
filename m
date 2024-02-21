Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E68169953;
	Wed, 21 Feb 2024 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521791; cv=none; b=MquwjwNi/51xHuxj/ouivwn1FCxJJXlZxsnyZh4VYX9GgGQp+n0+Yn0cOWzDZ/CJA7FuCW/WIiMokXlUc0uYiaNl8ea2zqc8Yf88TGFsH7lbr+jPy95NRYyHZNt1Awo/FO9ZVGU6bydJY7QFN5io6f4fxxXqRPRaMUxSHloOQAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521791; c=relaxed/simple;
	bh=8YWacNbPHASAlsInNuHgTQzH00KA9UbAFHDWuUK36n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhhQQD1MNXEnHVarsJd+Z3wchERkObm2NRK7SvnspmtJoJlfRJY79CE3q4csWHCw/puAtu3nI0moFBaczyETgqGApYFAbUZCV3b4TVcVPM1/0mpEQN2oLnIHh0L5d/i9Cuq5yDA1Xf5LqlgBVoFJcVtrcZ0IsI2FPEuYv35hOMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIjgCy02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIjgCy02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C2FC433F1;
	Wed, 21 Feb 2024 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521791;
	bh=8YWacNbPHASAlsInNuHgTQzH00KA9UbAFHDWuUK36n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIjgCy02qeKZk9DvXlX7yw9JLp5R/ewpwnDSAR2dJibCItmcRM6WWFQb7wDf7mvml
	 Mq8WP2txUNqOeaZCUV0m/Kq6p1TQ8M6NXyvbKRTRGFEMmgxS6QYsBkdx3c8EKbTSxA
	 iXh+Jj731Sxyuhx1CN+uGJ8aAxTuc9/4uTGj92pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	yuan linyu <yuanlinyu@hihonor.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.19 178/202] usb: f_mass_storage: forbid async queue when shutdown happen
Date: Wed, 21 Feb 2024 14:07:59 +0100
Message-ID: <20240221125937.584441950@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yuan linyu <yuanlinyu@hihonor.com>

commit b2d2d7ea0dd09802cf5a0545bf54d8ad8987d20c upstream.

When write UDC to empty and unbind gadget driver from gadget device, it is
possible that there are many queue failures for mass storage function.

The root cause is mass storage main thread alaways try to queue request to
receive a command from host if running flag is on, on platform like dwc3,
if pull down called, it will not queue request again and return
-ESHUTDOWN, but it not affect running flag of mass storage function.

Check return code from mass storage function and clear running flag if it
is -ESHUTDOWN, also indicate start in/out transfer failure to break loops.

Cc: stable <stable@kernel.org>
Signed-off-by: yuan linyu <yuanlinyu@hihonor.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20240123034829.3848409-1-yuanlinyu@hihonor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_mass_storage.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -574,21 +574,37 @@ static int start_transfer(struct fsg_dev
 
 static bool start_in_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
 {
+	int rc;
+
 	if (!fsg_is_set(common))
 		return false;
 	bh->state = BUF_STATE_SENDING;
-	if (start_transfer(common->fsg, common->fsg->bulk_in, bh->inreq))
+	rc = start_transfer(common->fsg, common->fsg->bulk_in, bh->inreq);
+	if (rc) {
 		bh->state = BUF_STATE_EMPTY;
+		if (rc == -ESHUTDOWN) {
+			common->running = 0;
+			return false;
+		}
+	}
 	return true;
 }
 
 static bool start_out_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
 {
+	int rc;
+
 	if (!fsg_is_set(common))
 		return false;
 	bh->state = BUF_STATE_RECEIVING;
-	if (start_transfer(common->fsg, common->fsg->bulk_out, bh->outreq))
+	rc = start_transfer(common->fsg, common->fsg->bulk_out, bh->outreq);
+	if (rc) {
 		bh->state = BUF_STATE_FULL;
+		if (rc == -ESHUTDOWN) {
+			common->running = 0;
+			return false;
+		}
+	}
 	return true;
 }
 


