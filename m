Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F09217CA12;
	Mon, 10 Mar 2025 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629132; cv=none; b=l10EGKDCO4nCfd1d2fyHy3xrI9kXACZbrnSv9be9mYwMJx9n6e0BKybSb29Q/kpEEBwAYrM4+xSGOOVl7nGeSlkoByw19pqXqP4qFom7WhtgjwpCKUcuP55kpV4DfMP/XkU+3oOhwOVyxbM+scP0+DnlWdFeQblbJItToAEWXZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629132; c=relaxed/simple;
	bh=NGyjM800FCvgNl2zHlnIMFYsc7h5z8N1YhJP+OXKoBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHE/Jbz/kfLvYy7WOwcecv1s/NGoXzOtC1HjmpKwHPy1cw4VG2o+ghHcQqIQNXbo8wo5Iyz3JrAeH9DS+qBGlugVWNiDQqL/+/rmQDCBtSn/c1SogsGrB040Cb0h7g12s7Yywq22ZS9ljzsBqSWldizGtujU4JMMzDnPisFSt14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07acrBLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07acrBLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF4C4CEE5;
	Mon, 10 Mar 2025 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629132;
	bh=NGyjM800FCvgNl2zHlnIMFYsc7h5z8N1YhJP+OXKoBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07acrBLRfbWFfNITC+/R6+MQyfFtvDUf8KNmZgymWuvqgMzNPnawutNIX1V33cje2
	 Cri1aD1LhIoziWTqHe/yaqsw2YYAoIQvjlhRa5poLtecJVOXT3SrhJOIzyQkEHdmQn
	 I4OTHgejQAH/qVDMPdvq+6MnMs20n5/lgA3N2Ov4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 189/620] ktest.pl: Check kernelrelease return in get_version
Date: Mon, 10 Mar 2025 18:00:35 +0100
Message-ID: <20250310170553.095504932@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2399,6 +2399,11 @@ sub get_version {
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


