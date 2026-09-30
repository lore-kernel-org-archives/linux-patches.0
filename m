Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5DB3E9C1A;
	Wed, 30 Sep 2026 19:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796694; cv=none; b=IO22d1FqWnADW5/wRdRcZ88RGEBIWOJDot93IB52XLDSwRYC9lqFibTHXIxRoO91shRm8XFHrS6P4Bi3CTAcz+JRXZJsXlGTvwFjp085eO+KWbKVTyqU/j4wZ8mEANBbraFFk2Vi+jw1ao9Rb9i/qEjG+9TfBA8ob1UAALpscLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796694; c=relaxed/simple;
	bh=9G7voCu0NWf7WVMvDAhWg1XemL2aoa4vX/4VKxQ/aAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XI94h3jUNObm1lq8PPrcnOTmtcIQgvQ1ERZWGjKzFEJ+2+KmCLnp4Sl6NMeRtFgq47NYta11fRehe1OJ8HYYraNKQQiZC5usLBFCwxvOoxh2UMQWhjy3wK0Zh9Rd4g8ZzQriqKb6UXB3KWOHb74gSl9bhhpA6T7k1g3mqakc7k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WEyuJIx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WEyuJIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A6A1F00898;
	Wed, 30 Sep 2026 19:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796692;
	bh=A+CfAY+FY9kfY8SKeerJGnq0DD54VltpXuoQM2H8Af4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WEyuJIxJbm7dxviXvbKSReQH3MRhoz9/7qBGmhgtvotAoCEQMX1txZkP0igj9Io8
	 pRxIJBpEhAsFwiHa9fgjkWdgGSHPOY9oYPiXmjgU5wBqzltPbAfCRUlaVioFtGIxWf
	 CFoLP1rJN9jXi46/rjlLHYnefMYm2YgzQgb+RkxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mobin Aydinfar <mobin@mobintestserver.ir>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0948/1193] ksmbd: fix partial normalized name responses
Date: Wed, 30 Sep 2026 17:27:12 +0200
Message-ID: <20260930152455.303034450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -5508,6 +5508,9 @@ static int smb2_get_info_file(struct ksm
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
@@ -239,6 +239,7 @@ struct file_sparse {
 #define FILE_ALLOCATION_INFORMATION_SIZE      19
 #define FILE_END_OF_FILE_INFORMATION_SIZE     20
 #define FILE_ALTERNATE_NAME_INFORMATION_SIZE  8
+#define FILE_NORMALIZED_NAME_INFORMATION_SIZE 8
 #define FILE_STREAM_INFORMATION_SIZE          32
 #define FILE_PIPE_INFORMATION_SIZE            23
 #define FILE_PIPE_LOCAL_INFORMATION_SIZE      24


