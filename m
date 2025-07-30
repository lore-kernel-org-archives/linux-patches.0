Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146BE26F461;
	Wed, 30 Jul 2025 09:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868870; cv=none; b=dalElOBv6rYvpY6vlwb3iaT34+1RjM1t8Ui66dtXr4wh2BZdGQlTQjKceBAt/iyNsghMBp6UJ3oOnDx3cKae9bH+/WKJhCtm6TZofdXz2DB/eOaGMQaihYPouOU0Ey+beif1BhkZcI5XZ0DGXTfdySE/ALDmKX6cF0sJopxEgBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868870; c=relaxed/simple;
	bh=L2INTWHWVx4kDjNnG8OISlUL9lphUlD6iKcCx0bACKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB1Ua/YvoJfAk2u9nj/1taRJ794DD7u5959OmPY2pda8pWP6AnA/6oI3UHaz5SwMczDUoTihePh3NPsP7pDWjZKmHQcUGHbCmtMZO7VtgoxtWzyPHFMYDabGWIp5EFF/6Esuafjf8xSGJ3XvvGjvl8Y4TkUKqMqec2KdA6Th6Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6i1sbNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6i1sbNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783CFC4CEF8;
	Wed, 30 Jul 2025 09:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868870;
	bh=L2INTWHWVx4kDjNnG8OISlUL9lphUlD6iKcCx0bACKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6i1sbNccb9ALJY+MHbR8iBVhB00O1xw3E630q5JSr71NSTJUzdyHEOtNfghDl80n
	 yqmWTKtgqCEvVIIMVxfyKX4Y/bY5bG12E4jvs/vZE2QkF3PqUjg02EdCX6l6sb9iWE
	 twjHLxUSIFV1R6tc0lnT6pu5AOY4xf/Hz7QsBSRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 067/117] rust: give Clippy the minimum supported Rust version
Date: Wed, 30 Jul 2025 11:35:36 +0200
Message-ID: <20250730093236.146468205@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit f0915acd1fc6060a35e3f18673072671583ff0be upstream.

Clippy's lints may avoid emitting a suggestion to use a language or
library feature that is not supported by the minimum supported version,
if given by the `msrv` field in the configuration file.

For instance, Clippy should not suggest using `let ... else` in a lint
if the MSRV did not implement that syntax.

If the MSRV is not provided, Clippy will assume all features are available.

Thus enable it with the minimum Rust version the kernel supports.

Note that there is currently a small disadvantage in doing so: since
we still use unstable features that nevertheless work in the range
of versions we support (e.g. `#[expect(...)]`), we lose suggestions
for those. However, over time we will stop using unstable features
(especially language and library ones) as it is our goal, thus, in the
end, we will want to have the `msrv` set.

Rust is also considering adding a similar feature in `rustc` too, which
we should probably enable if it becomes available [2].

Link: https://github.com/rust-lang/rust-clippy/blob/8298da72e7b81fa30c515631b40fc4c0845948cb/clippy_utils/src/msrvs.rs#L20 [1]
Link: https://github.com/rust-lang/compiler-team/issues/772 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20241123222345.346976-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .clippy.toml |    2 ++
 1 file changed, 2 insertions(+)

--- a/.clippy.toml
+++ b/.clippy.toml
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+msrv = "1.78.0"
+
 check-private-items = true
 
 disallowed-macros = [


