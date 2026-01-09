Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2B6359F98;
	Fri,  9 Jan 2026 12:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960343; cv=none; b=uoOdOYN0j9PI5CGXT1vOhelX1ZRcgqWP1CjsZ79JRA00HRCKCczm3pS3zfKa9EF0n3xorWRMzxK2D4omd7plY26qjyHYhxAuhFC1/v7y6r0B2VWIEQBzLeofKe/DK5lUHgSANo5m6OlLE6X4elZ5Sko5Qi9amCWD+Xjwm+Cx6d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960343; c=relaxed/simple;
	bh=aObbv1EmwtKXclyM9FiGivIO81dRYqL8/+4K/x7B/2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjupwbveRyewcA2WEy5jUEvKBX9ZpTe/5Tf6m/SKXsL4ZL4k9LVoOLhseFtRw+KlRQ7qYFBczvaaWzzxiZ7+8Zm678/LDdnFjwEsMlLntHPg+SkEqmb/qVFNnTOqbGnW1TibPlqxKkKD7gU8QA6f+Y6f1JoqBoOD0Kmj/oPcsFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaImPy1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaImPy1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE239C4CEF1;
	Fri,  9 Jan 2026 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960343;
	bh=aObbv1EmwtKXclyM9FiGivIO81dRYqL8/+4K/x7B/2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaImPy1hSYy0puSzx+8+jvCYKUT36mcuqq4ucOFbNRI2FW15Vr7yW9GZpS7KR2GAR
	 /ZdWXTBPfuneE2b3XZqB/ytmPVVOA8bwFkxDd12j3g3Dp0ShIbE2E5mVbdMxQWBWqR
	 u1FUW0xh/allwRh6RhqJrd5MzH1Irwzkbef0o+n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger <roger.andersen@protonmail.com>,
	Stanislas Polu <spolu@dust.tt>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 371/737] ksmbd: fix buffer validation by including null terminator size in EA length
Date: Fri,  9 Jan 2026 12:38:30 +0100
Message-ID: <20260109112147.950563035@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2356,7 +2356,7 @@ static int smb2_set_ea(struct smb2_ea_in
 	int rc = 0;
 	unsigned int next = 0;
 
-	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 			le16_to_cpu(eabuf->EaValueLength))
 		return -EINVAL;
 
@@ -2433,7 +2433,7 @@ next:
 			break;
 		}
 
-		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength + 1 +
 				le16_to_cpu(eabuf->EaValueLength)) {
 			rc = -EINVAL;
 			break;


