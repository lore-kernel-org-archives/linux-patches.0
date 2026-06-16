Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCA143D4E8;
	Tue, 16 Jun 2026 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629704; cv=none; b=na5ucrxtYjf2VYS2rfFkE7jTFLuIuaCfg/8TK51d7LYvO5ZI0P8ausLBEwpD9Ru8djaY7gQacFUFuBHxMg4pBPtDqswUewYZEAz7E03nORSt7xVmPKLUXH4VOtA8nFavznonb/J+jrx8x52RB5sTWCg15iKXvoYJqd2kq76jdQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629704; c=relaxed/simple;
	bh=NmuUfcfvE5+fPFaHeuEO5cjvGQ3PTNJ/ZU/GrReRUgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPmcD/HOE5+3eeanmdO9gssnKPck+sO35DUikn0vLNqPl7WetUwiyX461B84eWvGKPHpJNPLgWVwvyyf9f4wdkfKL2Y8ancqzqIbumF7/30DILkXBAXNCKhAlMVXYQxR3KyTZScQHXqNlApOgkBYfINEWg885iQNdhSl2dr1Hcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1f0iFacj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1f0iFacj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEA11F000E9;
	Tue, 16 Jun 2026 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629703;
	bh=gQiwKkREEkwrlC+x8KwKJrAKOeT6Nb1lXehExpT82GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1f0iFacj9HZMjKoFV0e2Dx2nwnnCyGEFfhvz1VWSoi7WjWJYLlRPX6J1GpPND7hJ7
	 MUWTIb6l/BylkMpM5DT+zyMzmb3/TWYH3aq0Bo6IHGuUjtwAlLkCMCzj1Ca/ZaBU00
	 yU3xt7ywhj2GgFAUL/BDxxfocF7+IjG+bg3+aZyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 306/452] drm/amd/display: Reject gpio_bitshift >= 32 in bios_parser_get_gpio_pin_info()
Date: Tue, 16 Jun 2026 20:28:53 +0530
Message-ID: <20260616145133.581174825@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit 49c3da65961fe9857c831d47fa1989084e87514a upstream.

[Why & How]
gpio_bitshift is a uint8_t read directly from the VBIOS GPIO pin table.
If the value is >= 32, the expression "1 << gpio_bitshift" triggers
undefined behaviour in C (shift count exceeds type width). On x86 the
shift is silently masked to 5 bits, producing an incorrect GPIO mask
that may cause wrong MMIO register bits to be toggled.

Validate gpio_bitshift before use and return BP_RESULT_BADBIOSTABLE for
out-of-range values.

Fixes: ae79c310b1a6 ("drm/amd/display: Add DCE12 bios parser support")
Assisted-by: Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eadf438ab8d370b9d19acee9359918c85afeb80d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -697,8 +697,10 @@ static enum bp_result bios_parser_get_gp
 		info->offset_en = info->offset + 1;
 		info->offset_mask = info->offset - 1;
 
-		info->mask = (uint32_t) (1 <<
-			header->gpio_pin[i].gpio_bitshift);
+		if (header->gpio_pin[i].gpio_bitshift >= 32)
+			return BP_RESULT_BADBIOSTABLE;
+
+		info->mask = 1u << header->gpio_pin[i].gpio_bitshift;
 		info->mask_y = info->mask + 2;
 		info->mask_en = info->mask + 1;
 		info->mask_mask = info->mask - 1;


