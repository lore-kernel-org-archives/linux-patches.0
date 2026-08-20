Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180B337CD28;
	Thu, 20 Aug 2026 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238936; cv=none; b=i1S9317iDcauZbd8JajWZu8t8LALqFIcGiyes+Nrno7KO3xGhTpeOJvY7kNN9Eqi4UZZM8TMSRqJ53xUOKpRl7DczH0h8zTOu0PD5Q48sN94Wh108C1LmHNjXLfXg8eafH9iF6VE5sFGvCogMOFn8pJIwSZMgeeH3LBbk3eOKZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238936; c=relaxed/simple;
	bh=Y6uKuZGlG6cA3oNISSPflrYErsqzdK1crQ8h5iIo320=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfQFs04MRmLjmviE4GdJ3W89LgejhWbuMSsRxZr9xsNtQXNRLEr7UgZJf1CvZwSw+31egZt3g5siyqbKVYIj/S/0p5pNLe+xcoFiVuDRmHYHFaRfESUnUiACNcve2SAYzGL4yTu3pqA16qPdWlESoCDh+vVXskmoaqOqYs4oOqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yugmo5nX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yugmo5nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D791F000E9;
	Thu, 20 Aug 2026 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238934;
	bh=KDG3DtB5R/blWg+ebUlv+LnG30q947msGy/uzqneMHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yugmo5nXNkXFeY5BIkXt2JeipkhGO+S19CC7yDlXqsilquZpUQRUu1Bton9hWjovw
	 9CFW6t3wJE8aqhCAtjFd0X3AXaQgz7Vx8epWhmFHWc15X58KQRgguNzjbLotrY8+kh
	 ZLeEToFtkC+qBwA8xdBOXyxS0zhKNMN7TaRpndg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 093/217] drm/amdgpu: Reject UVD message with invalid number of h265 refs
Date: Thu, 20 Aug 2026 16:54:21 +0200
Message-ID: <20260820145240.550939547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit 9fca434208f1f9ab977feac62df8ebb1cc7ce893 upstream.

Same change as for h264, avoids overflow later when calculating
min dpb size.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a4b0720e4f1601f97f59a2be9c1b4b94fa6527d5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -802,6 +802,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		image_size = ALIGN(image_size, 256);
 
 		num_dpb_buffer = (le32_to_cpu(msg[59]) & 0xff) + 2;
+		if (num_dpb_buffer > 17)
+			return -EINVAL;
+
 		min_dpb_size = image_size * num_dpb_buffer;
 		min_ctx_size = ((width + 255) / 16) * ((height + 255) / 16)
 					   * 16 * num_dpb_buffer + 52 * 1024;


