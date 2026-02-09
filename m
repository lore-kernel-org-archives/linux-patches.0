Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4956237BE88;
	Mon,  9 Feb 2026 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648839; cv=none; b=Iw1ePbR4tO1kZPXkF8wQViLgaFWlAfMp98MRzK8n02J2p8FgbsjeeLrG6RG7rjwJiuI4skxA/xN4zGG50dwcHm7YCyes1FnJ+6FKIkOe444XXjm7JD0XJeMkwNoPIo53hO3dQ7adRCOI4YRY8WeJr/s/SvtGagBWT7uvbwTLNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648839; c=relaxed/simple;
	bh=Wf+3Q/j2cavQAC6U8wUoDgz6af/YtEq85rAL97thHSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6tfmidd1fFx3MP+LvgkJbe/3C1uPvX7ZJf/0oe7TP5gQ7esk816RF8k+W/RMv19Dz1xbxnTNTncWTjaaA2ZUThnCrU8xzseGvsjQ+pt8EhL+IeFWi0h/AX+CzT8UFFTXUUclpcQkxI8v2NEfEn993thnMe8cXJdsf2777f+T8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVSzMCvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVSzMCvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA4BC116C6;
	Mon,  9 Feb 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648839;
	bh=Wf+3Q/j2cavQAC6U8wUoDgz6af/YtEq85rAL97thHSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVSzMCvrqznQbRa8KAe5SiJCbYywLAckHNXIu5G4thcgQf1EKLyxvpNVL5AUyTqpQ
	 x7quwCNJ9MgqOXvVWwRvKwZ/4PX1WiDiOt99RRHFhMeAiqts05rlp0X72zpj6BFCiO
	 G2Rb4YmnFpUTsbl3tbfaoxvwxpyDuDag4Xv8R0SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 23/75] binderfs: fix ida_alloc_max() upper bound
Date: Mon,  9 Feb 2026 15:24:20 +0100
Message-ID: <20260209142302.680991783@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit ec4ddc90d201d09ef4e4bef8a2c6d9624525ad68 upstream.

The 'max' argument of ida_alloc_max() takes the maximum valid ID and not
the "count". Using an ID of BINDERFS_MAX_MINOR (1 << 20) for dev->minor
would exceed the limits of minor numbers (20-bits). Fix this off-by-one
error by subtracting 1 from the 'max'.

Cc: stable@vger.kernel.org
Fixes: 3ad20fe393b3 ("binder: implement binderfs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260127235545.2307876-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binderfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -130,8 +130,8 @@ static int binderfs_binder_device_create
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
@@ -433,8 +433,8 @@ static int binderfs_binder_ctl_create(st
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


