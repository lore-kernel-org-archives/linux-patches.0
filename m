Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A41E51C356;
	Wed, 23 Sep 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175367; cv=none; b=f4gfQ2dT5zA1fT1yrrviLshtnsW5EJtwpKRyzTxipx4Eu1Jt6qCLDeBjaWjmQMGSzxo7OZgAs31UtFV2P8W5GD48RLe8uYGLRN8g/GMEvuZZGBoQSP43E1DoabFbCEuAFLxuDCmjXj7o8GeCZVLyIJN4zpdIpbY8waaTI6dK7qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175367; c=relaxed/simple;
	bh=hX1C3W0Iz/KgFKN52MhgBI0lwav6BtRpJor8YLSRckI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu9OsNnePV/9aB8+k49O/5XW+oNOB2jWBhCbSd3AgYASlSwmbra+FPucaCGApEj+z4c2nKllxeCSLG4XwGXMdXojCrzpWnPvlOHMloIEheydGw8Eu+RFJn76/52b8No/8udkB/IRT2E5O+FOROq+DaHxaIClxPfQHhqEpfZSclY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgaGy5NP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgaGy5NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623691F000FF;
	Wed, 23 Sep 2026 14:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175364;
	bh=42LCXrnTJ4yN42TwltehikNNuzdsR3IYuLrz9W8OuGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgaGy5NPvVbj7UMcAorssgeWcF7HGq2ap5WSpZ7JNvLpB5D9P37kT2f3TujIj8IQc
	 SFGMyyw/h/lzEdRkiYJLFgk5S4zAUP6BK8sqkDB+JqOzmbq/QvfAVwXW5w6YQw3v+u
	 tH9/C89LVjLtknN5DQ43rsYzx/yivCvhNIFRuJHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mobin Aydinfar <mobin@mobintestserver.ir>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 393/398] ksmbd: fix partial normalized name responses
Date: Wed, 23 Sep 2026 16:07:47 +0200
Message-ID: <20260923140653.659790325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

commit f4fafaf02174c32bce2f9bb4196fadf13f1fd96e upstream.

Windows may request FILE_NORMALIZED_NAME_INFORMATION with an output
buffer that only fits the fixed portion of the variable-length response.
Treat the fixed portion as FILE_NORMALIZED_NAME_INFORMATION_SIZE so ksmbd
returns STATUS_BUFFER_OVERFLOW instead of STATUS_INFO_LENGTH_MISMATCH.

This avoids rejecting valid partial normalized-name responses.

Fixes: 6b8b79226bc3 ("ksmbd: fix partial file information responses")
Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 +++
 fs/smb/server/smb2pdu.h |    1 +
 2 files changed, 4 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5542,6 +5542,9 @@ static int smb2_get_info_file(struct ksm
 		case FILE_ALTERNATE_NAME_INFORMATION:
 			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
 			break;
+		case FILE_NORMALIZED_NAME_INFORMATION:
+			fixed_len = FILE_NORMALIZED_NAME_INFORMATION_SIZE;
+			break;
 		case FILE_STREAM_INFORMATION:
 			fixed_len = FILE_STREAM_INFORMATION_SIZE;
 			break;
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -213,6 +213,7 @@ struct file_sparse {
 #define FILE_ALLOCATION_INFORMATION_SIZE      19
 #define FILE_END_OF_FILE_INFORMATION_SIZE     20
 #define FILE_ALTERNATE_NAME_INFORMATION_SIZE  8
+#define FILE_NORMALIZED_NAME_INFORMATION_SIZE 8
 #define FILE_STREAM_INFORMATION_SIZE          32
 #define FILE_PIPE_INFORMATION_SIZE            23
 #define FILE_PIPE_LOCAL_INFORMATION_SIZE      24


