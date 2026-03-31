Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3CB423149;
	Tue, 31 Mar 2026 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975865; cv=none; b=h+HIpi0bSkdEn3PGIMTgPGwoPqPDQNECqCUrKx5okZEJhvA7r4eK24h9GhdGrtHdrCW206ArNy9JQpfRSaRwflPr0YmMTfQnk5PyWKEuzhfGoue9KvjzRoeYvlZ3+q0tkTTnIJdMkIFvaVUKujNbwAyra2RObJ44HfvUU3XhGxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975865; c=relaxed/simple;
	bh=/mAa/BH1POdqgrtz7lujM9KdhcD0CBQAxMoUsLFvp/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfxyO2gPn6/HiuBJab/NIFbOa3RazV6AoCAuQGw0wTB67EitFnPuO3BKPQT5r6tIBqjbJIEhFv6Pf6mI9OnoEajuEreen2zeXpNs9Gx9YhFbvO0HyI1oJt11dr8+OmMbBnjKhd/tqVHQgzmOqqoYgr0hW8YmossPKalBhSR4rsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COcWymzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COcWymzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E55C19423;
	Tue, 31 Mar 2026 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975865;
	bh=/mAa/BH1POdqgrtz7lujM9KdhcD0CBQAxMoUsLFvp/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COcWymzF6OP2NjpCmjwgvjEI/0gRweVzKJDqA58j+8cbjUnigHx9+YolpJ5OmzkOu
	 4kNxorU97y7h0CwAaZg4fXrJ7ROl2mdm29iAPmHGyjTW4IYpFfqnpQVX/QYfsfcIAR
	 fX5iJuSOCu53onNyggfKu4+2Vlm4cCbHvC4+dyqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/244] drm/i915/gmbus: fix spurious timeout on 512-byte burst reads
Date: Tue, 31 Mar 2026 18:21:07 +0200
Message-ID: <20260331161745.984001948@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 08441f10f4dc09fdeb64529953ac308abc79dd38 ]

When reading exactly 512 bytes with burst read enabled, the
extra_byte_added path breaks out of the inner do-while without
decrementing len. The outer while(len) then re-enters and gmbus_wait()
times out since all data has been delivered. Decrement len before the
break so the outer loop terminates correctly.

Fixes: d5dc0f43f268 ("drm/i915/gmbus: Enable burst read")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patch.msgid.link/20260316231920.135438-2-samasth.norway.ananda@oracle.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 4ab0f09ee73fc853d00466682635f67c531f909c)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_gmbus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_gmbus.c b/drivers/gpu/drm/i915/display/intel_gmbus.c
index 6470f75106bd4..88b37deb5c82a 100644
--- a/drivers/gpu/drm/i915/display/intel_gmbus.c
+++ b/drivers/gpu/drm/i915/display/intel_gmbus.c
@@ -460,8 +460,10 @@ gmbus_xfer_read_chunk(struct drm_i915_private *i915,
 
 		val = intel_de_read_fw(i915, GMBUS3(i915));
 		do {
-			if (extra_byte_added && len == 1)
+			if (extra_byte_added && len == 1) {
+				len--;
 				break;
+			}
 
 			*buf++ = val & 0xff;
 			val >>= 8;
-- 
2.53.0



