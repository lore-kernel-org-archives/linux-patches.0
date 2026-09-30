Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6436A37E;
	Wed, 30 Sep 2026 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788901; cv=none; b=U6SyZpFeuUFUjldZKLsSqQE+b+xwartTbtaYO0tV0WgyiL5TSQQF1/4OlrC+TYDWptMaUuFypZzOCYIN1T7HV3mtKWfUJMRMyNwaMTCX0j4HYP0EAcvvJxei21CQhcLjjM6xthrra/zQv/bKC2kbYdhzW96kSciDYtfDm2SAPjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788901; c=relaxed/simple;
	bh=8o007ucmcxYP+vMadcGiD1PfXl4G1hyiGEYBtljq5uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjjhNyEct+PV8vNW11AgI8KqyF5SSprGwtjCVAG5XY+ng5LKRiJETM5TYO1X6f8JYmAZG3oTD2QbsZcu3V72YqSoqINe3YPrhPl5jqN59Ni8Ns6+OVfYP4EWqETl7fy4uDT8EkNB8z93dBVSJB1+hAUhVenAtZfjRv/rnOh0FcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6FOE0U9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6FOE0U9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52301F000FF;
	Wed, 30 Sep 2026 17:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788900;
	bh=TgoxmDfxgQN4ovA4B8TcSOJ7RDAgbB49N8y2rm0NdT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6FOE0U9X8+WnjavnKAiZ3XcreJPHc+jbopS0g5ibgUS/2Zad6zIl1jQqWkJEMMy9
	 AEySD/K3gHd0blwqEuS3OX9/Kxbsc8BK8lAnJRDp3XDS71QUKJ4jrWutjyHKOA4kW6
	 QAk0g0SFAN7ciYj3vI+8MsmUf6eWckjM5zjrR8fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mobin Aydinfar <mobin@mobintestserver.ir>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 287/877] ksmbd: fix partial normalized name responses
Date: Wed, 30 Sep 2026 17:19:58 +0200
Message-ID: <20260930152420.904203868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -5530,6 +5530,9 @@ static int smb2_get_info_file(struct ksm
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
@@ -219,6 +219,7 @@ struct file_sparse {
 #define FILE_ALLOCATION_INFORMATION_SIZE      19
 #define FILE_END_OF_FILE_INFORMATION_SIZE     20
 #define FILE_ALTERNATE_NAME_INFORMATION_SIZE  8
+#define FILE_NORMALIZED_NAME_INFORMATION_SIZE 8
 #define FILE_STREAM_INFORMATION_SIZE          32
 #define FILE_PIPE_INFORMATION_SIZE            23
 #define FILE_PIPE_LOCAL_INFORMATION_SIZE      24


