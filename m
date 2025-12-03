Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917FA3128D8;
	Wed,  3 Dec 2025 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776731; cv=none; b=lpHayNu1K5oPIhABXRT0VOauUnzEQzEt3QBnodBNJZZxPDHNPYwa7JT1urINlla85bhSePXCwJEev6Pp2ciho/BCR4Khp0kmk14ANZ/UthGUivO2suag//QJbDXvn9l7T0UVX3xaMDqloVRMv77FcAKJj4lRTnH47CNrdD0Ghdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776731; c=relaxed/simple;
	bh=aQVrIWCt0oQYTmMmGQKOxMzOR3U/UG+oPyKF9466ML8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/aWZvZZULSTTCmLwE4hac2sdwtJKC6Faagdb9hoofUPC8xyewwNzHNbxSqS7Imm/5mNjmTuc0JRoJhmNQCwCaP5pJ7MHBBcSFsggr9GntD778PyhH04flq3lBqUUdRns93pG9tXR3ieatnJSm4GCgWpXQK9cRa8M2H9HEl/Has=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ll0s02f6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ll0s02f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA171C4CEF5;
	Wed,  3 Dec 2025 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776731;
	bh=aQVrIWCt0oQYTmMmGQKOxMzOR3U/UG+oPyKF9466ML8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ll0s02f6QUZe1A+pRHHl5r6lRTA0Jprk/a615h8abWLxr9Cg/CRVQZMLugDTPmKFm
	 XoVWYJIzye4s7zjFmjrX3db7zZJWCVBvgvQNL1IywzNG9BuMH07q2R9gVhW+7mVNbY
	 qaJnR66HC1IdpRXJERvFjLFv0/EX/cI+Wm09caLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 269/300] atm/fore200e: Fix possible data race in fore200e_open()
Date: Wed,  3 Dec 2025 16:27:53 +0100
Message-ID: <20251203152410.600489522@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 82fca3d8a4a34667f01ec2351a607135249c9cff upstream.

Protect access to fore200e->available_cell_rate with rate_mtx lock in the
error handling path of fore200e_open() to prevent a data race.

The field fore200e->available_cell_rate is a shared resource used to track
available bandwidth. It is concurrently accessed by fore200e_open(),
fore200e_close(), and fore200e_change_qos().

In fore200e_open(), the lock rate_mtx is correctly held when subtracting
vcc->qos.txtp.max_pcr from available_cell_rate to reserve bandwidth.
However, if the subsequent call to fore200e_activate_vcin() fails, the
function restores the reserved bandwidth by adding back to
available_cell_rate without holding the lock.

This introduces a race condition because available_cell_rate is a global
device resource shared across all VCCs. If the error path in
fore200e_open() executes concurrently with operations like
fore200e_close() or fore200e_change_qos() on other VCCs, a
read-modify-write race occurs.

Specifically, the error path reads the rate without the lock. If another
CPU acquires the lock and modifies the rate (e.g., releasing bandwidth in
fore200e_close()) between this read and the subsequent write, the error
path will overwrite the concurrent update with a stale value. This results
in incorrect bandwidth accounting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251120120657.2462194-1-hanguidong02@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/fore200e.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1379,7 +1379,9 @@ fore200e_open(struct atm_vcc *vcc)
 
 	vcc->dev_data = NULL;
 
+	mutex_lock(&fore200e->rate_mtx);
 	fore200e->available_cell_rate += vcc->qos.txtp.max_pcr;
+	mutex_unlock(&fore200e->rate_mtx);
 
 	kfree(fore200e_vcc);
 	return -EINVAL;


