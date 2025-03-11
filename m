Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D291DF749;
	Tue, 11 Mar 2025 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706642; cv=none; b=oH2XOre9H7yYvdE3+q7XvcAeEYfXXKrbIt54QSJhvluElcp/xvbG3WRUAzsewxROrVy+yBok0G7u5capFjZYMTmGXhasLMdeYid5WNNjdWTR2wr1c90sqMoLm0NZs47qMzqp6klM0Z+v0FWCrgyx0+AMvkRoS6zY8BW6IQXeVyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706642; c=relaxed/simple;
	bh=aqxlDF+gFurza4xZ99gTuujUsi0BtfsRSySXoePZywc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9zs67slxE+cWTKMLAogCQK5U9tS2D6CgycI4rJgK5fWN5wtplN3TzralYpTRHRXN+pPgPw+DrlzstaIo+7+JhyVINPEfW72BL5qvd5vDu00FjwITgsErh3EVnC94M07rhZF/xNTX36VnH3NqXqqcm9iY3vdYOYa1WxsC7kww8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cK8mTHsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cK8mTHsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C38C4CEE9;
	Tue, 11 Mar 2025 15:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706642;
	bh=aqxlDF+gFurza4xZ99gTuujUsi0BtfsRSySXoePZywc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cK8mTHsJCtnu45Qaglxe7IyP5PnB4OT7aW6Sg1eooY5ZMPlqpGAotEBKKyG05BK+y
	 o4p64CrQbn3551qYWwU0/6ekVoIFXn7gS6Bf6fX8awR+MNoI742R34mNi1Mqt+LSRV
	 6FzWlqnVfePZuFRUIPB/0c0dzcmbelOPHFSh9xhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 118/462] ktest.pl: Check kernelrelease return in get_version
Date: Tue, 11 Mar 2025 15:56:24 +0100
Message-ID: <20250311145803.023533715@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2350,6 +2350,11 @@ sub get_version {
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


