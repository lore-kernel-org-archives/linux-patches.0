Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C45143736;
	Thu, 13 Feb 2025 15:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460515; cv=none; b=ICRe76DWekOOLVmU+uuj6n6Z+IQ9DF36nCRR/XeYLocvqHBZQZGoBFYqr5Xocy3gQ9Vop8GyA8scEYGu1ZBOjNgeSuoDhLQFxFcQGEgGIJJu28pFqfSOrFfP5HSiVQECyqnbwJX5wFrQBk6qT62PRHU3ASDJXit+KGRvgtagWVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460515; c=relaxed/simple;
	bh=RpQnUIzLnx+avYrGV7nvYmGlLz6I/HNyr9duQCj9QLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLazahG72GNXweKW87jVv6DdtyonfjqgwXk0Z23+HV0JlEhEhgp1wODPtG8SmAW2E3/MtyIcFxLtXbZdstI0l9gJahZK5GQu74kRjsRBcffQ2OV+Mjg50pqNy69gG30qQYq64u3i4MtASSQzMiR7rlwahmXSXV87jPuJXW4rUw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8GRajkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8GRajkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725DEC4CED1;
	Thu, 13 Feb 2025 15:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460514;
	bh=RpQnUIzLnx+avYrGV7nvYmGlLz6I/HNyr9duQCj9QLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8GRajkIQWneJImcIePK30qppGiq37l0P8mg9+dGXBDbDuqkba2b0xQhDVrmuMYPr
	 E3+eCRQa6ay7S+TsqsQB6fs40psTvAZwNFV8TArrWEr0SqZwPOXg4dAWPJPLuqZCCA
	 zXmtahlJg1T1YbZqxsu1Vwp+AIDRUUck3tohBRus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 132/273] usb: gadget: f_tcm: Translate error to sense
Date: Thu, 13 Feb 2025 15:28:24 +0100
Message-ID: <20250213142412.554539157@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


