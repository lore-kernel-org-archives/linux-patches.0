Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313F53FD2B;
	Wed,  9 Sep 2026 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962648; cv=none; b=a2CiHIOfvhZzyB+hZYTabo3AaYjhIOpbrXVUpMu0f2PUiI7KRGMWh/LsUG9IXw982zC6QQX9PwU8hhlz8C2nuFG4RHLkrud//5Iczb058gG5HbrZtuKvMaN0WYdeozeNwJFprk5teOQi7awgTL1Z1gcewPe5Ll6kgg+eJDig658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962648; c=relaxed/simple;
	bh=8tez//u+6hPWK6iN6NG1EYgw45y9MGKVFmP8KNICcCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sj1/pCSukcrB5ZivH5pemWjgX3JAf88WI0dSBbaLwgOPRYau/o9U6zwyI0asZRxZfTSD3FRpx7s4mCtJfRCBYcWix2o4/ZnpJdv97VN2M/9AsxlUfRClp6J+qJgIm289GL20zSTEPXe4qxi0CYg48s0gG4NT2asIeTNh9bNDJVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD4JO2nY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD4JO2nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F2A1F00A3A;
	Wed,  9 Sep 2026 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962645;
	bh=v/h8vesfjD6qiec8kpp90X0wL8hsElqvuwjSMDO3LUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CD4JO2nYLRUbOGlxo5OBCHZxHIza+ls1+oxyl2rrlQeg8eULvkVwQq5zjzzTJ9cYq
	 lUe21MMHcJfQZUO6KndkSf69nTb7dLZHuqw2ZaXM+NuUYTjK5d9ofXW8Wblst5eRTL
	 xKCrb5N+6U1pTNXEdAn8BCWNv8Lfv7PluBZYaJ7c=
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
Subject: [PATCH 7.2 345/556] rust: drm: ioctl: fix unbounded lifetimes in ioctl handler arguments
Date: Wed,  9 Sep 2026 15:40:25 +0200
Message-ID: <20260909134242.791175154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 rust/kernel/drm/ioctl.rs |    6 ++++++
 1 file changed, 6 insertions(+)

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


