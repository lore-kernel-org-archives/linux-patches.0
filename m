Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804B520F079;
	Tue,  6 Jan 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722515; cv=none; b=JKXyCud8yPQtd2QJ11H+ola3G/G6CP7q1+IU8PtS+RxD6PA/A71t15+/NYcNnTzb7iDfRaCI4wSwjZH90u5rs+W9J9l4UkkZ7wLSo+l05bclvnWr+TCBhM8QnIaFLTijNdmG33Ur4SOvKuk6Vpa6C2+1YpkiZ9wB1Km3NcyURgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722515; c=relaxed/simple;
	bh=2aE6APSDYNpn9J2ORfJFCuIcffDnOg4UNNw31sndFB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzQ2usqbmkKkx1TX68yIagMkb2Rch0sCr4hKbSQ3v9Ka4dTClLImrlXethII2kJ2jPla4iAYINBwCV6f87ykQd9mVQHvMrXRt81XnOrVeEiJKF5Wv8lqDw6GBikjNS6CXIzTr5q6czP4umuSVjzp7X49PeIY3lE8QeAYYMBYfz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwDmh0a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwDmh0a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57CEC116C6;
	Tue,  6 Jan 2026 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722515;
	bh=2aE6APSDYNpn9J2ORfJFCuIcffDnOg4UNNw31sndFB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwDmh0a/tdL/roVTubiHHoM54QyQ+p1Mv7/tl8znxWjIAMZ715i+u3hroFRgO94Dj
	 1gwWIC/9Cg7qagt5+sY1s04HdZHISVcNamv3adZ4gi7p+23xTtJK6jEWxXfMdv2z2E
	 9z8cQwjgfwvDeh0ettdtAecp/Pm7vGiaByrwL8q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.18 287/312] drm/i915: Fix format string truncation warning
Date: Tue,  6 Jan 2026 18:06:01 +0100
Message-ID: <20260106170558.236601864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


