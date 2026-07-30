Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858B73B19B3;
	Thu, 30 Jul 2026 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428237; cv=none; b=O4DJGUlUksMGUg4iomBvD+aB46aIp4S/5sVxY5NkCLJDuij0AbHEd8RczwK/+NfP0WIwUz3i1jpw07ohtsWxn9ZLF1RmYdS6H22J0ohNZMWtOxrGEHMT5N0OYp/BR9+dRcd3kgEzjzeFwIUp5syZq5ftyt7MfmhfoRgnAZ4j2Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428237; c=relaxed/simple;
	bh=HwFcbxbfw91z4q+U7Q5na34k/AWibUcVMeCdlvjItv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sziN0tJ6TKGHoIUUXnWNrOhXegAZXTeeWVbglRqUnnT95ybbxErS8BjeN86U5xHviDOYbN2dtyWDWp5gJgeMZnHa3EiFlYtxwwyb6s2MG9o5LFIF7JzeboN3UUtE3DdtKgq61px2OULgYvAsZoES/ohGMDv0h1bxRfiCccj33Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oa6BC4Hz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa6BC4Hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C771F000E9;
	Thu, 30 Jul 2026 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428236;
	bh=i4QKrmvAWZF53lCEahPw+eFweihvlY7Ze+/O+OwPTbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oa6BC4Hz95aeztzzSrMZzkrUo0CHbHtjlBS8alDBjVFHgC21JauKllI5KOQcCamn8
	 oQ/1rkoG03/mVimaPml6xRWzq3XFN2cf7I7WxWSfJj3Bw3W+dM6nJjNGsZ/G098CJR
	 ip+Cs+NN9u/3uJSrXMd5RVWb9ZcUQuvYLyfOvmP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 450/484] firmware_loader: introduce __free() cleanup hanler
Date: Thu, 30 Jul 2026 16:15:47 +0200
Message-ID: <20260730141433.258587020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 8dde8fa0cc3edce73c050b9882d06c1a575f6402 ]

Define cleanup handler using facilities from linux/cleanup.h to simplify
error handling in code using firmware loader. This will allow writing code
like this:

int driver_update_firmware(...)
{
	const struct firmware *fw_entry __free(firmware) = NULL;
	int error;

	...
	error = request_firmware(&fw_entry, fw_name, dev);
	if (error) {
		dev_err(dev, "failed to request firmware %s: %d",
			fw_name, error);
		return error;
	}

	error = check_firmware_valid(fw_entry);
	if (error)
		return error;

	guard(mutex)(&instance->lock);

	error = use_firmware(instance, fw);
	if (error)
		return error;

	return 0;
}

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Luis Chamberalin <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/ZaeQw7VXhnirX4pQ@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d48795b5cd68 ("Input: ims-pcu - fix firmware leak in async update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/firmware.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/cleanup.h>
 #include <linux/gfp.h>
 
 #define FW_ACTION_NOUEVENT 0
@@ -196,4 +197,6 @@ static inline void firmware_upload_unreg
 
 int firmware_request_cache(struct device *device, const char *name);
 
+DEFINE_FREE(firmware, struct firmware *, release_firmware(_T))
+
 #endif


