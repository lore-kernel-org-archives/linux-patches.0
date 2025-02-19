Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DBF1DE2BE;
	Wed, 19 Feb 2025 09:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956996; cv=none; b=BIPPFrKhd1GU9j/DG67FvCDl1mFz5iyPReLo+CAWbXXsQjgTc44Q4sDLd3hf6L+CBNbBMx5Kn8Broc+Kq0jREIhS3s86zxBcm1k4JXiCNEcYOfRGivfg2Ze27S76fJQ2L7vFVZ05N90mrvLf9jjIGee2wzP4x8eyoChpSUtIs3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956996; c=relaxed/simple;
	bh=t8qRuyn2x068PYVLDHfOMVNARbeq7TxsXjjd4Sz67E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZgxTvPZMRzg6SblyRed/1aAGG2EklapXZ/wBbHYUZNwz8dvKVFOh5hE6TpNEiqbT7lcregS8oC4tTUrh40DIm9kjkCyzWmXFlgPDiRD2/lokawgUjqTzG0JOSsZhgQgs9JoTmsFFbtSbqmeuLaZL9wrbCx/qscgPAGHc2c1tFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7xhTUnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7xhTUnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AC8C4CEE6;
	Wed, 19 Feb 2025 09:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956996;
	bh=t8qRuyn2x068PYVLDHfOMVNARbeq7TxsXjjd4Sz67E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7xhTUnw4pogA4NCxJ5JakORaMT3hkcKfwUIigd2eatHIFqPwsxe+k6HsRkAWoqzr
	 0bXfq+Vt2Nda6M0XG4nUuLetahiZ2c4f5Nb7/MMeOL48x6ii88jwa+qnazH2zWtfMm
	 ynX/m8pHnPKeK91D6Tvejycd2RBN1kfzgrrXjqFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 372/578] usb: gadget: f_tcm: Translate error to sense
Date: Wed, 19 Feb 2025 09:26:16 +0100
Message-ID: <20250219082707.651363205@linuxfoundation.org>
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


