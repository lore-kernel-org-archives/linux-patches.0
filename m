Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570FD29B795;
	Sat, 17 Oct 2026 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254807; cv=none; b=AByXzuNDAu0tMIyUvtR7hA40qQ5tY6uLugzWAQ+BX+jZl/zyDC3sFAj9mKDzQn/MatQxpJF3y0wGijj0GYme4r7sSQhNKW4OfzLKLYGxxmjOGyjfECcYKOtdrjQG/mp4mgW2hVIYqTN7fjpgtXLPvaq+CyijkYx5icrz3udND9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254807; c=relaxed/simple;
	bh=7aO012BBF5ar01Lad+TgzdDQNKMUfWhXNeBIk/0q/ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DECPH0Rsx9sixDIYUkho2fvMTk+8AQUr2qRrgeKqRdw95W6fOo7BPKnIawa2Jk8YTb0EBKwWWqQlTXdxQihTXxQUyiyI4iDBp4gKppwuQzCyyM+qatMcYM+8B8A/cN3sIeRZdvOlApCJT+jQHPwuDIrnepRSwcKzQujbH9AIIS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rs+iyI/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rs+iyI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF901F000C4;
	Sat, 17 Oct 2026 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254806;
	bh=FUjhZvyodNRUAjkBjUgdPX4rrpTZHaW4WrkJV6AZeUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rs+iyI/Jy1xqWr5rPEwqMZUysRMKZ5Zgtn1nX3uqKw3TuvfdR26ITk8tCHsytaI3
	 tAdnh4V5oi4JsLlH96kISO+sJpCbfhuR1fzx72DTwSXIZSkVwAl8ldCn/Y0oXH8oh2
	 +vWFlaZMriNo4tB68Io9e0cxlG0NOhauLeuwZijA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 569/869] smb: client: reject a tree connect response whose byte count is too small
Date: Sat, 17 Oct 2026 17:56:50 +0200
Message-ID: <20261017160051.657587692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 65deb18359341141d37dc86fc7853511be3c87a7 ]

CIFSTCon() bounds its strnlen() over the byte area with the server's
ByteCount minus two, which for ByteCount 0 or 1 goes negative as an int
and converts to a huge size_t.  The later subtraction wraps the __u16
bytes_left, and that is what bounds cifs_strndup_from_utf16(): a bound of
up to 65535 against a ~16 KB cifs_req_poolp object runs off the end of the
slab object, and the bytes reach userspace through tcon->nativeFileSystem
in /proc/fs/cifs/DebugData.

Reject a byte area too small for what the parser consumes.  Two bytes is
the least it can consume, and no conformant response carries fewer.  The
new trace point is the 129th smb_eio_trace entry, which __mode(byte)
cannot represent, so the attribute goes with it.

Fixes: cc20c031bb06 ("cifs: convert CIFSTCon to use new unicode helper functions")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a7261fb38379f..7db347fc8faa2 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3895,6 +3895,10 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		tcon->tid = smb_buffer_response->Tid;
 		bcc_ptr = pByteArea(smb_buffer_response);
 		bytes_left = get_bcc(smb_buffer_response);
+		if (bytes_left < 2) {
+			rc = -EIO;
+			goto out;
+		}
 		length = strnlen(bcc_ptr, bytes_left - 2);
 		if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
 			is_unicode = true;
@@ -3950,6 +3954,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
 		}
 	}
+out:
 	cifs_buf_release(smb_buffer);
 	return rc;
 }
-- 
2.53.0



