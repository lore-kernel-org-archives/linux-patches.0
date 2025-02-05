Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DC61C6BE;
	Wed,  5 Feb 2025 15:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768064; cv=none; b=Git5VDy1RwUzTicQfrgQJGhCB6z08aVauTffILUt2T77A7E3cAx7AcNibLlgDkbqXqH0EE6AHsiUibOgkHX+0KgBfLSIOiSoMyVUESKRkW5TMA/i8p6fDrCFuOkwtmbvRaZL7jyK6irXt74hU68zIG8HFCektk/ZahRHLg0uCik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768064; c=relaxed/simple;
	bh=P/GkLfi5hJbt/fEUCVZl9299yiJxIJ9MAe0GCiEz2SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBFGO4DnBOTcYg5rbVi/hfYEJ8g3Wp+5KRwDONcp8pz/WKqLB22josjlDFa9ZW4KwXzeYmYeTGrKwkURFKw3rOO1lScmOzwI5maVep1NAJvH39OU8G5ZRX9SdW6dYRViRfHXU9Omlg3bLZpz9sSUtNIg4tFTekla0Xmjl0FCg1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fw1hur8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fw1hur8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D7EC4CED1;
	Wed,  5 Feb 2025 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768064;
	bh=P/GkLfi5hJbt/fEUCVZl9299yiJxIJ9MAe0GCiEz2SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw1hur8G6Nc2vfyjR7MTwKbchfKMSs6I4f+MtOQWe7Ycnmfzt9XygnyAiM3HaxLLq
	 Te1er3kUrr3XTDIDRjIj1jfMPP8Y8bbs4udR/y2/fzYqSAuGC8rzg6gBAw0WTk4t86
	 tUJN1tYObMrpdMxCgLZhY3El8E35KY7Q1wTavy6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 548/590] ktest.pl: Check kernelrelease return in get_version
Date: Wed,  5 Feb 2025 14:45:03 +0100
Message-ID: <20250205134516.235653593@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2419,6 +2419,11 @@ sub get_version {
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


