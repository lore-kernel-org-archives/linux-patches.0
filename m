Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0AC17A930;
	Tue, 16 Jul 2024 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146284; cv=none; b=TKsJ2EJOHQX+iuUxj52B+3WkVG//j8V5zzg4h0kfv2aoJnXWc8RL2kPRBXNmaMNkZE39bUKNeZorEzeFrHb+1gurkpr7CMqweM5op66Lgv9xG0FkxnQm0OTV24BOi9O0oPEGQ62IicncSlhj0AHBfKCcqs48dPUYIgJvVc9A5Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146284; c=relaxed/simple;
	bh=iU3B51eEHh2mMauHLGo+MK1PARXpLSFgxhj8q612wQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk8bpHQcsGEGjhynzOMx17CNGBsJ8UwHhhDHWq5VAlSRaB8DmYU2ZoPxdiCV3/ECiWYJjn//VCHvSrjgTUlw2RcxuAOkGn7KMLLa3PBniLmQlu2JH5S5pZs0qtruQ4+ux2FAViKHAe9IoYgGTqZUW/lI21CH3L3wVBNN+bRlBF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/Nr/5/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/Nr/5/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29114C4AF0F;
	Tue, 16 Jul 2024 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146284;
	bh=iU3B51eEHh2mMauHLGo+MK1PARXpLSFgxhj8q612wQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/Nr/5/xP+kW9lf6FWs3YViojBFv+zFSfD178MaFmmBEs2M9QajHO8XfURIh88RSd
	 obE1HotUqvAmPU94MSqa15CtDAzuE43Ey1sly/TY+qRJ70zSdgHP60V9OPH2bBd6Yl
	 a1qqL3Klzn3sLqDJojx03d81IrksBnjPZ+cGb3rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 115/144] usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()
Date: Tue, 16 Jul 2024 17:33:04 +0200
Message-ID: <20240716152756.950040249@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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


