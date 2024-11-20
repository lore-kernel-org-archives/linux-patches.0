Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208271BE226;
	Wed, 20 Nov 2024 13:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107694; cv=none; b=jnmWrqnaiV0zglD30VLokvEMArgeh56c9lmRqfHfxD8YUuxts+HhvsbacIzBbkK2W5AxYbHimItXo0TCFc/vjDn5cD+OHeDKg1lInqPpXNYzUP8LfmmqTEK8/sAywP2ekyzK6mGQFRvU2ICKHRD/cGasO6vlx5l+NqYpBCxQ1N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107694; c=relaxed/simple;
	bh=lBlkr4ZrcugV8RoYAKAUUnIK9k/7FHKGUrtw65n6OCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T48mwMjoNzPoOpN0nP1SiQTuHz7dTXe3Uj2MROkUAx+pNbn54lJIDFTa6SxhK1t8XLBEvKs8q7U7u7zTw+zlgTDJvdtmfU3KMDekjuO0ra8zrj+jePSwbVOec0atmIDViKw+86E+9yDFEUeIcFIAuAb+VjgCcSblppLsdAAHvHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApHl8PIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApHl8PIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E350FC4CECD;
	Wed, 20 Nov 2024 13:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107694;
	bh=lBlkr4ZrcugV8RoYAKAUUnIK9k/7FHKGUrtw65n6OCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApHl8PIfwUqvZo0g9y7PMkKQjKLHIvLirn5cn918VMK/M8uwdVuDUdJHBeWBtbvxQ
	 MXG6qh7VwEGQGXUj+sVooooTZ3b7RNTSXA3BPb+s3p/blMlHsChQs5aT5WgcN+Wo5G
	 k1UByQk5vjNBPmCFhK11v3qBaWdtuBWuWB72YVN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanzhe Yu <yuxuanzhe@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Subject: [PATCH 6.1 53/73] ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
Date: Wed, 20 Nov 2024 13:58:39 +0100
Message-ID: <20241120125810.887264152@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit a80a486d72e20bd12c335bcd38b6e6f19356b0aa upstream.

If ->NameOffset of smb2_create_req is smaller than Buffer offset of
smb2_create_req, slab-out-of-bounds read can happen from smb2_open.
This patch set the minimum value of the name offset to the buffer offset
to validate name length of smb2_create_req().

Cc: stable@vger.kernel.org
Reported-by: Xuanzhe Yu <yuxuanzhe@outlook.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c6cd2e8d2d9a ("ksmbd: fix potencial out-of-bounds when buffer offset is invalid")
Signed-off-by: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2misc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -107,7 +107,10 @@ static int smb2_get_data_area_len(unsign
 	case SMB2_CREATE:
 	{
 		unsigned short int name_off =
-			le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset);
+			max_t(unsigned short int,
+			      le16_to_cpu(((struct smb2_create_req *)hdr)->NameOffset),
+			      offsetof(struct smb2_create_req, Buffer));
+
 		unsigned short int name_len =
 			le16_to_cpu(((struct smb2_create_req *)hdr)->NameLength);
 


