Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38622D73B9;
	Tue,  6 Jan 2026 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721222; cv=none; b=pt+CTzvDAHgnCZEoKA56vhkHV3N5D+F03djpLxjpRfRXMQV0un0K4/3Tp3mwICAYys/DHJkwJCr/7oejhu8ZubRbZxNmf8EDnUgTgpQkys2D6RFvZBM4kJQxqGFHkZpDTAaEZjbWtJ0ymnROnltADXQ02VzoVBy95nNMRkTLwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721222; c=relaxed/simple;
	bh=cVxB0Tfbjr7fd6wjyG0V2TkwmD5ZMYluyRb0B4olA7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J64REHXV/84lJnb0Z/DMgCIY5cxIHLkY313qxK9AbWYwtCMxrh+KstNhBhSbn63i3Gry15Tuqxkbnd2M1MF4ETG4u+MNnSsJEoOGJRExRJL3PJMb3fhy2wB3OHaZoAUJdC3VQ8kaav5w6hORBPskQCVbqqGgGdTl0ca3nOTqe4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VCQolxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VCQolxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D695C116C6;
	Tue,  6 Jan 2026 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721222;
	bh=cVxB0Tfbjr7fd6wjyG0V2TkwmD5ZMYluyRb0B4olA7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VCQolxRPj+TQ4Gv7wB6bRIXncUDRQEdle6oy0t+8Yu2eqgcwvyU3yeA4m0yAqeG3
	 84zxpK+HsyoQgPXkDZrYmsuUra7JHUyYL7LK+B5EulCFLALKIYllDUXZzl/1VUpftL
	 AX6dbGMzzFBIkv2DYEsUzKXjx1+rICRVsE9kDqjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 473/567] drm/i915: Fix format string truncation warning
Date: Tue,  6 Jan 2026 18:04:15 +0100
Message-ID: <20260106170508.849974633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 1c7f9e528f8f488b060b786bfb90b40540854db3 upstream.

GCC notices that the 16-byte uabi_name field could theoretically be too
small for the formatted string if the instance number exceeds 100.

So grow the field to 20 bytes.

drivers/gpu/drm/i915/intel_memory_region.c: In function ‘intel_memory_region_create’:
drivers/gpu/drm/i915/intel_memory_region.c:273:61: error: ‘%u’ directive output may be truncated writing between 1 and 5 bytes into a region of size between 3 and 11 [-Werror=format-truncation=]
  273 |         snprintf(mem->uabi_name, sizeof(mem->uabi_name), "%s%u",
      |                                                             ^~
drivers/gpu/drm/i915/intel_memory_region.c:273:58: note: directive argument in the range [0, 65535]
  273 |         snprintf(mem->uabi_name, sizeof(mem->uabi_name), "%s%u",
      |                                                          ^~~~~~
drivers/gpu/drm/i915/intel_memory_region.c:273:9: note: ‘snprintf’ output between 7 and 19 bytes into a destination of size 16
  273 |         snprintf(mem->uabi_name, sizeof(mem->uabi_name), "%s%u",
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  274 |                  intel_memory_type_str(type), instance);
      |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 3b38d3515753 ("drm/i915: Add stable memory region names")
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20251205113500.684286-2-ardb@kernel.org
(cherry picked from commit 18476087f1a18dc279d200d934ad94fba1fb51d5)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_memory_region.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_memory_region.h
+++ b/drivers/gpu/drm/i915/intel_memory_region.h
@@ -72,7 +72,7 @@ struct intel_memory_region {
 	u16 instance;
 	enum intel_region_id id;
 	char name[16];
-	char uabi_name[16];
+	char uabi_name[20];
 	bool private; /* not for userspace */
 
 	struct {


