Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E091F1A619E;
	Tue, 30 Jul 2024 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357778; cv=none; b=FdmRKVvdlBjAthThHry1pCacP3pT+7QYZnZfDvl419cSPtfVHTDDIgvZy6L+Iy4AA7KfRIfiN47Ldj3EnUxX0PRTh8CQVVNzwu0z9CvwEWm/elb2ZM2mR+9tTga6JT41DbzR6Uhsw2IUKIw6Lop6Hp/0xkvqb+PXaoqMrNf+zIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357778; c=relaxed/simple;
	bh=aQArY0RncdJr4OEubjT+de6TKETpmRWcE4q0/gtRXwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkp4oQo+hQCJeFudAnG/T08Jms4uzbiNbb2aiEOZslT4TInumEk9KFO9YU/PG1Vnsv4jgD5KfqTzw6OaHP8ZpU07y5J+GtYGJFCbZIGAo2sEa36zNdaNM6Z1dUScMwD8uyDe1+hMJQrPjDxCuEoZi1tQVNQuE/kna+c/V7KauIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zt/7Wkub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zt/7Wkub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0BFC32782;
	Tue, 30 Jul 2024 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357777;
	bh=aQArY0RncdJr4OEubjT+de6TKETpmRWcE4q0/gtRXwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zt/7WkubuqPRG6kjfw5OMxZ2bxREvdZWoCo2ANO3Dlend+auhbLb6tQP+rClB7Xzu
	 IisVGtTTXSowIndyF7scpsJ8p4YB2kn6pjxMklLyDq1NjP7ZPL1FK/+jrQNtEqaJRp
	 zBSZ2F3cj4JJb+FKqaKp+yCOSFRfCW+6DNTC/9w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 285/809] drm/amd/display: fix graphics_object_id size
Date: Tue, 30 Jul 2024 17:42:41 +0200
Message-ID: <20240730151735.850121182@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6d438caaeaa1a7fae7b523e7bc4cee262b9f101a ]

The graphics_object_id structure is meant to fit into 32 bits, as it's
passed by value in and out of functions. A recent change increased
the size to 128 bits, so it's now always passed by reference, which
is clearly not intended and ends up producing a compile-time warning:

drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_factory.c: In function 'construct_phy':
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_factory.c:743:1: error: the frame size of 1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Add back the bitfields to revert to the original size, while keeping
the 'enum' type change.

Fixes: fec85f995a4b ("drm/amd/display: Fix compiler redefinition warnings for certain configs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/include/grph_object_id.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/include/grph_object_id.h b/drivers/gpu/drm/amd/display/include/grph_object_id.h
index 08ee0350b31fb..54e33062b3c02 100644
--- a/drivers/gpu/drm/amd/display/include/grph_object_id.h
+++ b/drivers/gpu/drm/amd/display/include/grph_object_id.h
@@ -226,8 +226,8 @@ enum dp_alt_mode {
 
 struct graphics_object_id {
 	uint32_t  id:8;
-	enum object_enum_id  enum_id;
-	enum object_type  type;
+	enum object_enum_id  enum_id :4;
+	enum object_type  type :4;
 	uint32_t  reserved:16; /* for padding. total size should be u32 */
 };
 
-- 
2.43.0



