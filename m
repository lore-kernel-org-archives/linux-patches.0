Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5FD19E7C6;
	Tue, 16 Jul 2024 15:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145419; cv=none; b=PJxX77NXmCBq20vlxKO/ljMNwY7dkDoW9BgKiYi8cgs8d9+GiYm0Kw6ArE1fbALARKivWLMnA1w7PFb6H7JcnruwS77tpown5aukuI3ZPUr8tht/o6iRNBvlKWsiJQbOE/FYpYxFBrHSaAILphE+uFSXiwnu9jHbAI9zzokvds0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145419; c=relaxed/simple;
	bh=EfCUrqkFip7/4fgDe9/9csOptPySJtLTlFJpLPdKMtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bn7J3jcTBkJpwRYMwN+mnD/0svsO68be2GI25VtaQJAgaoJABuMUEyJ14j5AH1JnJo5SMMxU60K+A2rFCCJJcQLKtQqDutjf2VnrHg9oaUHjSe48LhElFoX/67pms9rwkLNrgIivKM5j6+vozoMp9/MUP9CsHDqM5V9MuILgxFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeiLU24b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeiLU24b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10993C4AF0B;
	Tue, 16 Jul 2024 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145419;
	bh=EfCUrqkFip7/4fgDe9/9csOptPySJtLTlFJpLPdKMtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeiLU24bnzlMOKc0OA4eQvtIeTdMSKw2nn5yuDfoxpaE3ltRL2cAC5w7TcxgOmBNG
	 BWjGPblWuSy5WFNhNPMKBqO5P2Qr/NnDVaSXZLT8PSivK8YM1tWn5EtQETpM1YUDbs
	 jIK8uo3LgYlJod1LFjJPAowKGlansvpaqEbYd+60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 58/96] usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()
Date: Tue, 16 Jul 2024 17:32:09 +0200
Message-ID: <20240716152748.736646074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

commit 6d3c721e686ea6c59e18289b400cc95c76e927e0 upstream.

Userspace provided string 's' could trivially have the length zero. Left
unchecked this will firstly result in an OOB read in the form
`if (str[0 - 1] == '\n') followed closely by an OOB write in the form
`str[0 - 1] = '\0'`.

There is already a validating check to catch strings that are too long.
Let's supply an additional check for invalid strings that are too short.

Signed-off-by: Lee Jones <lee@kernel.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240705074339.633717-1-lee@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -105,9 +105,12 @@ static int usb_string_copy(const char *s
 	int ret;
 	char *str;
 	char *copy = *s_copy;
+
 	ret = strlen(s);
 	if (ret > USB_MAX_STRING_LEN)
 		return -EOVERFLOW;
+	if (ret < 1)
+		return -EINVAL;
 
 	if (copy) {
 		str = copy;


