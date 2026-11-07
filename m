Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060679;
	b=1K7yZFjD0sxXj0QDT2EFAkyJmDcvcK0rKOcwgHlPvBBsV/sW8MzwrxtggEpSns0ljz+w
	 TN7tiFDm5/dwUj6mieTyBKQIIU42ishyhKC9wEbAkrNQ18lCZKIqxu+L53aIAvjBXPhpT
	 gnFixdZ8hNB09hVFyjcVTJFalQDXP3R/+JzA5NSMj8tcdT06DVFIiLsFk/EimBMzYNSd5
	 A/F25MbxuuduPjC7ef33r7CWlaf2Hn3d8PMlogXwkEYoDp9Y/KElA84Ko/rNMVmXff71S
	 u99mL8glddIGr7RqWHvHEvH9b4M6iJOBnayVqOjPbECZrmPfls7w9AwoNMGAUkLibmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/oAZNhh/swqH9c4OdM3yT6N19iswaKchvDuh4Uvb1M=;
	b=3y4p9GRtLKXwUiqqOHIky+mDcDEA8mZFBD79BQ6VXoNJOgx/fCRhWOn87t48XkMbHTCQ
	 oaJWjzyviQmyplc4ffWx8R8xboFdNIBu9MYOCnO1b42MS76jg4C5ff+EVo5bwc0t/RvP/
	 9H2Q0pKf0CEZ1jsSr5v0ne0GuyiRcU8gJgf1fqkeVppW0Z62sBRpG6m35n6wnX9OfGjKn
	 su5RP14Lyn/lwnkp5MjD4QOgJPf5CpAfpLpDi2e496ih0uvKl4pJmQzSP7pS1C42yC8U8
	 h3tzCEBHRG1dsb0/Agb928raRQNyFWeKqb5r56qtFEO7K4rYJxelOiL/nruRq+uwIqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5ukO3Hx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEE4606A32D;
	Sat,  7 Nov 2026 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5ukO3Hx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D651F0089F;
	Sat,  7 Nov 2026 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060679;
	bh=C/oAZNhh/swqH9c4OdM3yT6N19iswaKchvDuh4Uvb1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5ukO3Hxp7GSbizVsogxLIqDAdxP2eJDDFxJDzNzQW9w5rDuE9dJ3j3whlHSigmsM
	 BnutARYWcdvaCnoUc9+6bGr5HHG/WKvrsWYLisW3rdf94hVWXyx6ARxtrI4sQJnlLo
	 eFHspbK4B4HfTWVj+2RTT5Df8MNBjJAOxNFPBFAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0112/1536] usb_string_copy: Use kzalloc() to avoid leaking old data
Date: Sat,  7 Nov 2026 08:35:28 -0500
Message-ID: <20261107135000.821537254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 057df423bf4747091cf942af57307627e941e1fb ]

If the string is read while being updated (which is why the copy is done
in place) and the new string is longer than the old one, then the reader
can read memory that isnt part of either string.

Use memcpy() to copy the known length string instead of strcpy.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Link: https://patch.msgid.link/20260608095523.2606-37-david.laight.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 6b3713066ac65..e7e7d3aa502c3 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -125,11 +125,11 @@ static int usb_string_copy(const char *s, char **s_copy)
 	if (copy) {
 		str = copy;
 	} else {
-		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
+		str = kzalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
 		if (!str)
 			return -ENOMEM;
 	}
-	strcpy(str, s);
+	memcpy(str, s, ret + 1);
 	if (str[ret - 1] == '\n')
 		str[ret - 1] = '\0';
 	*s_copy = str;
-- 
2.53.0



