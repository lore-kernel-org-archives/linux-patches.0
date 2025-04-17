Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B4B2571A1;
	Thu, 17 Apr 2025 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915870; cv=none; b=NBeR8gWM0L1z15c/4DaSI3Bqw9YdTIIRhRTHaxYYt90ct69FLyWlofu+1dQHpyXtC5BdZZSVs4CDezoahZnWxVUXf6QisZ0XJEs4Rd4zAdOo8m3zkP9UPmXqgN80aD6kzPpykDU2TzlUcd85O3AHfDerX5Co6toMdv6thiop4Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915870; c=relaxed/simple;
	bh=dHZZ7ZApBU7/C2KG8vfX3YSywyMBXFQMOxmrlSFX++w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EszL2ukcHAEssqE8qGsU5LK8dd3tsx8gFMvWpgjCj08wXUZZN1gJYQ0Na7J43vXjDOEE+LqyzWWYaiF/DMA50d8ulED243jRj7Q+fK9Umt6/+oYYlXu2AjNkvB/xdbKizPr8p7VpYe5PGxAB9np/+wwC2vbE9g72Qowv4RtktTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgRYiFhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgRYiFhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64E2C4CEE4;
	Thu, 17 Apr 2025 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915870;
	bh=dHZZ7ZApBU7/C2KG8vfX3YSywyMBXFQMOxmrlSFX++w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgRYiFhNhjIXL1IcspK0GGn+SSrL/WDbhuDYB3XjLwuEtnd4NVGBQ+3dc5/WP4+Ff
	 6yAPTwUTFnmCBgScUjrWAk0gImwYWpmrmoWzB2TSo2ulXFowm21PH00QApF6AM+fwc
	 2RD4czTqqXoV20k5oBe0ZxilpSUxwSUqJHI2zmcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 267/393] smb311 client: fix missing tcon check when mounting with linux/posix extensions
Date: Thu, 17 Apr 2025 19:51:16 +0200
Message-ID: <20250417175118.345016367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit b365b9d404b7376c60c91cd079218bfef11b7822 upstream.

When mounting the same share twice, once with the "linux" mount parameter
(or equivalently "posix") and then once without (or e.g. with "nolinux"),
we were incorrectly reusing the same tree connection for both mounts.
This meant that the first mount of the share on the client, would
cause subsequent mounts of that same share on the same client to
ignore that mount parm ("linux" vs. "nolinux") and incorrectly reuse
the same tcon.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2474,6 +2474,8 @@ static int match_tcon(struct cifs_tcon *
 		return 0;
 	if (tcon->nodelete != ctx->nodelete)
 		return 0;
+	if (tcon->posix_extensions != ctx->linux_ext)
+		return 0;
 	return 1;
 }
 


