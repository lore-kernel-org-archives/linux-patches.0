Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9295C43F0A7;
	Thu, 30 Jul 2026 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424314; cv=none; b=Ye9reKlzcvMpXcU4WNJHYTG8IdfpH9vqtERM7E99fL4PEaFHWBQexN3ABRgxO8GyuIEhF76MxvPQ/sSUM9uN+7Bt3eb8RAkVMHFCx1SYw3iM8ZVF4HdCAMufpM5bfxVaojEorRCI61+XzxBbjdA2Lvbqmuvj/wZfHQW0YvpHkYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424314; c=relaxed/simple;
	bh=A/i34Hx/8ca8sk2pG5cfznb3Q77ExqzjsAJCO+2RWm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNp0Pbu2c3mqacjgiuWF76bZPDx3HGjT1sBOHYQRMHFDbUTb/xriIGGhezODkvbcGjgxYqo6rLywjqVwwkycq4UpikEhwo9RwRtv5jIQYxZjmlEEJYC7ODfUCevdlSNguOKOOPq1s+sEUT9am2b5z9DZDcE8Gp9w5k8LIB1jjlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8kLV1RN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8kLV1RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBD71F000E9;
	Thu, 30 Jul 2026 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424313;
	bh=iDNfa/vAd+VVatdRGVmHEVoz/4IW2We/JjW3MihKHhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8kLV1RN8m5fZI/PrWI011eupJLB5xYEoMJCjmBzC1zLcRONjvuZZ4Bp4wfTnpYgv
	 i1QWoJBQBRLx4wiQSz7hMh6Pp4d2N0uWQ5nePsBVIze0Q78CgQHh//hxmS9yefVo50
	 Lhi8eQx4RtcsH7QSy9y+8H7KwnUB0XY2HzGQCmU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Shuvam Pandey <shuvampandey1@gmail.com>
Subject: [PATCH 6.18 349/675] drm/imagination: Fix user array stride in pvr_set_uobj_array()
Date: Thu, 30 Jul 2026 16:11:19 +0200
Message-ID: <20260730141452.551380238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -1252,14 +1252,13 @@ pvr_set_uobj_array(const struct drm_pvr_
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
 


