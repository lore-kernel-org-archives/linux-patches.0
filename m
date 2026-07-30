Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17E63630BE;
	Thu, 30 Jul 2026 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422358; cv=none; b=ggSQp87NXXWkOSD8pN/sPEtuw909cSQ8Ko8Wj7h40yNwc6I3WnnIeLjSrp9Iw/v6nWXfzcvyNTT55PwrtEHuGVIteI34p93N4+71odGmVzKv3BWCO95sIoOrMD12p8AViEp+0tLRXpqEAC5mwCZIxOZQAHeDxLhu2zM1ao8n4Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422358; c=relaxed/simple;
	bh=6E1/VK0XSK4pR4Qvyg68erMtn4Hd45c7Kk9fYAadzJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpH0Tujr8PeArdh9MjDNRxqrxpuArGVBC228UUzH/OKAnH68p4RaaPjRljMajMq8C46+sHRQZrQgzPV87KgimHqiqMjOF3dp/XfiyczLpsiKLdSMbujCPCm23jBGJMgfEQA/7Y4+0rFihMljJ6C7WC3MyWtwO7gRWAXaaT6YpFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrHO98B/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrHO98B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B5E1F000E9;
	Thu, 30 Jul 2026 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422357;
	bh=cJLZQG+zccw+pG8h1sj5jXnjQi6VFjVvs5kqpQSeM6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrHO98B/z3TanAhpcXWVjvscqYni88xubSMGgGzyJ+qgNvgvthUGUyumdYElRURa2
	 cFQjRcSsBQkZFJ1EfsW/AZgPPHE4XJFsvG0fjAbck6+V2HAmDNH9LMuuk1sVORmTZf
	 OPNXzVM5Ym3us6ncsYweAtpWlXFdaHOQ/ZClbHcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Shuvam Pandey <shuvampandey1@gmail.com>
Subject: [PATCH 7.1 408/744] drm/imagination: Fix user array stride in pvr_set_uobj_array()
Date: Thu, 30 Jul 2026 16:11:21 +0200
Message-ID: <20260730141452.965901940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit 8dc8f3f4c2382fb7d1b1986ba8f33a2466cd3d7a upstream.

pvr_set_uobj_array() copies an array of kernel objects to a userspace
array whose element size is described by out->stride. When out->stride
is different from the kernel object size, the slow path advances the
userspace pointer by the kernel object size and the kernel pointer by the
userspace stride.

This reverses the intended layout. For larger userspace strides, later
copies read from the wrong kernel addresses. For smaller userspace
strides, later copies are written at the wrong userspace offsets. The
padding clear is also done only for the first element instead of the
padding area for each element.

Advance the userspace pointer by out->stride and the kernel pointer by
obj_size, and clear per-element padding while the current userspace
pointer is still available.

Fixes: f99f5f3ea7ef ("drm/imagination: Add GPU ID parsing and firmware loading")
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Link: https://patch.msgid.link/6a456012.eb165e5c.113c2a.b71d@mx.google.com
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_drv.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_drv.c
+++ b/drivers/gpu/drm/imagination/pvr_drv.c
@@ -1254,14 +1254,13 @@ pvr_set_uobj_array(const struct drm_pvr_
 			if (copy_to_user(out_ptr, in_ptr, cpy_elem_size))
 				return -EFAULT;
 
-			out_ptr += obj_size;
-			in_ptr += out->stride;
-		}
+			if (out->stride > obj_size &&
+			    clear_user(out_ptr + cpy_elem_size, out->stride - obj_size)) {
+				return -EFAULT;
+			}
 
-		if (out->stride > obj_size &&
-		    clear_user(u64_to_user_ptr(out->array + obj_size),
-			       out->stride - obj_size)) {
-			return -EFAULT;
+			out_ptr += out->stride;
+			in_ptr += obj_size;
 		}
 	}
 


