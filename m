Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2141B34B42B;
	Tue,  6 Jan 2026 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719972; cv=none; b=BMXOP4m6I2foVwMxWO1bx3sOLHNlx4PbJ2AVrkhd1XU8OBVaobZ2T69fGgd6ST7zTKhIlQv7Y/g4Wu4eudmXbcTnyjeIP/2Tkx63KweldbjvYzNpPAGxy0iqIg5r9IAiziGjclyBf96MCovVLwHoCYgAQ5CkNnuN0mrHZXuekpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719972; c=relaxed/simple;
	bh=ZCCauEw/pTNkXHTUq3EWmPxqCcONytpR3yAhCX7fsV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqkrM0+iHK+OLG8DPjW50k2nzY42OH/fg8anyHRCvjezRQlNsooidPtlKYWv+UNj5MbKksAIPjINgLJJ6HlJIlJeYEwvOrsztTFqorLm9/Q0Sjj+wDi5YvABia1XMmuUX8oBwnzuRqWPoA9Cq3yOz2eEjH8+ipOQSonDNSVTqJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhzUeBh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhzUeBh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AE8C16AAE;
	Tue,  6 Jan 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719971;
	bh=ZCCauEw/pTNkXHTUq3EWmPxqCcONytpR3yAhCX7fsV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhzUeBh7sXhrvSfYJq/wU4jKQoJzP1Oo5k4CYylwzTvK4iSs9MHS/tgd+VLlu4jNA
	 BgCioN6I+3KyEe/D6lNlJg6dDl9Xs4fYO9SontEMvvXamjstHaV2Z2HAKfoHYakHkA
	 qjJmHB0yLCGwaF53LG60wjddK79/YiUPS7DtyB2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 095/567] ksmbd: fix buffer validation by including null terminator size in EA length
Date: Tue,  6 Jan 2026 17:57:57 +0100
Message-ID: <20260106170454.842021587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 95d7a890e4b03e198836d49d699408fd1867cb55 upstream.

The smb2_set_ea function, which handles Extended Attributes (EA),
was performing buffer validation checks that incorrectly omitted the size
of the null terminating character (+1 byte) for EA Name.
This patch fixes the issue by explicitly adding '+ 1' to EaNameLength where
the null terminator is expected to be present in the buffer, ensuring
the validation accurately reflects the total required buffer size.

Cc: stable@vger.kernel.org
Reported-by: Roger <roger.andersen@protonmail.com>
Reported-by: Stanislas Polu <spolu@dust.tt>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2363,7 +2363,7 @@ static int smb2_set_ea(struct smb2_ea_in
 	int rc = 0;
 	unsigned int next = 0;
 
-	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 			le16_to_cpu(eabuf->EaValueLength))
 		return -EINVAL;
 
@@ -2440,7 +2440,7 @@ next:
 			break;
 		}
 
-		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 				le16_to_cpu(eabuf->EaValueLength)) {
 			rc = -EINVAL;
 			break;


