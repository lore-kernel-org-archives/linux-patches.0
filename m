Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C278246781;
	Thu, 20 Aug 2026 16:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244295; cv=none; b=gb1TlGUAHUzv2js/05dK5UdlDK7n0WpO4YY7aNDyNbdseOVqB+exIl4ApSBKF/3QIKRP1ZYrg/u/dH5/Wq56Xb9PskIYXuzy/221ku8BIbywIloTBjmGO/YX4Lbs2VfRlxKugBqfLVUjXVdKGz/Wrpl+ugShyDZyM01Sbc0jOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244295; c=relaxed/simple;
	bh=093twQ+Rr0O7B0Bq5xwEkfTOwa0Ql0WRKwPWYizeAsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUhxhOXaGSjgnAdCIfRAvoPNOtKBMcHfXRFACsbqf/E2PCpAK8F7FhE8nwmzAzDHCuWF5gg4CKWerH5WrrAonP6w9ep+2WDPMk2G9ZP+Guggz8bqzPp3KU34n4PD/POw3vWdcLNl5UEKGtb7zkPtBv+kZMHud6JgKYV/br1JKRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18OlNSDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18OlNSDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7451F000E9;
	Thu, 20 Aug 2026 16:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244294;
	bh=AVf24GgYkR7zYxzqMRhug3f/LOcsLMAKuRL3YvUbSfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18OlNSDxne1IBRzX5IjfMxJqp++5UeH48NNvCMIxkFMNRUO+cp1GsgElqkAi29At+
	 8R3FtAEsBLxzVv9DNr1h9dmyR+LCfl5YpMTuwThGZiWIgI0+4ljY3DLF3xwS0Di5hx
	 djY8D0asotTXY4+46PBByS+tQNi9t2017lvALM24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/235] firmware_loader: introduce __free() cleanup hanler
Date: Thu, 20 Aug 2026 16:55:55 +0200
Message-ID: <20260820145220.056282909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 
 #define FW_ACTION_NOHOTPLUG 0
@@ -118,4 +119,6 @@ static inline int request_partial_firmwa
 
 int firmware_request_cache(struct device *device, const char *name);
 
+DEFINE_FREE(firmware, struct firmware *, release_firmware(_T))
+
 #endif


