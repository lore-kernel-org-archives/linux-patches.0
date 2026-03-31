Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4B12E11A6;
	Tue, 31 Mar 2026 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976595; cv=none; b=Blh4GC3bD0NrQ1Pt2WlrcnbHsaQSS2lMVkegDqU0THdrP1NBj3byWF/XSaOkHVmwXWEfGjVB+rxX1XfAWZfqYPGoCSnPvmFhXWMmVVkSozLEa+AV3nayoF3lsIfn7njfa1on/xczUhdg6XAmGHbAtvPeFYkhSV1QhmqKjWcu/Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976595; c=relaxed/simple;
	bh=c19AXWTaCdotqGQZNzqo8aFEHE8evXlfNbm1ygkSEBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlhACoQM3HjLAkObiZo8x3scxAvTp5jkWF6ZkXjo0zxyfFj3e7KKbXhC1TYR83TL4FHzfKkuRJ7ZXHcGvIdNifdJVlmVL2b0gN0Yy/CLbnU46784Utb/Sxd/pMyUSBP9XnTu8dAxO0NVNxwliGCtVWw7ik6YojnYNwjpb6IropQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tp21jro9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tp21jro9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6D0C2BCB2;
	Tue, 31 Mar 2026 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976595;
	bh=c19AXWTaCdotqGQZNzqo8aFEHE8evXlfNbm1ygkSEBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tp21jro9cPXG7XSOlC/mAxcyD0JCjmG+2WdW29XQtwMRT0jcueIiSBAAoadjhV7G5
	 6fQDy8RQH6NeSdtJJDuwi7uFDotep/s9dOJXdBjW8tCQ1Ew7xf9KCPwxW1vpmz3gZx
	 3RlZ8jR47xvRSvNq1/jPwyVBpBgjQ5VD7CP68pak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/309] drm/i915/gmbus: fix spurious timeout on 512-byte burst reads
Date: Tue, 31 Mar 2026 18:20:56 +0200
Message-ID: <20260331161759.101585127@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 358210adb8f84..10b3f3969c960 100644
--- a/drivers/gpu/drm/i915/display/intel_gmbus.c
+++ b/drivers/gpu/drm/i915/display/intel_gmbus.c
@@ -497,8 +497,10 @@ gmbus_xfer_read_chunk(struct intel_display *display,
 
 		val = intel_de_read_fw(display, GMBUS3(display));
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



