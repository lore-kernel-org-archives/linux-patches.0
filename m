Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206F6CA40;
	Tue, 16 Jul 2024 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144242; cv=none; b=SUaJs7cofRy8ayXKtLLZYIiT2gBGtaKxp4prSB/kOcJ5EsEhUoBGOnU2PV32eLRrRyFbd60BViWYnQXap/OHVhNNV6RrmOigZ7ioXikMYswnqfDxoZEsA1kSai2MDzK+yI4sNjA3ibTeo7lK2NYyfc59maoK+sesvXxLyvK/LEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144242; c=relaxed/simple;
	bh=yUf4dKOAOERMPOO6oUAjQbPYjATNIMhVlShgRYXixXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBHzC+3BPceBaD1JzjQRVusJyVfG3eASIx7haiJgAEWTRTnmsWZwd0T3KOgOFGk1daS3tql50DBMYWGn8DhPGh7ITCuYeGnO1DmcOHw1f7DzhvbYZHMU9kZW+20+K8hkEFPGo7ETPZMYHtQ9tLC7DT2nrs5tqAqCiZqljvaHVKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWDJtj4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWDJtj4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EE6C116B1;
	Tue, 16 Jul 2024 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144242;
	bh=yUf4dKOAOERMPOO6oUAjQbPYjATNIMhVlShgRYXixXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWDJtj4SBEy9LFMnDB0YSdNp/HSjj7ySq7u8MLxHT4xiut3gmOEyJDrgUbCmDQY0N
	 OjV13FbIPXolYNAfzT3HDHudejpCMX/8H9dR5DJEOOH87ja2b4hRugvMxzkBexl0pa
	 myWcOWW0dWQOSE7cDMeV5U7IIHY3C/7zZ96wl7Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 56/66] usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()
Date: Tue, 16 Jul 2024 17:31:31 +0200
Message-ID: <20240716152740.301483416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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


