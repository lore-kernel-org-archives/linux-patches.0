Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5F725E81A;
	Tue, 11 Mar 2025 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705579; cv=none; b=OUcczF+xy+Tzui4L6tWc5gXvuVNlQ1LGBixKo7xNuprrEjef1dgyb30FMrvJluTcj2AD2VPAqQKIftnv6IqvrxezMEja8VivAMSZtjzF5NAE2tCEQR+XlG65ZhlKYr3z/EI9rrkbDoUuvt2Ngs6iYbi2mcwC818+seNes61SyVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705579; c=relaxed/simple;
	bh=fY7AZMK8mgHf7Mr7KtLu7hhwSbZESfu3E1NgsXyQ+Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrYXR4RxHF8pXntcdOnoUH0lmP5bSlinKZrB0zLjQwNDhLBjKdKEjNX0x6+yLoVPKkhQMpHYj0y0tP89vU1jh1ir931T8lpFxTHkDg/7+MXJY+fmiLCgimcdo2nzCRG9avwo/YPAjrxtghXXQ9hC/aW0TbU+NVP5GpOO6KRpp3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oe53AFx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oe53AFx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EBDC4CEE9;
	Tue, 11 Mar 2025 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705579;
	bh=fY7AZMK8mgHf7Mr7KtLu7hhwSbZESfu3E1NgsXyQ+Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oe53AFx2oBUDyA46Frj02jxzhcnPEHZBC2I0vp2QelEINkwBM59IzuJQ2T7YbeKZL
	 K33wO2a5LpReoPN2Qzw0ks+CtTfBvS992amrS23GSuWrh33yXEn68PESS15X8LhhjQ
	 4QZQbNSMVrbwRUqkcgSWYE0570YwZdSSBSB0TowU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.4 076/328] ktest.pl: Check kernelrelease return in get_version
Date: Tue, 11 Mar 2025 15:57:26 +0100
Message-ID: <20250311145717.910388206@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2319,6 +2319,11 @@ sub get_version {
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


