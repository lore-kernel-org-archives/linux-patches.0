Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8731DE88B;
	Thu, 30 Jan 2025 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247429; cv=none; b=lSt3MkOKi1sDlFZQsetJSTkEShjs6lZgqTDVBcP8+Cx+8/V5lhji7CZdbfTnklhwYJU48MZ8R4dM+mLZ3VmAA+CM3B5rwQ6SjnpYMyGz5okASvtbhh83Fw0qvqMg2VT2ASBbh4svRB3GNEI/OWKFid7lu01yRJVBXEFLqPL0Uco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247429; c=relaxed/simple;
	bh=iJcl9dFhpT4MCBSOcytkpQmwRcndYyMrt3tyfH9M588=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sK+Q8OKOZ/Gq6VsFnesqbJzLE6+Ai/8mg1yUhy0gv/i9zaPx8KEGRh482wE04VTzdF5Cmq/1qipObHJE96M1TnUJ1oDMYJC/kLrfBAyg9azA6Xb6JY67OuhJ4uQBSU4iLgJmb+BvmpOdzzAwvYeHkLnc4p2XiaY9eQwOTk5/0sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuE+5m8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuE+5m8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90966C4CED2;
	Thu, 30 Jan 2025 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247429;
	bh=iJcl9dFhpT4MCBSOcytkpQmwRcndYyMrt3tyfH9M588=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuE+5m8UUlEDAJIIRGYnur5UWMfiAv2Jbg+uuafWx1VrsfPWMlR7/bvpCgPsx1IDi
	 nEaS6kz7LGUp4htzn7tdqb0OwhLsNC7svZXv8t+pehAe08ZwgVdMnMlRLADP9QQ8ip
	 A7H/yapoD6y90Jv2VTAAfIMn263V5fbSD9G+C7OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.1 36/49] vfio/platform: check the bounds of read/write syscalls
Date: Thu, 30 Jan 2025 15:02:12 +0100
Message-ID: <20250130140135.283703118@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit ce9ff21ea89d191e477a02ad7eabf4f996b80a69 upstream.

count and offset are passed from user space and not checked, only
offset is capped to 40 bits, which can be used to read/write out of
bounds of the device.

Fixes: 6e3f26456009 (“vfio/platform: read and write support for the device fd”)
Cc: stable@vger.kernel.org
Reported-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_common.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -391,6 +391,11 @@ static ssize_t vfio_platform_read_mmio(s
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -470,6 +475,11 @@ static ssize_t vfio_platform_write_mmio(
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);


