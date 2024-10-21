Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED89E1EABA0;
	Mon, 21 Oct 2024 10:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506840; cv=none; b=EHnW4tqLA3D6jJCLfZuUKtozvl2NLuY/7v4R33CxMBvfzDXjcT3ibaE4B/CmpOz1QEM02EC2nXheui2LS1BuwlcPkiowwGltr9AlOnbN1yCwxzFCHUy/fuBjtcA7rF/qqCxDE+TW5KlPR5XPvGgzITo1n/6mO63YyusfMzWuHCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506840; c=relaxed/simple;
	bh=73F4MErhdlOwgz7XctIpLprxwebW0culmeRUhRDcrOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn5M2nfCAWEvQz3OQBuGCklwpYsVzn0/MZW5T4ApCB8r0nsLRVTChTIELnUSgm/lxziiMJmzeFk/pe5kLIKE5iTXFMtzZ34zT53KzQp/4u1gpt+4d8mF141khYgueQXfWdHx9IhC4Ih48zBgq6q/9uOQnkwGVeQloF3Gs7G0RCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZOgjaGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZOgjaGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B393C4CEC3;
	Mon, 21 Oct 2024 10:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506839;
	bh=73F4MErhdlOwgz7XctIpLprxwebW0culmeRUhRDcrOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZOgjaGCG82BfCwqBbiSFttCVFmiPN+UoTONAgb7jxuzXB6bFmOwRhdXoN52ybSBB
	 TZHkrkzzI5n2xjCBDzmZFXmnuG4gqGlzUjBhMQmnM7yBmnCPp8BC2mUHSNrJQmKQCz
	 Kkm282qoMVRrsqJl0gPujvrb7InTW+PW7p1WQp8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kevin Groeneveld <kgroeneveld@lenbrook.com>
Subject: [PATCH 6.11 107/135] usb: gadget: f_uac2: fix return value for UAC2_ATTRIBUTE_STRING store
Date: Mon, 21 Oct 2024 12:24:23 +0200
Message-ID: <20241021102303.513040403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Groeneveld <kgroeneveld@lenbrook.com>

commit 9499327714de7bc5cf6c792112c1474932d8ad31 upstream.

The configfs store callback should return the number of bytes consumed
not the total number of bytes we actually stored. These could differ if
for example the passed in string had a newline we did not store.

If the returned value does not match the number of bytes written the
writer might assume a failure or keep trying to write the remaining bytes.

For example the following command will hang trying to write the final
newline over and over again (tested on bash 2.05b):

  echo foo > function_name

Fixes: 993a44fa85c1 ("usb: gadget: f_uac2: allow changing interface name via configfs")
Cc: stable <stable@kernel.org>
Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
Link: https://lore.kernel.org/r/20241006232637.4267-1-kgroeneveld@lenbrook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2055,7 +2055,7 @@ static ssize_t f_uac2_opts_##name##_stor
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac2_opts *opts = to_f_uac2_opts(item);		\
-	int ret = 0;							\
+	int ret = len;							\
 									\
 	mutex_lock(&opts->lock);					\
 	if (opts->refcnt) {						\
@@ -2066,8 +2066,8 @@ static ssize_t f_uac2_opts_##name##_stor
 	if (len && page[len - 1] == '\n')				\
 		len--;							\
 									\
-	ret = scnprintf(opts->name, min(sizeof(opts->name), len + 1),	\
-			"%s", page);					\
+	scnprintf(opts->name, min(sizeof(opts->name), len + 1),		\
+		  "%s", page);						\
 									\
 end:									\
 	mutex_unlock(&opts->lock);					\


