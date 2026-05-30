Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EDF304BCB;
	Sat, 30 May 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163446; cv=none; b=WkuVOTd6b4JGh9iirVc+raQ9EBFYDsuRox3r+OUcTT017yXGO4W10N0LaS+G6VogfdSpMvL7S/oGdnBUsLXETU/oPQ6lOa/bkCGHxHUZOaEl/85XyUkuiPVM6bdY/Day4fXTRgl71jBpAp3jzsZNQGr3DbQ14Mu0BumWPTYcyYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163446; c=relaxed/simple;
	bh=EqJ1yYXdpKd7nEeZrKLvDBiGghoeYWAX+pu5e2wq4kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf2Rf4I++8e9BggECPz7H5H+yW/Ikc87BPQTayKGDZwndTuGtubEhOw50H4KfrjyL8n/n1FO1zXAHVd2579e3jhNKf9/f2Lt9xPmcY+aTDA7bBVinVR1pxYNZQTKG4Db8F79HKj5xXmcXfbwhoG+zCei0A5+kGTFBDXSF2hesss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WN5unPdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WN5unPdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFD21F00898;
	Sat, 30 May 2026 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163445;
	bh=g02kjeOMie9lCOd24LkUgQ10rV0UIt+9LcGQoy5v5co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WN5unPdCPEUU/vGN18yM+YsPwKiKq15wQomJwfzmVZEzrH2YK7apK7+Duq9f8Dsvy
	 ACGcA+Jr69ar31u7z70QhNu0DXA8cQY5/G4ViTxde5+qBdJYkAsUmPrZ2bzShECSzj
	 pkgPOyMrsus+7N2fHUsJHNywtRbx4N9WecYdrU1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 259/776] ntfs3: add buffer boundary checks to run_unpack()
Date: Sat, 30 May 2026 17:59:33 +0200
Message-ID: <20260530160247.230570758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -916,6 +916,9 @@ int run_unpack(struct runs_tree *run, st
 		if (size_size > 8)
 			return -EINVAL;
 
+		if (run_buf + size_size > run_last)
+			return -EINVAL;
+
 		len = run_unpack_s64(run_buf, size_size, 0);
 		/* Skip size_size. */
 		run_buf += size_size;
@@ -928,6 +931,9 @@ int run_unpack(struct runs_tree *run, st
 		else if (offset_size <= 8) {
 			s64 dlcn;
 
+			if (run_buf + offset_size > run_last)
+				return -EINVAL;
+
 			/* Initial value of dlcn is -1 or 0. */
 			dlcn = (run_buf[offset_size - 1] & 0x80) ? (s64)-1 : 0;
 			dlcn = run_unpack_s64(run_buf, offset_size, dlcn);


