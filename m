Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155FCA40;
	Tue, 16 Jul 2024 15:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144417; cv=none; b=KaJl58fpo1p0kV9MF5iZoSgei0hI6XPtntuey1bsLBNIwKO1Ni6XnPuGgarCpvTlm4JETvCKAG533FurHgaJJZhooN7Uj0g5OlmncfJMvFrsocnUWoQ+o+zZv8mC11jH90ek10Tlh9zfLasBV/oLecc6gpcywj+12y7UZI7UwJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144417; c=relaxed/simple;
	bh=rhXhi6NoV+CR+ZuXTbZ7VPNcf6XVMih0IDBc5zR2+rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV8eJLb7IwbCFwi131sqnygS99guXg5iQ6t8FzswWIq1uUFDtBkDZmvivCxPkqb93GGCcAxemOsOtwiIXWYLDxpYGXS61J7bTiGiLxD8Zlyve62Pv+siMPzT09fVFVUTY0T2Mr7CNFEsDF87IkTP+tazTaVnftpnTN/w1lgrm4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmBmtRTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmBmtRTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2756C116B1;
	Tue, 16 Jul 2024 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144417;
	bh=rhXhi6NoV+CR+ZuXTbZ7VPNcf6XVMih0IDBc5zR2+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmBmtRTUTY0N/ieOrkaFViBsE0wB4CLjt19iz4T3ynjnta/6Qemal/BmbFvq9OUH2
	 v6RZrtpqEbieo6fQzqO3oftoC0AmHRqMaixBYGW1i9kEnQycbLA0LRDab7ZV4+NjLU
	 sVuurpRODkwUHQ2XeC57HkE2PdEDM1Dd9ioCYkfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 66/78] usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()
Date: Tue, 16 Jul 2024 17:31:38 +0200
Message-ID: <20240716152743.196513108@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,9 +116,12 @@ static int usb_string_copy(const char *s
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


