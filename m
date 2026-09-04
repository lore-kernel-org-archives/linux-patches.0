Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F90F3876B3;
	Fri,  4 Sep 2026 05:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498440; cv=none; b=Hq2xrgK+tgZRfW15ZVdQw99OqXYVLJZBG94RdC+Tr+0EGTkfxQxGG4HQObTuMEcagw2Kpc2GFA/Jp/6auNbWONb8IzJpoN24WwuHYUuxn43doU4M8dJfVj+hS7x+flNOJa/lOs5W09fEfuMOnKmzaz+vMfBPCN9CjDMWUHSvwBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498440; c=relaxed/simple;
	bh=QEgtE4Si16yTRphE2tpeGTQkBBQlci3QawcQgXUxrOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWW86L5dVk0WvBFoPR/wBLfKOQVmqVoaZ5S3xtCmJbt8VO3tUADAiNBIdeX25rJiBM9H/Uh1k+pYR1WTXeUDrnhLOer8q59d7BAsSFsb3iOQBolNU5kWeTQZkgbosBOuBHsh6yIQA98ifDLy5AzgqAvF4xlSr72hMxjOVw99Qu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLrYiZK0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLrYiZK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8786C1F00A3D;
	Fri,  4 Sep 2026 05:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498439;
	bh=fhGMF850g8jydgyjX/R0Tp83QUYhvTqku2i23QWrgjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLrYiZK0VndaUtVlSJcqQyMZIuO0p9S0JGYphHm5omCM7dFoM8vMYKTvROo2TkXv+
	 srS0YxAXIOQrOIdGaLpbfAho0ClFUZkT9ystg67c8P0VSnY4xZOCzlKqf6ibxFlW/C
	 g91qH/N/uXZ1u9XAUboJK7brW1Q5Rl6CEc/JJ56g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 036/713] objtool/rust: add one more `noreturn` Rust function
Date: Fri,  4 Sep 2026 06:50:04 +0200
Message-ID: <20260904045804.639613701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit 993f235c4af49d0e912cc28abe6d733531600237 upstream.

When the pointer formatting series [1] is applied and KUnit tests
are enabled, `objtool` would report an error with any of our
supported Rust versions. For instance, with Rust 1.97.1:

    rust/kernel.o: error: objtool: _R..._4core3fmt7Pointer3fmtB7_()
    falls through to next function _R..._4core7convert5AsRefNtB5_4BStrE6as_ref()

Or, with Rust 1.85.0:

    rust/kernel.o: error: objtool: _R..._4core3fmt7Pointer3fmtB7_()
    falls through to next function _R..._4core3ffi5c_str4CStrENtNtBS_3fmt7Display3fmtB7_()

This happens due to calls to the `noreturn` symbol:

    core::str::slice_error_fail

Thus add the mangled one to the list so that `objtool` knows it is
actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

[ While the series [1] mentioned above was not applied in a way
  that triggered this, Gary found another case [2]:

    I am seeing this function causing issue on my 1.85.1 -Os build, although the
    error message is different this time:

        rust/kernel.o: warning: objtool: _R..._5range9RangeFromjEE5indexCsldbe0TGTmNx_6kernel+0x1d:
        stack state mismatch: cfa1=4+8 cfa2=4+16

    Disassembly shows that the function call before the warning location
    is a call to _4core3str16slice_error_fail, and objtool thought it can
    return (which will end up with a unbalanced stack if it does return).

  Thus apply it. - Miguel ]

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Reported-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/rust-for-linux/anLxXvCKBcAVf91_@google.com/
Link: https://lore.kernel.org/rust-for-linux/20260706-hashedptr-v13-0-377a07f2f78d@kylinos.cn/ [1]
Link: https://lore.kernel.org/rust-for-linux/DKS7U9UHY6XR.2JC0EBIPCI06Z@garyguo.net/ [2]
Link: https://patch.msgid.link/20260805144524.233362-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -195,6 +195,7 @@ static bool is_rust_noreturn(const struc
 	return str_ends_with(func->name, "_4core3num20from_str_radix_panic")				||
 	       str_ends_with(func->name, "_4core3num22from_ascii_radix_panic")				||
 	       str_ends_with(func->name, "_4core3num28from_ascii_bytes_radix_panic")			||
+	       str_ends_with(func->name, "_4core3str16slice_error_fail")				||
 	       str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
 	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||


