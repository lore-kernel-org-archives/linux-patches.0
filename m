Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962C92E738B;
	Mon, 17 Aug 2026 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974355; cv=none; b=Zt78JEkh704+66X12cVcEHts5szpEPs1x/VDwpc4zT4rcY1sXD8+4tTTO4aCaQVWvynYe+ATimHuZUI9ObEOAoAqf0r19espEYtlidEw5VkUTJ6CJ1dhOv/HDSaVmp/h02h57DyhkSwHU+8djclFxnbUBRsuMU2PnEPHLNWG0b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974355; c=relaxed/simple;
	bh=fxeJ4nmuJ1ZysTLvJiBkELhNVCuHU3EsbnonxZAECEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVWVfZo3044w92f9aS3ASMEjOnV/pw1ZROjAfwZuASgAzb3yipc8bgha4bUXDEZBWsru0/Aszh30arkltTXfFN/o3eShT66PFzVRJsL84zIPV66HdUxQHT7Fmnmu2wTme7uqm3a5DrOxaDDmfZcqBDbleWcdXSwMclck0tp47ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HU/VQHHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HU/VQHHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268501F00A3A;
	Mon, 17 Aug 2026 13:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974349;
	bh=811hOmpINpLYblg4sKXPDQaRZvWniClcnDO1dKJaS+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HU/VQHHWs31bmbSN74K9ZagXeuiczLKN2sQQRnyeacyD15UEoBsKDfEJh+ipTzW2V
	 DxyERfWX2te2UOXWiERi67xnHeNz4x1ZdGAUIBhTsfL1BCkdEnNkF0IYgjvaH/oKLc
	 lx9qQNf6fHPytMLQv05Cv5yqwsOOyovDSh3E/DzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	stable <stable@kernel.org>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 7.1 176/271] rust_binder: do not query current thread for all ioctls
Date: Mon, 17 Aug 2026 15:31:41 +0200
Message-ID: <20260817132544.090959866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit dd7aea9ee2091cfae3a5e376af87aa106d7735cd upstream.

The get_current_thread() method is currently called for every ioctl to
ensure that a Thread struct exists for the thread calling into the
driver. However, not all ioctls require a Thread object, so this means
we are unnecessarily creating these objects in cases where we don't need
to. If said thread does not invoke BINDER_THREAD_EXIT on exit, Binder's
Thread struct stays around until the fd is closed. For long-lived
processes the Thread object is effectively leaked.

Furthermore, when the BINDER_GET_NODE_DEBUG_INFO ioctl is invoked by
libmemunreachable to ensure that objects reachable only through the
Binder driver are not considered leaked, this is done from a fork of the
process owning the fd, which means that it fails the group_leader check
inside get_current_thread(). This results in EINVAL errors for this
ioctl, causing libmemunreachable to report a false positive memory leak.

Thus, do not invoke get_current_thread() for ioctls that do not require
it.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260727-binder-cur-thread-v1-1-8edf2b64e235@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/process.rs |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -1586,6 +1586,10 @@ impl Process {
         cmd: u32,
         reader: &mut UserSliceReader,
     ) -> Result {
+        if cmd == uapi::BINDER_FREEZE {
+            return ioctl_freeze(reader);
+        }
+
         let thread = this.get_current_thread()?;
         match cmd {
             uapi::BINDER_SET_MAX_THREADS => this.set_max_threads(reader.read()?),
@@ -1597,7 +1601,6 @@ impl Process {
             uapi::BINDER_ENABLE_ONEWAY_SPAM_DETECTION => {
                 this.set_oneway_spam_detection_enabled(reader.read()?)
             }
-            uapi::BINDER_FREEZE => ioctl_freeze(reader)?,
             _ => return Err(EINVAL),
         }
         Ok(())
@@ -1612,15 +1615,16 @@ impl Process {
         cmd: u32,
         data: UserSlice,
     ) -> Result {
-        let thread = this.get_current_thread()?;
         let blocking = (file.flags() & file::flags::O_NONBLOCK) == 0;
         match cmd {
-            uapi::BINDER_WRITE_READ => thread.write_read(data, blocking)?,
+            uapi::BINDER_WRITE_READ => this.get_current_thread()?.write_read(data, blocking)?,
             uapi::BINDER_GET_NODE_DEBUG_INFO => this.get_node_debug_info(data)?,
             uapi::BINDER_GET_NODE_INFO_FOR_REF => this.get_node_info_from_ref(data)?,
             uapi::BINDER_VERSION => this.version(data)?,
             uapi::BINDER_GET_FROZEN_INFO => get_frozen_status(data)?,
-            uapi::BINDER_GET_EXTENDED_ERROR => thread.get_extended_error(data)?,
+            uapi::BINDER_GET_EXTENDED_ERROR => {
+                this.get_current_thread()?.get_extended_error(data)?
+            }
             _ => return Err(EINVAL),
         }
         Ok(())


