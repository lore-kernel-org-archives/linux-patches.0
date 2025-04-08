Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A831935973;
	Tue,  8 Apr 2025 11:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112061; cv=none; b=KAhdhuYQb2Oj9moigLdlDF8MpI/Rascb7vcx9+HXAnxYV956ANkj5UvfJHkCQVoV0nOtHZl/9w8TU4TVxj4W+/cv4WKIZWVk/0Mqc/1sWPURl+N5We4dJltohWlgeaJNWarCETzr9zHGf98Nn/4hP0C87ZRlU+opnO/s01zZlZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112061; c=relaxed/simple;
	bh=mKLK74pZxLN8qKhgCGqDjZY2aXAlcNuDhOV3orHXlnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWANwF4GQiDgNmdjJIGsFH9SxXoQdI+VsREUXX4ADQ/aKXpbN0qj2G9YUUGXPtOvk5szaW+gPZ5ZU9kbpfh6lK/xuqGgmYn3fFqhhUG4PNwFhTjrBnwsrFcJbKFGvf0kSmi9MkRB2De+Mve6byogx5XUeg9Rtzh3StdhJcnTsd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGTujW6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGTujW6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EBEC4CEE5;
	Tue,  8 Apr 2025 11:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112061;
	bh=mKLK74pZxLN8qKhgCGqDjZY2aXAlcNuDhOV3orHXlnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGTujW6oPWq5xWVCkB1pBAODpLmNAvlQ3dv4RGBWDgvHbT7E6pqfyfK+FoFXaqS2D
	 VfS/xLVGX1ay5RN6JwJe/mgdSsiv76+U9rIOTx8nKijfKzQ9HCXnpGI0w0g4YRLAuj
	 2jrvTnPOgLdXVsjHkb3nhIRM9w/FT5jDYNCNtq2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <benno.lossin@proton.me>
Subject: [PATCH 6.14 661/731] rust: platform: require Send for Driver trait implementers
Date: Tue,  8 Apr 2025 12:49:18 +0200
Message-ID: <20250408104929.642107758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 51d0de7596a458096756c895cfed6bc4a7ecac10 upstream.

The instance of Self, returned and created by Driver::probe() is
dropped in the bus' remove() callback.

Request implementers of the Driver trait to implement Send, since the
remove() callback is not guaranteed to run from the same thread as
probe().

Fixes: 683a63befc73 ("rust: platform: add basic platform device / driver abstractions")
Cc: stable <stable@kernel.org>
Reported-by: Alice Ryhl <aliceryhl@google.com>
Closes: https://lore.kernel.org/lkml/Z9rDxOJ2V2bPjj5i@google.com/
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Link: https://lore.kernel.org/r/20250319145350.69543-2-dakr@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/platform.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/platform.rs
+++ b/rust/kernel/platform.rs
@@ -149,7 +149,7 @@ macro_rules! module_platform_driver {
 ///     }
 /// }
 ///```
-pub trait Driver {
+pub trait Driver: Send {
     /// The type holding driver private data about each device id supported by the driver.
     ///
     /// TODO: Use associated_type_defaults once stabilized:


