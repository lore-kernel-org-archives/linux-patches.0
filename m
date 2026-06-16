Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B02E335081;
	Tue, 16 Jun 2026 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631371; cv=none; b=EgKUIr1Bw3WXo6HOL5XT3iCFWkifuK6BD8m9CdckeTYb/SpAP7EdPn6X/HddHEm8que2k0bXAaqPyhZBKw1NMuj1vMo2+OY1v1a2188tDo31QkHMMOh4FavdNnrEgFj80eSePIta3xj/2W40LKSc94BwwxAJ9WJqtXzvhfyMbu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631371; c=relaxed/simple;
	bh=0Nf/V7DiuCHNdMBINvuB9wHaa4c7AV0KoXPSOXL4VHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBPAAK+ebXgsls3A7Xo2bagvBdxrI4ZLKi9BSirBcwwwq41M9hMMsmH1woytJ15oG330iNrGQCvyDjqws6RgFl9Z8iXNyVVk8y9wx4lcFbI4gIzebgl8YEnFYGtaKzi7g/rOf/9DWhw+o8SkHDONdZp49ihRUBZfcJt5HdIFp7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrDclyIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrDclyIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2F81F000E9;
	Tue, 16 Jun 2026 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631370;
	bh=kQxowTJVsmHuM7Ngj4kuLyUdWKHNjGczNmBnTG8x23Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrDclyIhbH3DvnX0zMTy/JQ95in1YUN9+RFrckE9BUdKZiL2c1T82q5sowNAZYzgV
	 xk3qAT8TxMeUyWglmPJMFt42IEUGhoAgfWv+17jRZ+tHrUYxU2R/cQPdyBMayHEjNN
	 JFLbEx3wzENIJmIjnz/XmR0SXkz27VqCS6ISRSg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 175/522] drm/amdkfd: Check for pdd drm file first in CRIU restore path
Date: Tue, 16 Jun 2026 20:25:22 +0530
Message-ID: <20260616145134.331708622@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: David Francis <David.Francis@amd.com>

commit 6842b6a4b72da9b2906ffc5ca9d846ace2c54c14 upstream.

CRIU restore ioctls are meant to be called by CRIU with no
existing drm file. There's an error path
for if the drm file unexpectedly exists. It was positioned so
it was missing a fput(drm_file).

Do that check earlier, as soon as we have the pdd.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2bab781dac78916c5cc8de76345a4102449267d7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2171,6 +2171,11 @@ static int criu_restore_devices(struct k
 			ret = -EINVAL;
 			goto exit;
 		}
+
+		if (pdd->drm_file) {
+			ret = -EINVAL;
+			goto exit;
+		}
 		pdd->user_gpu_id = device_buckets[i].user_gpu_id;
 
 		drm_file = fget(device_buckets[i].drm_fd);
@@ -2180,11 +2185,6 @@ static int criu_restore_devices(struct k
 			ret = -EINVAL;
 			goto exit;
 		}
-
-		if (pdd->drm_file) {
-			ret = -EINVAL;
-			goto exit;
-		}
 
 		/* create the vm using render nodes for kfd pdd */
 		if (kfd_process_device_init_vm(pdd, drm_file)) {


