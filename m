Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E02206AF;
	Mon, 18 Aug 2025 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525229; cv=none; b=VV2fQ+ttCSnVRkZrTqzQ7SDjaPEbZV47oJfBblRFguGstWvQhdnaZvuo+x339NNHtuYBt9AiGLLExtCUDps3G7cJozdzkkXFn+uClCV17GlZBHfSNnKnj6OL2tonBch1qeSuYdrbnZxtCHMY9kJmW2l0TKgcfbdNqOwMrIqX3LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525229; c=relaxed/simple;
	bh=GELfpOkwtTFHAurtlWlv6vlzHN3dDpuYPBSTDtJviDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8764gfzf0JJvT5UizfXvSY56+u6DfDlrvtDi2/R3k/2ok8KJBB1wl2psUgt8AOwihbMQ554sMKWwLCbFJJpBRm8xFlORaSyel6PO/yU1+SDLbnJ7UuYkd7sySgeOFjj+p9nnQJm4zMeraFQB0d2U6gRPm1gKi7R14HP5soxw/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2wzOKb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2wzOKb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2618CC4CEEB;
	Mon, 18 Aug 2025 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525228;
	bh=GELfpOkwtTFHAurtlWlv6vlzHN3dDpuYPBSTDtJviDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2wzOKb9vhaJVfKv5EzDVLmnV7GjpVzIoQ7edrMLfby8k+rqBOXf4NcCfuyJIGNHx
	 Z+3gQT0dJcS6wPMnV9eu9UhKVL3hAwznbGSZe6rQQHrvvWDkr0rOEHJD/2LJukvQzK
	 G4s9f94jj2LGSygWT7LglcaRBIcJ9m9NWoowBMws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 197/570] platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches
Date: Mon, 18 Aug 2025 14:43:04 +0200
Message-ID: <20250818124513.387620087@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6418a8504187dc7f5b6f9d0649c03e362cb0664b ]

When KCOV is enabled all functions get instrumented, unless the
__no_sanitize_coverage attribute is used. To prepare for
__no_sanitize_coverage being applied to __init functions[1], we have
to handle differences in how GCC's inline optimizations get resolved.
For thinkpad_acpi routines, this means forcing two functions to be
inline with __always_inline.

Link: https://lore.kernel.org/lkml/20250523043935.2009972-11-kees@kernel.org/ [1]
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250529181831.work.439-kees@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index b59b4d90b0c7..afb83b3f4826 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -559,12 +559,12 @@ static unsigned long __init tpacpi_check_quirks(
 	return 0;
 }
 
-static inline bool __pure __init tpacpi_is_lenovo(void)
+static __always_inline bool __pure __init tpacpi_is_lenovo(void)
 {
 	return thinkpad_id.vendor == PCI_VENDOR_ID_LENOVO;
 }
 
-static inline bool __pure __init tpacpi_is_ibm(void)
+static __always_inline bool __pure __init tpacpi_is_ibm(void)
 {
 	return thinkpad_id.vendor == PCI_VENDOR_ID_IBM;
 }
-- 
2.39.5



