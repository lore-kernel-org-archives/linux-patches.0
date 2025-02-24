Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8AE165F16;
	Mon, 24 Feb 2025 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408730; cv=none; b=QtVERB5zIYGXBomFr28H2K7R4lK2Gk0SvvUN4rrxrBhxImm3sl+40l23o4FKW9l6QVZnIpHy7MQRUGctWPXNttbZGM8d2mM+TT4Myly2TFN7tIN8IIb4uv53mTqVqiPeViHap2Tm3Et9lt8Cr2oCEXl731NAQJvlvWFfJejdgHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408730; c=relaxed/simple;
	bh=l95zcIyWONg7qmYJyOmg05IdmFOojn3+Hrk1avmYINA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMdsyYdjBpOMzeMmSfO9z5Boq3nqz3EEziVQsDgGjbeEOYq0V2+Op4m6f4ZqchGaFwXSNgPj9iFrXHtDuuKSDhjI+UuCaVFmkssfeAXrgD01sRaWdUhzqVyJhdbtjpLy22of8JY+KbpWVqFeIKJJnePMRLuU6VScv+eoo40gBNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkOIhRZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkOIhRZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27474C4CED6;
	Mon, 24 Feb 2025 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408730;
	bh=l95zcIyWONg7qmYJyOmg05IdmFOojn3+Hrk1avmYINA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkOIhRZy5ZghMsYLm3iFSDnjV271zF38sfdF6vliW/LL0le19doav7k4WsLVFYz2h
	 WsuZ2uXxvOB3ZqDf1Z6hd3AG03g6gwNhRR5nXVE7ZfVKrS47AKo8Bn3j+ZdTy6dMdh
	 Mt52CGKQvysaWNMKN+tcTqgduzV3ZKwzMUyOxA2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 143/154] smb: client: Add check for next_buffer in receive_encrypted_standard()
Date: Mon, 24 Feb 2025 15:35:42 +0100
Message-ID: <20250224142612.649246054@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 860ca5e50f73c2a1cef7eefc9d39d04e275417f7 upstream.

Add check for the return value of cifs_buf_get() and cifs_small_buf_get()
in receive_encrypted_standard() to prevent null pointer dereference.

Fixes: eec04ea11969 ("smb: client: fix OOB in receive_encrypted_standard()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4991,6 +4991,10 @@ one_more:
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
+		if (!next_buffer) {
+			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
+			return -1;
+		}
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 


