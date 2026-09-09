Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E85C569F10;
	Wed,  9 Sep 2026 14:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964111; cv=none; b=YDIXnPKjzHOledzH1vNBDP+0585DD5adNGsxwz4Z5QYFyDF7FHR2aRy6OEX55mgrbDwEl3UfQSDP0I0Bp5F0CaXU7O8zFcQgJCuvKPWfzMX37gIzFe740NDszQw9KBHn+OkkGfEKjK/khGi7pneUtEJ/6NAQjezUmAq3cqXNLiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964111; c=relaxed/simple;
	bh=4FHping5uUw9F/6lGwAHZcIaW6JTn+ibIc6hfAe5+qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aT9A/Xsj4yy456IvmEbkxZ72zEtn8F60oux3xk+OwrLiwPZaANLcrJE48bgYpIO4lcnJdVtppNo+DTvLdZayf0lXvN2qvylH7rcpdMAn6KzJv1KrUvmx5FKawka/J1Xf50brAZSNi2uvicyp97RWaEv2O8+CuYjrmCR6LFE0Ot4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhpVAmpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhpVAmpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11511F00A3A;
	Wed,  9 Sep 2026 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964110;
	bh=OcMr7mEGULzpCEo0T0FjE0nBQKroW6MWk/bZvAvpC64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhpVAmpg7AvJUqXKqUfHEAf3DHi9hqvPutInMlTo1JofzU56CDU3i8mt37sPddy6U
	 4jkrby/gHt8llWvb1PJQgjT9KjqCtNNDeOiD4T6ayykZ+s/ha3aGIPC403Oh6/O9p1
	 SW4tlIn4C40XaeTfb2hrlSIpwYcyK1U3H11DOsdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Deborah Brouwer <deborah.brouwer@collabora.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 273/583] rust: drm: ioctl: fix unbounded lifetimes in ioctl handler arguments
Date: Wed,  9 Sep 2026 15:39:18 +0200
Message-ID: <20260909134247.539329444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

commit 68b151bc6145dea3db5598ebaf4b776cd205e395 upstream.

References to dev, data, and file in the declare_drm_ioctls! macro are
created via unsafe pointer dereferences, producing unbounded lifetimes.
If an ioctl handler explicitly annotates its parameters with 'static,
the compiler accepts this, allowing the handler to stash references that
outlive the ioctl call.

Fix this by adding a higher-ranked function pointer coercion that
enforces the handler accepts universally quantified lifetimes:

  let _: for<'a> fn(&'a _, &'a mut _, &'a _) -> _ = $func;

Since the handler must be coercible to a function pointer accepting any
lifetime 'a, it can no longer demand 'static on any parameter.

Cc: stable@vger.kernel.org
Fixes: 9a69570682b1 ("rust: drm: ioctl: Add DRM ioctl abstraction")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260620011346.A47D01F000E9@smtp.kernel.org/
Suggested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Deborah Brouwer <deborah.brouwer@collabora.com>
Link: https://patch.msgid.link/20260628145406.2107056-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/drm/ioctl.rs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/kernel/drm/ioctl.rs b/rust/kernel/drm/ioctl.rs
index cf328101dde4..ccf4150d83b6 100644
--- a/rust/kernel/drm/ioctl.rs
+++ b/rust/kernel/drm/ioctl.rs
@@ -135,6 +135,12 @@ macro_rules! declare_drm_ioctls {
                             // dev/file match the current driver these ioctls are being declared
                             // for, and it's not clear how to enforce this within the type system.
                             let dev = $crate::drm::device::Device::from_raw(raw_dev);
+
+                            // Enforce that the handler accepts higher-ranked
+                            // lifetimes, preventing it from requiring 'static
+                            // references that could escape this scope.
+                            let _: for<'a> fn(&'a _, &'a mut _, &'a _) -> _ = $func;
+
                             // SAFETY: The ioctl argument has size `_IOC_SIZE(cmd)`, which we
                             // asserted above matches the size of this type, and all bit patterns of
                             // UAPI structs must be valid.
-- 
2.55.0



