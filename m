Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DD933121F;
	Mon, 29 Dec 2025 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025242; cv=none; b=fbUg0a4DwVQTEr+qzvr68YPNdEmPX8/h1oiSb3YVodEQ+Mtz6jGlQ6DR/1Iw50Dj9OswwmXNGk8fReKxEGjqyEoCoZFq+1y1kV3oLlm+Fh4cVKyoIXe8prBFR2/+jSN7sGkk7lTzPSJ6XX+cN5Tb79wFd4EZFiTFjqD7MDtBdDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025242; c=relaxed/simple;
	bh=3AzF/Xz9+sZXGE0Xd5v4uRegDUFPB/NE7ClkNWF7aOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb1QBTLQun9PIE/bxPE0LLHZAj83pIv8UheHXWxjiestQKRygWY8uh2+6zcTHPhvjAkYc1Y5d9mujaCOIBlj+oGJXnYKvLDonGwVJrgixkhtAREd5/FZMaAvci7grCcXDIvAB6iJWzd0Oce+KA9BmbR0vswKeikiT4ySGDWZhEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSP+owQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSP+owQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E95EC4CEF7;
	Mon, 29 Dec 2025 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025242;
	bh=3AzF/Xz9+sZXGE0Xd5v4uRegDUFPB/NE7ClkNWF7aOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSP+owQIMjB6aqaMPMxY2QHVbv9dT5Uoe4WEhkRgfcCu+N90appCyyDlhfZ3DZpZX
	 PZabThR5YO6cdX/Pmuvj9F4VGFV3UYZLdxD2aRb0G1sdHbYeDIZriaTU3DGBgQqlwH
	 knhmhlhi9cEK+hqCjelmcwgTeKHYWE9u9SwyUWAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 145/430] ksmbd: fix buffer validation by including null terminator size in EA length
Date: Mon, 29 Dec 2025 17:09:07 +0100
Message-ID: <20251229160729.698706254@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2373,7 +2373,7 @@ static int smb2_set_ea(struct smb2_ea_in
 	int rc = 0;
 	unsigned int next = 0;
 
-	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 			le16_to_cpu(eabuf->EaValueLength))
 		return -EINVAL;
 
@@ -2450,7 +2450,7 @@ next:
 			break;
 		}
 
-		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 				le16_to_cpu(eabuf->EaValueLength)) {
 			rc = -EINVAL;
 			break;


