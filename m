Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D266012D77B;
	Tue, 14 May 2024 11:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686673; cv=none; b=uvQOjBTeCDmwFFO4voYMSsiRd2/cXyLAJMuBcYfgi8QSmfL6xolzivFzosobNuhg76xbpBQYdgIKgmuWulc0DcWaA2K2jdIzimLLGz/ZIQWCIssbiLOXulhiPG/Yg8gWklSgbE3czE2msToUVTY0EcF+LmgJniwubphYTKQBRA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686673; c=relaxed/simple;
	bh=vgXNNRn6TjBF3RBRjcM/r4A2poW8MMM3y5YJBi+cf3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLYcbNS2L0MnL06MN7h1zyJ1idCn8QKBAFfujN40FXmsz3E2uknDTvc7v87PeUkZEGTcNWHxlobm15lBcqWn3bCSLkAl/QKGs4gAh8C5MJdcxO+pHhL4IKKnMu4sW3Y7C94/L7XDvWirg0QE1KofFg9pMV4AndW2iaMHe6IGK7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9yb9+jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9yb9+jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5717CC2BD10;
	Tue, 14 May 2024 11:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686673;
	bh=vgXNNRn6TjBF3RBRjcM/r4A2poW8MMM3y5YJBi+cf3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9yb9+joYoqFxukTzL/964ACib9F5AyVSJIRvzrrXP3BOQz2Z6KCh5oqArfRicufj
	 C56wPHcC3aJs3J+n1TY2zc6xapQuNku7tx20HtKPtMz8OiqiMUIYS64S4XiTSzL0Kg
	 tGupQPPjidcCOi3vm9aURtRt/Dyzrt3gJh3UnZR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <andrea.righi@canonical.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Eric Curtin <ecurtin@redhat.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 188/236] rust: fix regexp in scripts/is_rust_module.sh
Date: Tue, 14 May 2024 12:19:10 +0200
Message-ID: <20240514101027.500196258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <andrea.righi@canonical.com>

commit ccc4505454db10402d5284f22d8b7db62e636fc5 upstream.

nm can use "R" or "r" to show read-only data sections, but
scripts/is_rust_module.sh can only recognize "r", so with some versions
of binutils it can fail to detect if a module is a Rust module or not.

Right now we're using this script only to determine if we need to skip
BTF generation (that is disabled globally if CONFIG_RUST is enabled),
but it's still nice to fix this script to do the proper job.

Moreover, with this patch applied I can also relax the constraint of
"RUST depends on !DEBUG_INFO_BTF" and build a kernel with Rust and BTF
enabled at the same time (of course BTF generation is still skipped for
Rust modules).

[ Miguel: The actual reason is likely to be a change on the Rust
  compiler between 1.61.0 and 1.62.0:

    echo '#[used] static S: () = ();' |
        rustup run 1.61.0 rustc --emit=obj --crate-type=lib - &&
        nm rust_out.o

    echo '#[used] static S: () = ();' |
        rustup run 1.62.0 rustc --emit=obj --crate-type=lib - &&
        nm rust_out.o

  Gives:

    0000000000000000 r _ZN8rust_out1S17h48027ce0da975467E
    0000000000000000 R _ZN8rust_out1S17h58e1f3d9c0e97cefE

  See https://godbolt.org/z/KE6jneoo4. ]

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/is_rust_module.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/is_rust_module.sh
+++ b/scripts/is_rust_module.sh
@@ -13,4 +13,4 @@ set -e
 #
 # In the future, checking for the `.comment` section may be another
 # option, see https://github.com/rust-lang/rust/pull/97550.
-${NM} "$*" | grep -qE '^[0-9a-fA-F]+ r _R[^[:space:]]+16___IS_RUST_MODULE[^[:space:]]*$'
+${NM} "$*" | grep -qE '^[0-9a-fA-F]+ [Rr] _R[^[:space:]]+16___IS_RUST_MODULE[^[:space:]]*$'


