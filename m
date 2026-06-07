Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4E9296BCC;
	Sun,  7 Jun 2026 10:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829667; cv=none; b=h0jlRbhZWwhErsbRlnqFI5qt5oPOmhcxj2nri0scLktelgHMuT3XVP9D1mxx/h0G9AM9tVpDJ6JG2Sr6bjWSP4bAoMkpDvXaifqnlL8PXLd7QIE1OXAOY81QxNPQHy7IO3oRP1ayuV5bK5Tqf4kbWUP3huOdl7tr9mCDy34KCL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829667; c=relaxed/simple;
	bh=RegwlsIXeh5dzYXliRPanurbA5k1dNoRvS+LnAbrsLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRaFxIKQSMOXhGlauB18rN7rwnnczo0xo2Z0NJO91FeG7n46j9wFm44ksDoz08XiIVbVM755oiHY2AzeYJX6vQpjUArsIjEKe00J0j5w1btTC4F7pceX8Ljn2JCFtktdxSxR5Qw5Ub6HMjyAxRlSK7nrgIXf4saIPJtsBZ9gPRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpeUlTc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpeUlTc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934D71F00893;
	Sun,  7 Jun 2026 10:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829666;
	bh=3E3WaD238lru0wqQholobNpE/VIF6oaklsGd7SeO4lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpeUlTc3p6NQHWtBy2awigNvO5Np9S45EEHuNdUtEl7l+c+G36To+wBM+5uUIlk4q
	 zd2iZo1kVZSqt0+k0TVIPH04mmAreKAeg5eelYGUEfXGh1PLpDbaWzczh4Lu6EzwWB
	 pwUCmrtIKxliJT83DOHoWN5xdwZ+/hF6soYkhy5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 269/315] drm/amdkfd: Check for pdd drm file first in CRIU restore path
Date: Sun,  7 Jun 2026 12:00:56 +0200
Message-ID: <20260607095737.447330355@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -2253,6 +2253,11 @@ static int criu_restore_devices(struct k
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
@@ -2262,11 +2267,6 @@ static int criu_restore_devices(struct k
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


