Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3C41662EF;
	Wed,  5 Feb 2025 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766553; cv=none; b=CtZ0nqJIfgcPAXx2/XEosIInDz6vAw5QILQ9QcbubUMwBH+P3FMNd7c4GZdS7l1pqfoXgjmiPjZx2rVrw5imKGECV7r8n3kPMb6IJHH0KhNKX/TJ/vwa1R1mPMnqVb6VK6I+yOPnbulMN1IFKf7NZv4zlTfnjjJ27Boae573xTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766553; c=relaxed/simple;
	bh=qTVzLor/R2Nr+BrodBtRWZ+wCtqWi0zDORQWubDycbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3GBV3Vz/xiuhdo0QvwHqont1rTbrnBfJe2x8Bn2uMTDvJlYBRvHgkAPaJxzZSXfqxu6ds5uM6yXAwqiOa5UJ19DrhXPbW+70PsHhZ46CsRKJrkDRg5wOUvugopoDvAzeUAK/votozK8r2WZLFxbZcrjApbw0BeT0ZpuwsbnhYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ECRhV/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ECRhV/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6121DC4CED1;
	Wed,  5 Feb 2025 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766552;
	bh=qTVzLor/R2Nr+BrodBtRWZ+wCtqWi0zDORQWubDycbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ECRhV/HZprRTIFw24BKHpNXBzaA2TT0xxmOlLwWlUULCpAHRIBfAhgVSP/x0h8UX
	 ohwp/QUAq7yUgFL90ctvRvvixx2aSqH6b8VDxRIPCns+vn9r5H69EXM4NNz9EaMwjc
	 aTDMAYmc0eAd3Q+B9koeEc0XxbkjQi8A9i4c/seU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 373/393] ktest.pl: Check kernelrelease return in get_version
Date: Wed,  5 Feb 2025 14:44:52 +0100
Message-ID: <20250205134434.567555988@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Ricardo B. Marliere <rbm@suse.com>

commit a4e17a8f239a545c463f8ec27db4ed6e74b31841 upstream.

In the case of a test that uses the special option ${KERNEL_VERSION} in one
of its settings but has no configuration available in ${OUTPUT_DIR}, for
example if it's a new empty directory, then the `make kernelrelease` call
will fail and the subroutine will chomp an empty string, silently. Fix that
by adding an empty configuration and retrying.

Cc: stable@vger.kernel.org
Cc: John Hawley <warthog9@eaglescrag.net>
Fixes: 5f9b6ced04a4e ("ktest: Bisecting, install modules, add logging")
Link: https://lore.kernel.org/20241205-ktest_kver_fallback-v2-1-869dae4c7777@suse.com
Signed-off-by: Ricardo B. Marliere <rbm@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2406,6 +2406,11 @@ sub get_version {
     return if ($have_version);
     doprint "$make kernelrelease ... ";
     $version = `$make -s kernelrelease | tail -1`;
+    if (!length($version)) {
+	run_command "$make allnoconfig" or return 0;
+	doprint "$make kernelrelease ... ";
+	$version = `$make -s kernelrelease | tail -1`;
+    }
     chomp($version);
     doprint "$version\n";
     $have_version = 1;


