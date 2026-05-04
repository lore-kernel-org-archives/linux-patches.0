Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108963DFC93;
	Mon,  4 May 2026 14:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904775; cv=none; b=qK2Hjd2zXGjtZdZUBTjkRzGpXRiYQAD1KN5KpmLhiVjUs8E0w8V6qPNMFmrwCJyznptVQOzsHp7hpJ1FwtfgH5vrVdQ0tIflE9bTea8TUwQGwL/KK7XTDeCs5LYKhW6Zd7Pm0tXg2cD3pbSvbxMvZ+fpIA1vFAdaqRkzgwwhCW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904775; c=relaxed/simple;
	bh=Id2dqoLjCZREh+xim21tmu+NU/ry7Dk84LQFxmDwhus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMk81lqGUAvddF1Uc6/pq7pvwPE8Y5x/VDGkTtYs3ZkJm0K2wT4JmeDbw88XRWwqT7BYmwkIRRMpqduSGr4OGkhZxV/yzhjk2kjpcR1iY4kcMi2EicJVdHk97bYuS2OEWyHtG3GWd6CPI2voeAvutJhitdGvBZ/IqP77Vef5Lik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qooZW01L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qooZW01L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F8AC2BCB8;
	Mon,  4 May 2026 14:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904774;
	bh=Id2dqoLjCZREh+xim21tmu+NU/ry7Dk84LQFxmDwhus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qooZW01LDmpyy1yr2mlef/I76vsAIqzsW5GQENYXj1V1BgxXXNqWekl5KINJiJG/a
	 qGzjaPjtkUWQkumjslHQ28tCyUYRIoHp/UvVPp+4R+Esy8Ls8kdzjrT8xccsXnPsDu
	 4b2yikyGUsuhyso5X/xUh/wtLJkVFKxHDjsiVEWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 168/215] ntfs3: add buffer boundary checks to run_unpack()
Date: Mon,  4 May 2026 15:53:07 +0200
Message-ID: <20260504135136.318846312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -963,6 +963,9 @@ int run_unpack(struct runs_tree *run, st
 		if (size_size > sizeof(len))
 			return -EINVAL;
 
+		if (run_buf + size_size > run_last)
+			return -EINVAL;
+
 		len = run_unpack_s64(run_buf, size_size, 0);
 		/* Skip size_size. */
 		run_buf += size_size;
@@ -975,6 +978,9 @@ int run_unpack(struct runs_tree *run, st
 		else if (offset_size <= sizeof(s64)) {
 			s64 dlcn;
 
+			if (run_buf + offset_size > run_last)
+				return -EINVAL;
+
 			/* Initial value of dlcn is -1 or 0. */
 			dlcn = (run_buf[offset_size - 1] & 0x80) ? (s64)-1 : 0;
 			dlcn = run_unpack_s64(run_buf, offset_size, dlcn);


