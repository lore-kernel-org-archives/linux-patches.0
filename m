Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2B330567C;
	Thu, 30 Jul 2026 15:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426028; cv=none; b=Uj1BH3JEiWZuIMX+A9Pp6Qn39JBzcxhigHRXVcZDUYemJM9KGKE6kdxrCQcd65aJhd8S8Tuz4f2Pe3N3o30Y0qgSnqhx1QPFOIaJ4MrTDg9sh//qGOkI4emcy8ADujc1cpMT35yXcOsolM6abi4KmVNuPHeKLonBJ0TGsBfiXzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426028; c=relaxed/simple;
	bh=ZH/ll3j55Xu0PqmilcqreRXynlDwd3u35cqiWEJqPNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NW//FPV5InamUFZ9PjbrJsuEtzUkOhORI0S2jpmUWMmpT6NAfaKYvLjsi9hNBWkuoG2ei0Fyf7WsLcPCv1H6KNqiobGgUw6o9cqbHIuQ748N/7r5/AA+u5X5BOeg7nvYrE4Jt8XGr581eW5bxWTwt+0FWYGLqlzzu0mbL4OW6rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMRz40RB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMRz40RB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275AE1F000E9;
	Thu, 30 Jul 2026 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426026;
	bh=wDJsJ9L50FUhCVbFJttPuUZVwiWUKispb9TVDb++itU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMRz40RBSHm/JHhP5W1/A2PbM76P6OgZxHu2YYq5y/Jb5T0/8OX9TAxiMZB/EZdGv
	 OinhZcqUD7k5vh5RswWIPHQ+2F4rP6uGgtwSfh6xseKwXmmwxfLSl8RjDQVuoyxiPm
	 Xajm3C/6nv3lLIHgRUstXLrC51ASR4ZBXapfv1CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 273/602] drm/amdkfd: Use kvcalloc to allocate arrays
Date: Thu, 30 Jul 2026 16:11:05 +0200
Message-ID: <20260730141441.708185152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit 9c8b85f95c1d4736b967e17b8eb4a463c055bea3 upstream.

There were a few instances in kfd_chardev.c of kvzalloc being
used to allocate memory for an array.

Switch those to kvcalloc, which
- is the standard way of allocating a zero-initialized array
- does a check for the mul overflowing

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 60b048c93f7a3add39757ad65fe2bb6e58eeae23)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1795,13 +1795,13 @@ static int criu_checkpoint_devices(struc
 	struct kfd_criu_device_bucket *device_buckets = NULL;
 	int ret = 0, i;
 
-	device_buckets = kvzalloc(num_devices * sizeof(*device_buckets), GFP_KERNEL);
+	device_buckets = kvcalloc(num_devices, sizeof(*device_buckets), GFP_KERNEL);
 	if (!device_buckets) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	device_priv = kvzalloc(num_devices * sizeof(*device_priv), GFP_KERNEL);
+	device_priv = kvcalloc(num_devices, sizeof(*device_priv), GFP_KERNEL);
 	if (!device_priv) {
 		ret = -ENOMEM;
 		goto exit;
@@ -1921,17 +1921,17 @@ static int criu_checkpoint_bos(struct kf
 	int ret = 0, pdd_index, bo_index = 0, id;
 	void *mem;
 
-	bo_buckets = kvzalloc(num_bos * sizeof(*bo_buckets), GFP_KERNEL);
+	bo_buckets = kvcalloc(num_bos, sizeof(*bo_buckets), GFP_KERNEL);
 	if (!bo_buckets)
 		return -ENOMEM;
 
-	bo_privs = kvzalloc(num_bos * sizeof(*bo_privs), GFP_KERNEL);
+	bo_privs = kvcalloc(num_bos, sizeof(*bo_privs), GFP_KERNEL);
 	if (!bo_privs) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	files = kvzalloc(num_bos * sizeof(struct file *), GFP_KERNEL);
+	files = kvcalloc(num_bos, sizeof(struct file *), GFP_KERNEL);
 	if (!files) {
 		ret = -ENOMEM;
 		goto exit;
@@ -2470,7 +2470,7 @@ static int criu_restore_bos(struct kfd_p
 	if (!bo_buckets)
 		return -ENOMEM;
 
-	files = kvzalloc(args->num_bos * sizeof(struct file *), GFP_KERNEL);
+	files = kvcalloc(args->num_bos, sizeof(struct file *), GFP_KERNEL);
 	if (!files) {
 		ret = -ENOMEM;
 		goto exit;


