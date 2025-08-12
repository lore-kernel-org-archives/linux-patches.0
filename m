Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B062D0C9F;
	Tue, 12 Aug 2025 19:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026820; cv=none; b=P//lcbU15awwCKMQBdm8rjVwHxRNzp/AlmAekrNjmE+TovZgO16OydWUwZRbQsS1gVNH7pRCYqHqkr2H9mw9ykPrbmMhJdWnSm9SABrhLAh4umpC1RW+qBqJ1f4n9nvpJO14uIdgayaRFgtybSvzDDj7VZCXi//fc7Y6pNRY9l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026820; c=relaxed/simple;
	bh=pNHfJKmkc1FFfPSQfxjdJwMXgvGEUGSMLFcmJIW9K9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ct846nzs+vlfoknAdpgBzDVxyZU1cSVmwvWyThCHumCJgMKq9qyJ799HGS0CmtfG1usMTxHIp+wJ7BwfEO5RwU6i3/Lu00Qt/6ygH2TJ/BAxCBHT5cc2yTsMDxRFmBWgY2JKhyI0Vfz1bELkgUWh50NPw+v96NeBCNjqce+VHiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTu5bgfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTu5bgfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06474C4CEF0;
	Tue, 12 Aug 2025 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026820;
	bh=pNHfJKmkc1FFfPSQfxjdJwMXgvGEUGSMLFcmJIW9K9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTu5bgfNS30BwecEX2EJ19xiTe7Pw4Q8ibz0bHlzkudD/s9XYyxy0ak8C1bT+ibII
	 x/pXHxZX3KyWngi5bam1LWPLgRLcp+dGln6XsQWSmmyjBk50f4+bt7lOommQpLv1Bx
	 9nb/mTReWtGET1USQ4t7RL1qWwG93f6OBnBbr5+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 451/480] smb: server: Fix extension string in ksmbd_extract_shortname()
Date: Tue, 12 Aug 2025 19:50:59 +0200
Message-ID: <20250812174416.002720054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 8e7d178d06e8937454b6d2f2811fa6a15656a214 upstream.

In ksmbd_extract_shortname(), strscpy() is incorrectly called with the
length of the source string (excluding the NUL terminator) rather than
the size of the destination buffer. This results in "__" being copied
to 'extension' rather than "___" (two underscores instead of three).

Use the destination buffer size instead to ensure that the string "___"
(three underscores) is copied correctly.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -515,7 +515,7 @@ int ksmbd_extract_shortname(struct ksmbd
 
 	p = strrchr(longname, '.');
 	if (p == longname) { /*name starts with a dot*/
-		strscpy(extension, "___", strlen("___"));
+		strscpy(extension, "___", sizeof(extension));
 	} else {
 		if (p) {
 			p++;


