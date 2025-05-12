Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D683C254863;
	Mon, 12 May 2025 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072387; cv=none; b=qggEPgtip735dmMG+QXZIhSVXCxQlXxPPb57uxs/ui87ZWyTrtTL3dTtPhdk0Oxa6Knb7lRgBUmmdr+9jrzIfx68g/xTS4f0tuz8GNgNp5TEtu4zHMk/liURoNAfjQil9VpvD8q3w/LjDMduGDYk+cOSPCMojt8jWPHbhhEAsHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072387; c=relaxed/simple;
	bh=iMeall7EvzS5VXHSsjtNwJjU7DDc2HDU0TcvWsf3mrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFkhdUAOSEzIUuGWw1MXjzskX7MUwYl6EixSGNwKF4x7pZ1yCQzZgvxbWeB2/gTJ0nrZT811nrAuku4JPPBFOnMTtmfd59FvwpiiEOBmXrYK7DCAYFg4l+IuJcQDrOM7cz/+3fm1P2jnx42CF8DuGRzOhYm7w3OVTHKd9R/mzSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=somsm4hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="somsm4hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDB9C4CEE7;
	Mon, 12 May 2025 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072387;
	bh=iMeall7EvzS5VXHSsjtNwJjU7DDc2HDU0TcvWsf3mrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=somsm4hIQ13Dybb8IB/Wxa7WgxBg9Rw5B+gW6jmDr1AfAhkUh8AB6J0TQKFcBFpFT
	 LpV7mJaeRnwZBrQwMJ5UJo5X4x9LrK2CxqhM0zOR8tpN5+A/raXV5oBSA1HSdeWP/F
	 5nDyxfObW1zEuU0OgP7QJRNrPuO1ui4rmDfYPN7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 05/92] ksmbd: prevent out-of-bounds stream writes by validating *pos
Date: Mon, 12 May 2025 19:44:40 +0200
Message-ID: <20250512172023.353663931@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -440,6 +440,13 @@ static int ksmbd_vfs_stream_write(struct
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


