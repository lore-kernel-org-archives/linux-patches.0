Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2C33839B2;
	Sat, 17 Oct 2026 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259720; cv=none; b=hkcvAvNth6tIt/yixVAGK//TyNv+fIA+4LHEdFxvpl1tskPqueHxc3tHzzvEV6n/cQXc9BNWqXfjCudV2BGL5EDcuqehxeBWG3X8WW+sCoJlz/HWM4Fub9RVYBMH1tyZb2dMA2YfjCQYRDY/U4IeZtc1aOtvJbgq0vk3ljMiNaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259720; c=relaxed/simple;
	bh=Qati6z8kdqW6JS6Gjn99ARjGzlK000H5OTDrAS3kt94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqPUqoRfyw3MOT8Fq0G0tiEWs2AIyo6PNBOx8eftNVtNw/rQnx0b/HEuv+y3gL1P1Cbg5tiCyCUxc94nKn5BKjgBTnXzU3SL+KlX2T4gmSGzPbErOQu4seu4vLM8+WF/m9J+Rim9ZMMYmkYOY4ngd4VZhKghvEtsKLpV95qxVhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0ACA1fy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0ACA1fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7DF1F000C4;
	Sat, 17 Oct 2026 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259718;
	bh=o+KAj0WTtkQpg0qPl+biSFLLHipFocQSyHF/DsvGtrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0ACA1fy1SiM+KZVpt6LqUvP6tPSH1FT9DlzIMNJIAhPc1YmNrp3FWfOkXt0LSDvY
	 jU04k7A2hxDc841LMr3j/Sn2K/AqnJvI0Dv773iDELXpJgycGYp+aG7QXH9zSGHVad
	 Bnq6x+uYVINYyzEk1GLEMlOyq0ur1ev4sVvwOj8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1306/1674] smb: client: reject a tree connect response whose byte count is too small
Date: Sat, 17 Oct 2026 17:59:38 +0200
Message-ID: <20261017160504.668503260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 9da32fb95c9cc..cbe8cb863c1cc 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3891,6 +3891,10 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
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
@@ -3946,6 +3950,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
 		}
 	}
+out:
 	cifs_buf_release(smb_buffer);
 	return rc;
 }
-- 
2.53.0



