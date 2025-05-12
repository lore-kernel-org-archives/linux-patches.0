Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621AE2550D5;
	Mon, 12 May 2025 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073260; cv=none; b=qlaWM5TFFQbV/SaMP2pyPciSdmhjsZUxotmnLjaIETMzGfjk9EDE7SlvJCeMJNaKWmUtcl8J0ZVhG/zE8bd8sWWt+iD5bC7EyidpTe6vqgVR6zyuABrBKmcl8DG9BOMJxXLS0KBVel5eSZ+54DTQREuxi2RTAlGR/xnuJYKnV6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073260; c=relaxed/simple;
	bh=aiIzvhiEjzfcJ/BQAL5ddlWHMfTPll3nUhdybl7yNps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ8tzK+7ZKyNkwb/jFNbPCvZcNveybIXuuU1KAxJWg4YW8q5y4y2iXQ6c0N1JoPIW/nO5yBgunO19/NYroNpN0v7ZVMQc5g3IS3Ldl0oJeUHcCBfh8TRCDgQCuZdioLlQ6oejzXpxb60cjZ9MZP1nlbdbqAUe6imdN1zV18ONgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSo4vlKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSo4vlKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615EBC4CEE7;
	Mon, 12 May 2025 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073259;
	bh=aiIzvhiEjzfcJ/BQAL5ddlWHMfTPll3nUhdybl7yNps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSo4vlKdnK7/eiapoqkyu7NJub3nzXJv5llq9OR/T1CQbyZlPMFQUxPiiLaZer+r7
	 m1DhCURIAw3HZK1iQh8GQ3h5MQ3W+DeLJ0StZ1O1xwMSvBDYDJxf/K4Od7UvbM7Dv1
	 ysf36cLOsIGXv+KiGDPA3qnfqmycg3nZ+BBSBniI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 007/113] ksmbd: prevent out-of-bounds stream writes by validating *pos
Date: Mon, 12 May 2025 19:44:56 +0200
Message-ID: <20250512172028.000209936@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit 0ca6df4f40cf4c32487944aaf48319cb6c25accc upstream.

ksmbd_vfs_stream_write() did not validate whether the write offset
(*pos) was within the bounds of the existing stream data length (v_len).
If *pos was greater than or equal to v_len, this could lead to an
out-of-bounds memory write.

This patch adds a check to ensure *pos is less than v_len before
proceeding. If the condition fails, -EINVAL is returned.

Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -443,6 +443,13 @@ static int ksmbd_vfs_stream_write(struct
 		goto out;
 	}
 
+	if (v_len <= *pos) {
+		pr_err("stream write position %lld is out of bounds (stream length: %zd)\n",
+				*pos, v_len);
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (v_len < size) {
 		wbuf = kvzalloc(size, GFP_KERNEL);
 		if (!wbuf) {


