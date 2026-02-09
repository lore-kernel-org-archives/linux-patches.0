Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E835CB6B;
	Mon,  9 Feb 2026 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647252; cv=none; b=kRi+ixlMp5QJoQCVe+QQdvexVXs2vsBGIS/4bd/5Pfsig6s+OMhAIR595klp9SNOpQ5TNlXTUa2AL1M7SqYMc6u5HSKltXJhSGx/lJnzxoGHvICaTkO/OzeIQXTrw4IDOyO9niciCeJyu8e02l3oofbpO8dnDXlvBunVyJtE7ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647252; c=relaxed/simple;
	bh=/4xrIRW0K5m1ZPmHOnORPcxfvagEd0K2A2uOiIsmUZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG8z7TZ0wKvSlqspwnh00ZB02pxJufYUGYKoWY3bZi1SJUPDASgLtSBeXj2tTz6v2ikVFeuBFB91BwA8fBv/U7R8lIcD7WqD9b3vyLzVPDLysQPjWcLQwtuZJVJd2dvW2x/2HmYkCU+62YoizflCvKdwglI5LJT0Z4bry7kLzPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtwBfEej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtwBfEej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F5FC116C6;
	Mon,  9 Feb 2026 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647251;
	bh=/4xrIRW0K5m1ZPmHOnORPcxfvagEd0K2A2uOiIsmUZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtwBfEejY3axixbQXVCcq3q7uMq9kcB74ZTPfjbXlQ2ppX/QlTJVMqzkpXprzBoZz
	 fMRbJNFL9n8KsZBwUzPx4SWW7u+I1UjYlHYAq2mddCD24y7/dX4HDA8DCAGfk5gg1C
	 /fRDQ+MngiIERMryTGaypDpojZIi0IVjXDWyrD+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 043/175] rust_binderfs: fix ida_alloc_max() upper bound
Date: Mon,  9 Feb 2026 15:21:56 +0100
Message-ID: <20260209142322.023620411@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit d6ba734814266bbf7ee01f9030436597116805f3 upstream.

The 'max' argument of ida_alloc_max() takes the maximum valid ID and not
the "count". Using an ID of BINDERFS_MAX_MINOR (1 << 20) for dev->minor
would exceed the limits of minor numbers (20-bits). Fix this off-by-one
error by subtracting 1 from the 'max'.

Cc: stable@vger.kernel.org
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202512181203.IOv6IChH-lkp@intel.com/
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260127235545.2307876-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/rust_binderfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -132,8 +132,8 @@ static int binderfs_binder_device_create
 	mutex_lock(&binderfs_minors_mutex);
 	if (++info->device_count <= info->mount_opts.max)
 		minor = ida_alloc_max(&binderfs_minors,
-				      use_reserve ? BINDERFS_MAX_MINOR :
-						    BINDERFS_MAX_MINOR_CAPPED,
+				      use_reserve ? BINDERFS_MAX_MINOR - 1 :
+						    BINDERFS_MAX_MINOR_CAPPED - 1,
 				      GFP_KERNEL);
 	else
 		minor = -ENOSPC;
@@ -416,8 +416,8 @@ static int binderfs_binder_ctl_create(st
 	/* Reserve a new minor number for the new device. */
 	mutex_lock(&binderfs_minors_mutex);
 	minor = ida_alloc_max(&binderfs_minors,
-			      use_reserve ? BINDERFS_MAX_MINOR :
-					    BINDERFS_MAX_MINOR_CAPPED,
+			      use_reserve ? BINDERFS_MAX_MINOR - 1 :
+					    BINDERFS_MAX_MINOR_CAPPED - 1,
 			      GFP_KERNEL);
 	mutex_unlock(&binderfs_minors_mutex);
 	if (minor < 0) {


