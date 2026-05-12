Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB7A23E356;
	Tue, 12 May 2026 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609479; cv=none; b=dWFH54MQR3U+c0Gj3H5FFrvurwnkpph6tBeAsJCTg1512D4UVopMGlFLgZAgowG8V3jaSFzK72jrgu4Vb05Zdx4jB5GR7RBG4X6wmeiud0z8CMjuRIKj/eOdpEyf7JBEKUgW8H8Hw4eFP8hFdFemCylgJMTlbK9IqP7spp8W7iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609479; c=relaxed/simple;
	bh=rxaOUy0nQOQHxeZZrZkzwHwEQayRFcKNgGykdD4Af88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMnGf8gwBpLpnF1RfuZXokbOU5+JX7LoPzofDkIv2EcCUKeLL/XTHMRZuee86KLMhXJLY3xcFL7xgwsdW3UKiAqM3JEoOzkjIljy+pL3cKSdQDtOVh1UamVlzt9hn3r6V7HZD7oVIPF3wxTL//whyR9b7y1nI/Kr/HKeexcmYBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IncOeKE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IncOeKE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE604C2BCB0;
	Tue, 12 May 2026 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609479;
	bh=rxaOUy0nQOQHxeZZrZkzwHwEQayRFcKNgGykdD4Af88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IncOeKE3xJkr7v+eTRpUrDSfqO06Kzp0/vL9XyWXNLirC6IuNUnqEOqZpXbkQjNMY
	 JbWisWv8Yz3ilcSg6EoCyANBoAnZXoXOmTOWitdyLbmuWGnjVajYvmYcUoYvwBucGh
	 rNTPSH8lZZoQV3se8ZRDqeD9ywu2afXUXVRjYCbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Zisen Ye <zisenye@stu.xidian.edu.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 212/307] smb/client: fix out-of-bounds read in symlink_data()
Date: Tue, 12 May 2026 19:40:07 +0200
Message-ID: <20260512173944.589418141@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zisen Ye <zisenye@stu.xidian.edu.cn>

commit d62b8d236fab503c6fec1d3e9a38bea71feaca20 upstream.

Since smb2_check_message() returns success without length validation for
the symlink error response, in symlink_data() it is possible for
iov->iov_len to be smaller than sizeof(struct smb2_err_rsp). If the buffer
only contains the base SMB2 header (64 bytes), accessing
err->ErrorContextCount (at offset 66) or err->ByteCount later in
symlink_data() will cause an out-of-bounds read.

Link: https://lore.kernel.org/linux-cifs/297d8d9b-adf7-42fd-a1c2-5b1f230032bc@chenxiaosong.com/
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: Stable@vger.kernel.org
Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -241,7 +241,8 @@ smb2_check_message(char *buf, unsigned i
 	if (len != calc_len) {
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
-		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
+		    shdr->Status == STATUS_STOPPED_ON_SYMLINK &&
+		    len > calc_len)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
 		if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)


