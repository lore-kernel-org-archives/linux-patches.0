Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661C49460;
	Mon, 29 Dec 2025 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025472; cv=none; b=ivyRqfmwdKw9lhHYvyhIrMcWuFOp9qLzMVI6bW27/QNfu4ck2aBUlKv5yS6qu6kOiUnXVuU2+/hEJIl0ubNAkplNc+NnibRI1lpKS+uY+LErplFwgQ3x1PZb/k+cRMeR36sfZEfOmX7CVM2ubALYKUw047NJWciFCgC4l3F2hV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025472; c=relaxed/simple;
	bh=gek/geU/H/q0E02eOFaYxSmOVAkFhVQPj7Dgio9LRo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRcwVfnl+px8fcLAo/rfEHfZEjw7XTnLeiOnz4OJX75mL47pFWGN3B+9wr3lh/j4IpXsfuyxuKrrDefQx6aLqp1wzVHJan0l4Nz01TRpKxuni/PF9DO7BgzVF9nQfbc/bd7NMwIPd0cYc95hkBPOBurJ4eclpjw9BKrV31aOaoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvJeMYJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvJeMYJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF67C4CEF7;
	Mon, 29 Dec 2025 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025471;
	bh=gek/geU/H/q0E02eOFaYxSmOVAkFhVQPj7Dgio9LRo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvJeMYJeeJ/NjNW+7Qqg1XAMFVG6JRQjueY6s+NAYFMUqa2d7mOwVCYLXXkszDrtk
	 tQTVP5wW8j/dh2JTOgyBwAZUDFF8HrZt26cJxIO+e+e/fxnUjLOoOH1wClzqfzHVBH
	 BKqh7QS3iZkukWuu0rheeN6gq4zGjwtqfnkaCI7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 225/430] rust: io: move ResourceSize to top-level io module
Date: Mon, 29 Dec 2025 17:10:27 +0100
Message-ID: <20251229160732.631971685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit dfd67993044f507ba8fd6ee9956f923ba4b7e851 upstream.

Resource sizes are a general concept for dealing with physical
addresses, and not specific to the Resource type, which is just one way
to access physical addresses. Thus, move the typedef to the io module.

Still keep a re-export under resource. This avoids this commit from
being a flag-day, but I also think it's a useful re-export in general so
that you can import

	use kernel::io::resource::{Resource, ResourceSize};

instead of having to write

	use kernel::io::{
	    resource::Resource,
	    ResourceSize,
	};

in the specific cases where you need ResourceSize because you are using
the Resource type. Therefore I think it makes sense to keep this
re-export indefinitely and it is *not* intended as a temporary re-export
for migration purposes.

Cc: stable@vger.kernel.org # for v6.18 [1]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251112-resource-phys-typedefs-v2-2-538307384f82@google.com
Link: https://lore.kernel.org/all/20251112-resource-phys-typedefs-v2-0-538307384f82@google.com/ [1]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/io.rs          |    6 ++++++
 rust/kernel/io/resource.rs |    6 +-----
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -13,6 +13,12 @@ pub mod resource;
 
 pub use resource::Resource;
 
+/// Resource Size type.
+///
+/// This is a type alias to either `u32` or `u64` depending on the config option
+/// `CONFIG_PHYS_ADDR_T_64BIT`, and it can be a u64 even on 32-bit architectures.
+pub type ResourceSize = bindings::resource_size_t;
+
 /// Raw representation of an MMIO region.
 ///
 /// By itself, the existence of an instance of this structure does not provide any guarantees that
--- a/rust/kernel/io/resource.rs
+++ b/rust/kernel/io/resource.rs
@@ -12,11 +12,7 @@ use crate::prelude::*;
 use crate::str::{CStr, CString};
 use crate::types::Opaque;
 
-/// Resource Size type.
-///
-/// This is a type alias to either `u32` or `u64` depending on the config option
-/// `CONFIG_PHYS_ADDR_T_64BIT`, and it can be a u64 even on 32-bit architectures.
-pub type ResourceSize = bindings::resource_size_t;
+pub use super::ResourceSize;
 
 /// A region allocated from a parent [`Resource`].
 ///


