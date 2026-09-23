Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4494C535FC3;
	Wed, 23 Sep 2026 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174134; cv=none; b=IOV3mZBQa+7gcnUyuD5m8fcob3WdFTIrteiThKdcP1a079fWrymXT15cP5hhFLxpjao5nQmxAF5YYQAUVmIWmoLMGoNJIDNmqVbjqoSNf4GN3hHFjZBfzmsh78wZoAYLeQW6J8aPxMRC62ucLLX767j4jzMsWN0NIlpF+vhxG3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174134; c=relaxed/simple;
	bh=9ja9QIbN3Gq+tZdm5i9UzqPqm0Qjo7O0Y2zoTiYirQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZ9nQLaAEUkr/eBpdxxyANGh54AMfpEURzN+mGlyLxq7ayU3OZZuaU6XLPH1Vv62tEOK+OQCvv2bQQ2SiK6dI5kBhyRTc02o6bZgVSxdlOXD8BGlIr2KVl4i98wjKfXu4Wy0npsxoreemJe+Wfdkbf4hzdcSEr+16goko/wvVho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4DrR5LR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4DrR5LR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991801F000FF;
	Wed, 23 Sep 2026 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174133;
	bh=Igi6jLzz+WTjeAD13l8VzcB+kb+JwmpH3vK8hKZKmCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4DrR5LRM8EShyhq2cOMAjKlWpdFMzoc+SAiCACjVeL5MSLt/B6zxKf+5tF3z/jGw
	 1DFWNaXgcVEtV8ySTiw8XxcepL2VSD9WjvizuTeU+EUBTELUJrAN1tcY3qifyl4a0P
	 4tXMq2phu0wCLn2eqS3eVxK56HJ1F6DDycDiftJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mobin Aydinfar <mobin@mobintestserver.ir>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 438/438] ksmbd: fix partial normalized name responses
Date: Wed, 23 Sep 2026 16:07:39 +0200
Message-ID: <20260923140656.297950123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6531,6 +6531,9 @@ static int smb2_get_info_file(struct ksm
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
@@ -197,6 +197,7 @@ struct file_sparse {
 #define FILE_ALLOCATION_INFORMATION_SIZE      19
 #define FILE_END_OF_FILE_INFORMATION_SIZE     20
 #define FILE_ALTERNATE_NAME_INFORMATION_SIZE  8
+#define FILE_NORMALIZED_NAME_INFORMATION_SIZE 8
 #define FILE_STREAM_INFORMATION_SIZE          32
 #define FILE_PIPE_INFORMATION_SIZE            23
 #define FILE_PIPE_LOCAL_INFORMATION_SIZE      24


