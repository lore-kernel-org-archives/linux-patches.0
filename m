Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ED328137F;
	Thu, 13 Feb 2025 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457769; cv=none; b=qVkghK81MWgqmR4T5g0Co5DuR5+88kDGuz+UMpQal/DgpXvTZEld6cAStC4+rEPTV3RKKaQkRgfNeT416SOIUOQU/iXL884S/Vcypg/0xRGpfJEqJbezr+7uJwn3M5JftareNx+brKwmw0ncLYEJTjFIRvZmAuA8S2gyVlQVbos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457769; c=relaxed/simple;
	bh=zTmJMWFJVbvELehebH5wl8N6wngcyPcL6Tt4CJsJb20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD1paTqxM2t/4KIoHXjfvv0xejr/8KP+sjIYfkCBWXfGoP3TrMXEapxO/ZFtlD29aKOt7OvOLKDdujLN8pUEwk6Q4FB3NuxZjnQASvmbgFgyQel0t5gLTya/KmIUDEiugoEkYmf5NfyjhsNauMZl/XEQgDndk2uvGkEnijwonr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6tsfmj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6tsfmj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F3BC4CED1;
	Thu, 13 Feb 2025 14:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457768;
	bh=zTmJMWFJVbvELehebH5wl8N6wngcyPcL6Tt4CJsJb20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6tsfmj8y2njDodtsQRx21VBv9bAOR6z5WLVNYMteLdJaBDiZv4mA2luYWAI8z+JB
	 2FIpOK8At2dxbvvd7OPjg3tUtnC+Wiq5JyPTDV2ptYHhmA0NiiEpMr80KKJO14giVS
	 +A5naZpHsUaZzCyOoj7lQaZqgj8tL09nlecXduhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 209/422] usb: gadget: f_tcm: Decrement command ref count on cleanup
Date: Thu, 13 Feb 2025 15:25:58 +0100
Message-ID: <20250213142444.604623577@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


