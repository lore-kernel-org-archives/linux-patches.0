Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A017A93F;
	Tue, 16 Jul 2024 15:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144724; cv=none; b=rtsWRO/H0LcDCpURBbnZjH5q4r4088QHSHTsaxAXXLd5CJKwSO5MbVx35ORrog41GPLL5h0t03XcawWWNgdnLRuP/eOQAAaleOpxrQiCoBFTe6ybG7LfHElnHWmLJqFTUbSZltIiddP7y5LcIuE68OHsd/XjAf8OwVeBqBczAV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144724; c=relaxed/simple;
	bh=b+NDRqboVOUNr8KOKq8et6BJp+ruLBtPAS/jy5wJmCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwUm37y8csQ7j7DPg2rL6l28uL8sD4NIvnh5xGcSUYm0Z1rzCLvSETK6hDuvKpVbHQQj9Uvkh5nJIKT6AC6dlq3wY/ilrT3+ZNRVUKWF5xkdhU3pSjs/RCNm51qo0R75niNMrTzowpNXzljh8bGU5QVV6VdN3bMz5dOON8zpqw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmoERGN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmoERGN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35F0C4AF0D;
	Tue, 16 Jul 2024 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144724;
	bh=b+NDRqboVOUNr8KOKq8et6BJp+ruLBtPAS/jy5wJmCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmoERGN0YzvQ7peT/jl8+M9aPa3/50wR0usP3NTWB6qvBSRUH7sKkMGndPDNL+ciL
	 U7PMRsHVDmu0qi7OGEjroG7ezA4eNlOtDZTO6mNgewkTnx8YAMeJxo/K5xPjj4X4kx
	 yDwNcKAI8cPERAGAQlcQLvSbbEwCrbw4/qV94o0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 084/108] usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()
Date: Tue, 16 Jul 2024 17:31:39 +0200
Message-ID: <20240716152749.209238268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -104,9 +104,12 @@ static int usb_string_copy(const char *s
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


