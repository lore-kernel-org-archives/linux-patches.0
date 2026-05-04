Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186793DEAF2;
	Mon,  4 May 2026 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903632; cv=none; b=DojCNRp02Z2LSvEhZTYkCly8kjCQ0OUaZZlCF1/Fzvjp3clBgdcJFzln2aUThs+iy9temzo5TTPcQzOmsfw/77o0JWBctN7YV0YFZkavO8HV2UtMnYBboqsmSBOwyfkoa/Dsh8kA1OUWze+bKfshHsW8EAEAMAoloa7PrxACaNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903632; c=relaxed/simple;
	bh=Y/o632ILq4xwgUJuZ3iSv/m6ce8cJl7qjAjHOCUeYOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2j20uVRqvgCZs2ndaTRFuWKwENZAaD7QRBjgFTpwdT9Qp7WcbqGUo4bszZVSzUy0FKv5sOCJK1+ajkej6ESwhDFM8Ia+kI1RkPV9xQVYMErgW98jT+HDi6Dq3D/bsTYMlxxKYkGDEIdeZNAedt94ncTsLuw+I3Z3GZQ2BZUZ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+WN1qSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+WN1qSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D38C2BCB8;
	Mon,  4 May 2026 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903631;
	bh=Y/o632ILq4xwgUJuZ3iSv/m6ce8cJl7qjAjHOCUeYOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+WN1qSX+ahoiKrqAwNEKezMs4+w3nI2DmTV05zJaUSxKQgfysTB4cjGqhzshZSU9
	 IhEbMr+6eUnOZQEeNllprPm4MAjaMdnAvSzGEf9DbDW51hhN7DfeYyh2aP4eLBxNIw
	 Mc/jc4I/L2XK/aKK8+8c4jFy+R45lhmlqPRsXQgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.0 278/307] ntfs3: add buffer boundary checks to run_unpack()
Date: Mon,  4 May 2026 15:52:43 +0200
Message-ID: <20260504135153.256056740@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Tobias Gaertner <tob.gaertner@me.com>

commit b62567bca47408e6739dee75f02a2113548af875 upstream.

run_unpack() checks `run_buf < run_last` at the top of the while loop
but then reads size_size and offset_size bytes via run_unpack_s64()
without verifying they fit within the remaining buffer.  A crafted NTFS
image with truncated run data in an MFT attribute triggers an OOB heap
read of up to 15 bytes when the filesystem is mounted.

Add boundary checks before each run_unpack_s64() call to ensure the
declared field size does not exceed the remaining buffer.

Found by fuzzing with a source-patched harness (LibAFL + QEMU).

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Gaertner <tob.gaertner@me.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1008,6 +1008,9 @@ int run_unpack(struct runs_tree *run, st
 		if (size_size > sizeof(len))
 			return -EINVAL;
 
+		if (run_buf + size_size > run_last)
+			return -EINVAL;
+
 		len = run_unpack_s64(run_buf, size_size, 0);
 		/* Skip size_size. */
 		run_buf += size_size;
@@ -1020,6 +1023,9 @@ int run_unpack(struct runs_tree *run, st
 		else if (offset_size <= sizeof(s64)) {
 			s64 dlcn;
 
+			if (run_buf + offset_size > run_last)
+				return -EINVAL;
+
 			/* Initial value of dlcn is -1 or 0. */
 			dlcn = (run_buf[offset_size - 1] & 0x80) ? (s64)-1 : 0;
 			dlcn = run_unpack_s64(run_buf, offset_size, dlcn);


