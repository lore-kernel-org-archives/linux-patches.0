Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C442327C1D;
	Mon, 13 Apr 2026 16:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099375; cv=none; b=bt+6+2ph0qpHDjULTWSpONJDVqQKkXNxwenAo1ihSj6BdVirUCpbf8NcOu6nmeG+5Ac9SLo7cbB9tJeHpgZi9z0HCdzL2C03eRTN/frtsW6vyT7ZeRqYElvo4SH966/BuJ0p92CjjNnrQmV5RvqMMXlkmAuENX+Osa/qFvHOZto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099375; c=relaxed/simple;
	bh=D8RuW6rtjzqALZRRoni9AOh/Pt76dDHNqn/IHQsiMsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtKv5z7x5Q+g21F4g/ViMjizpnTeaATeGMbp76/2hnP1HjiAFBd+UtjraBmYNw9iKZQyC+jwXGK37u8eZ7//JbSIHin8gGvwrZ3L+ZvZUzR/NoeW7YRrPUdVVBMDKYa+DmmxI+RuRQCh1gzk4oDNyAYcYZ5yd9qYH5lomLybVTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbbDb3z7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbbDb3z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAB1C2BCAF;
	Mon, 13 Apr 2026 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099375;
	bh=D8RuW6rtjzqALZRRoni9AOh/Pt76dDHNqn/IHQsiMsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbbDb3z7iIE2Lt7vzWEJXybM8DtSngJzZgpGzsLdhrdR98ZBrvfyZ/hRiriXTyKA5
	 dPhfY/E/7L6AB4OQF0ZDIlIgrdS1VdK5KnawrTGmzs6qJv6W3eTdIuFl3PJYYII5DN
	 /7z4HyoJUlfvxoh9xn0riF1ldAUXw3ELmC38xfOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/491] drm/i915/gmbus: fix spurious timeout on 512-byte burst reads
Date: Mon, 13 Apr 2026 17:58:49 +0200
Message-ID: <20260413155829.677788186@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
index e6b8d6dfb598e..831e99c56ecb0 100644
--- a/drivers/gpu/drm/i915/display/intel_gmbus.c
+++ b/drivers/gpu/drm/i915/display/intel_gmbus.c
@@ -420,8 +420,10 @@ gmbus_xfer_read_chunk(struct drm_i915_private *dev_priv,
 
 		val = intel_de_read_fw(dev_priv, GMBUS3);
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



