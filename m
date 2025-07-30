Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593AF2980DB;
	Wed, 30 Jul 2025 13:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880862; cv=none; b=E0aU6kQIgmxZ20Q97k9Jssny3GuQMBvQzkjYKMkT2E6MTLk/YjD8EjsmeMwxbC+KUolXuZr6PVMd01xRar7jfxYuQPDrcnvCo0MfwVIDfqgrYo37kxfzaDAFGtPdYl3b5Gmyhxts/jmgoj+753rddSiqGfd28xY22oXtoqvWfW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880862; c=relaxed/simple;
	bh=MCKKk6h+3JEL6n0iy6Y6XeM4Z1b+uuvj/oVkrOFjj0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJxCJuLD/rtAn14+aKjdAwa3Ek2UyjumP7MtOHO2TL0DFbKw6OFfAw0fdFzliOq0vqL0KuMnfyUJXwx0/62nukr4X2WlT+5Fee4c2BpRrKoIll713BG2fGYUokd+3kNmSWKjELDw0lAf27hIqnDUh5sMSZKmEsG2xYPSQ9gsi7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nE40kn1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nE40kn1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F4EC4CEE7;
	Wed, 30 Jul 2025 13:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753880862;
	bh=MCKKk6h+3JEL6n0iy6Y6XeM4Z1b+uuvj/oVkrOFjj0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nE40kn1E8vb+JirYTULptewIKmCOOzLFKQ5jEk+yfgBr6ztVyn/NoeuR1ILlTa4Cr
	 fE5XI/0rzTwnq9mwzDiKbJAH6mjXRGSO517gT0Dg5+AfnE+ejH0gPzwpz7lD/RlM60
	 fuDYO46LUk/zUcdpgT2Ez8GYxOdB5mCuckXrVCVmJVQFRYAHNRMv+Et0CrLcc9orXl
	 L/q9YLIRSxKneEYQ34nJNOofcr6VTvDYcQ6XTbE56qXa/Yn63ShYu9FjTx2L0dAJFz
	 cBG34Jst6PN7joglvLDSr8oCB/ToSyE3THMRd2h8WB6SADGPSVwTPWnL9Ra5tyC9w1
	 NlqVL4zWIt+rQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH 3/3] rust: warn if `srctree/` links do not exist
Date: Wed, 30 Jul 2025 15:07:16 +0200
Message-ID: <20250730130716.3278285-4-ojeda@kernel.org>
In-Reply-To: <20250730130716.3278285-1-ojeda@kernel.org>
References: <20250730130716.3278285-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

`srctree/` links may point to nonexistent files, e.g. due to renames
that missed to update the files or simply because of typos.

Since they can be easily checked for validity, do so and print a warning
in the file does not exist.

This found the following cases already in-tree:

    warning: srctree/ link to include/linux/blk_mq.h does not exist
    warning: srctree/ link to include/linux/drm/drm_gem.h does not exist
    warning: srctree/ link to include/linux/drm/drm_drv.h does not exist
    warning: srctree/ link to include/linux/drm/drm_ioctl.h does not exist
    warning: srctree/ link to include/linux/drm/drm_file.h does not exist
    warning: srctree/ link to include/linux/drm/drm_device.h does not exist

Inspired-by: "Onur Özkan" <work@onurozkan.dev>
Link: https://lore.kernel.org/rust-for-linux/CANiq72=xCYA7z7_rxpzzKkkhJs6m7L_xEaLMuArVn3ZAcyeHdA@mail.gmail.com/
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/Makefile b/rust/Makefile
index 4e675d210dd8..a27503028216 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -93,6 +93,12 @@ quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
 # and then retouch the generated files.
 rustdoc: rustdoc-core rustdoc-macros rustdoc-compiler_builtins \
     rustdoc-kernel rustdoc-pin_init
+	$(Q)grep -Ehro '<a href="srctree/([^"]+)"' $(rustdoc_output) | \
+		cut -d'"' -f2 | cut -d/ -f2- | while read f; do \
+			if [ ! -e "$(srctree)/$$f" ]; then \
+				echo "warning: srctree/ link to $$f does not exist"; \
+			fi \
+		done
 	$(Q)cp $(srctree)/Documentation/images/logo.svg $(rustdoc_output)/static.files/
 	$(Q)cp $(srctree)/Documentation/images/COPYING-logo $(rustdoc_output)/static.files/
 	$(Q)find $(rustdoc_output) -name '*.html' -type f -print0 | xargs -0 sed -Ei \
-- 
2.50.1

