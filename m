Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04546349CF8;
	Sat, 30 May 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158770; cv=none; b=osaHk+QFy5YbODplXLWg6v359P10K6gEUrDIHA5j8PKG8RSZjCMm86AqNoT6K3X/ZHNouhJWbBGDF/q0eZizfnstm5bymZsnKMo/n27DdUiq3hVvRoDAJgb5dxxJyn+vTz+4wRygvV9Dydoq4m63fqqDM9uc/4fHBT8d17qeaKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158770; c=relaxed/simple;
	bh=AQDNaGl8AvQF3t6qxxsfGIMHKrZo3QrF7Za3KDKyfrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpiXAM5VbaZWpB0qzlEuhtwjetyBQhr+xn1WrcBGIVcUk13fO6pF5HMJTYNXF5Ud2LcihxUoOHdSqy+bc0c4n7VSazC+lPsUjrngef713fxzmjkoC56pjDuljiWAp3nXBFRC5lSfMbFSSFcAgBAYGADJPrmxUoREQWVPvvVSm/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6Lkjsai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6Lkjsai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD501F00893;
	Sat, 30 May 2026 16:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158769;
	bh=2MiP6HIOd0KRHLi9i+YAxo94jvEQYjp60HhVo5CxNFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6LkjsaiXgRyBrxJ5z8QtR+byz+fb3YKKksSFyxcxQKk7Lqc6t4HhBZTA9XE7L0ZB
	 WpBqwcCBDLPoNiW06SyC6qqochpRFsZPLruWYzldHAkh+dKdRESMOBxiNh2eV7rqo7
	 KKyGMlgd5hRl/68qWysFqDJ4AEbVrXPwMp0LUKrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 080/969] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sat, 30 May 2026 17:53:24 +0200
Message-ID: <20260530160302.558445385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 0beba407d4585a15b0dc09f2064b5b3ddcb0e857 upstream.

Patch series "Docs/admin-guide/mm/damon: warn commit_inputs vs other
params race".

Writing 'Y' to the commit_inputs parameter of DAMON_RECLAIM and
DAMON_LRU_SORT, and writing other parameters before the commit_inputs
request is completely processed can cause race conditions.  While the
consequence can be bad, the documentation is not clearly describing that.
Add clear warnings.

The issue was discovered [1,2] by sashiko.


This patch (of 2):

DAMON_RECLAIM handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered in [1] by sashiko.

Link: https://lore.kernel.org/20260329153052.46657-2-sj@kernel.org
Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org [1]
Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [3]
Fixes: 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -71,6 +71,10 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 min_age
 -------
 


