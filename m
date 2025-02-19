Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2B81DF74F;
	Wed, 19 Feb 2025 09:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956999; cv=none; b=cMfJotO2IzO4B72tVUtN/jp3jX1AMVP8ygywdkPypwU7Qg7uNzWzRD6KmHA3yua6U3WLfIKE3rJPHjEEjEw0rrI076gN6qsQR5V885adRytuPyZcYlexzZDTcYCE16p7CPJWGbrxYUwDAXaOc4XJZZcwBJybV2rX+L07whr9498=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956999; c=relaxed/simple;
	bh=n4/giDNQMEDAERYSmMciVMUslC2lhE+R3rYtM09C94Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm4aoRU4OwoprWJPQc8lOXz0Uate5pTW5hYPOl4itgmBeysW9oK+2OZQWLQaxbz4bdXOmVzcDLoXDg1h1Wgjvs/gr1CGu5nKqAyn6CaVexTVQLLPtoQQZgDNmix1rHWssUhkGTcWe9Bd+Q6iCwYuT6/rmoaRO8Kn/IYaSTyQRZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBo6yuvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBo6yuvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2FDC4CED1;
	Wed, 19 Feb 2025 09:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956999;
	bh=n4/giDNQMEDAERYSmMciVMUslC2lhE+R3rYtM09C94Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBo6yuvpLc85guxW6nfgDahG2o12xUdEJkxcIF0mGaDsRGTJr2PejRDk98VNWHDaL
	 wLtIDnKtPJSie7TQw9sB9qpekZW7HyXa/SSkeOc38ddGafhjINK/VAK7F4jPobjL8R
	 SewDipAT8spqwoXSC5eq8vJXVA5HDNo19OAdpFwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 373/578] usb: gadget: f_tcm: Decrement command ref count on cleanup
Date: Wed, 19 Feb 2025 09:26:17 +0100
Message-ID: <20250219082707.689256579@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 3b2a52e88ab0c9469eaadd4d4c8f57d072477820 upstream.

We submitted the command with TARGET_SCF_ACK_KREF, which requires
acknowledgment of command completion. If the command fails, make sure to
decrement the ref count.

Fixes: cff834c16d23 ("usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3c667b4d9c8b0b580346a69ff53616b6a74cfea2.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -973,6 +973,7 @@ static void usbg_data_write_cmpl(struct
 	return;
 
 cleanup:
+	target_put_sess_cmd(se_cmd);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 


