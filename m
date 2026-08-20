Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C5947D463;
	Thu, 20 Aug 2026 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243566; cv=none; b=nNQkCs6xM5Bbcu7fTX2RCBL144BqN/7oPEceMj7kKhzsuRN7R35M9IWQT3ho9GI3ChO8li002pqm2qA5qDfLBfnvglFx4B+MCh6dV2CRB3uBTRdTOYw5RPnsqRe/dDKEkOeEHM2yCxWQv4hJbjkOf0UCf/lzaJ5964TW5Y5ekOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243566; c=relaxed/simple;
	bh=TnH7lZm28fubUXCi8F2XskYXjw+B03XFcmVpnL1WIFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8HmIiwUxled0jVK0D8yG3Y3ofkhqI9CZPDOx0eSURaoiA1FVcwSKFHj8E8pEtjgCVaHXdav6DP2LFoLwQRAa7NbGbFKJYGcl/IGW56YXsGHjfSS8LbLh4/w6Qh25t6Y04E4FYQJSAmAhxKUXZ5131YGkF0ciHjxUNhDq362aKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp34VG0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp34VG0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4251F000E9;
	Thu, 20 Aug 2026 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243564;
	bh=A3g8voQtRo2fPOcc6TBE51dbS1ZLa7XFsqBAKxcCp/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wp34VG0Ykxm3I3CyVCspAIpB0WBjM17uOyUTFSD5Oa2/jg7NsZ64BUWonhdWMn66E
	 T1W75PGAgDKp+jKMNYL91mM1dd8O7+QSfW8gA3N6kv/1K+SY+jeLHARamC4GK03XB4
	 o3N4lqpGdSw1ulMM1IhaySjSop/RxQVZZzyEKgLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/272] firmware_loader: introduce __free() cleanup hanler
Date: Thu, 20 Aug 2026 16:55:22 +0200
Message-ID: <20260820145235.423743500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -118,4 +119,6 @@ static inline int request_partial_firmwa
 
 int firmware_request_cache(struct device *device, const char *name);
 
+DEFINE_FREE(firmware, struct firmware *, release_firmware(_T))
+
 #endif


