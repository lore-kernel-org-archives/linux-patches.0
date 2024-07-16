Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99901DDCE;
	Tue, 16 Jul 2024 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145731; cv=none; b=jgiLMtGUSClpipp3YYF3ilp9V5rMVvkquoYixvTQ1FPwG0Gt1LODHarl05zbaL/LSwNE8o22JPbSI3O19+6KdleJNw9OLyZVlY/ISA/8ZnGBxkiian7E9Jdni3anHxfP38G3mvSK6vF3Uwk6rMFu41DHZeBaS+eoOgWDHEj6Ago=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145731; c=relaxed/simple;
	bh=4KNSWdpTTT9bn/Ir7JMPiS51tEjpZTL6Zk0YNiSTtbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYRm07wvrJkbSTRfhK4PLij3inVAvBnLRq7eX+skYNcJGbC7bqWaZRg/zn+l96QAfWben4BcfXTI94Igzau27gSKcA4ZDnk9IH5rIlRVLcnZhPQcLhIAnm50/qbtVatll+nwVJMasggolp0Sl/Y46lS9T4xkEKkWmlOul2nxTZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1zgUHkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1zgUHkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448A7C116B1;
	Tue, 16 Jul 2024 16:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145731;
	bh=4KNSWdpTTT9bn/Ir7JMPiS51tEjpZTL6Zk0YNiSTtbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1zgUHkCBxaU+FOLGpZMtyJgXaFgizGSHZr8my0F1Ej/nzzDXQvHShK+BcNJWapif
	 YEB/e0RamXQQmzXrr8IJXWujoGMlQFGqfNHR5Alfo2vKRlmEi7nlZtWhZb3Zd38M33
	 7poodz2UM4SPZC/YF2XaJ0E4fow/+nAwUPKkYbqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 066/121] usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()
Date: Tue, 16 Jul 2024 17:32:08 +0200
Message-ID: <20240716152753.867195799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -115,9 +115,12 @@ static int usb_string_copy(const char *s
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


