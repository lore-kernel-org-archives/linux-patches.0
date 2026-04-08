Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDAA347517;
	Wed,  8 Apr 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671807; cv=none; b=HElQmPn35Ggd2X10WTObQYRCPzWr8Y4QdRh9nZH2j+TE9x7S9laDFuLLUR6TbVs72vAeJkzCz2Tnh+OP8SE4mYkJv9FkPsMMM6UYnsvE3YtxybShUzMc5K4l4U1H2j7fhxZZ+rqnmJNWs88r8etUYSFxgk8sD97KNpEVttWJKo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671807; c=relaxed/simple;
	bh=Pn+zGy9hJnqQ8OcCoEYaCaPYZonWqJKItHakQgw4F98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNKUTOM0gAByI+EgOXwX9tl3uPLv/+gzpbsR5LjyVkljqREkAe/3fr1e3JU9nGN4JX6IAD7oYaq2E3WYjviZKn57JQPQ4fddIwQM5u8fZ5d2Jme+S1dVsniyjHmh7AFOqC11vfUGAIFInY71y0nBEMqaYC9ypPWrN3z1elExPNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgbua57Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgbua57Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA00CC19421;
	Wed,  8 Apr 2026 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671807;
	bh=Pn+zGy9hJnqQ8OcCoEYaCaPYZonWqJKItHakQgw4F98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgbua57ZOwCWe0FBmcc3CLM683QdIdSU5PDyZjm2bfbc5D2Dl+4wnWp5BD/TER3cc
	 tyE3dOzJszx5xRCcyY/rgj5AsR8IvNzZD12UrwT4r/QhkzxtBfH1i0PIx1dNrNT9RG
	 PsS8TVlvD10iyaWb/GXzULNqkvTWnTHsqjrQAzRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/312] drm/i915/gmbus: fix spurious timeout on 512-byte burst reads
Date: Wed,  8 Apr 2026 19:59:52 +0200
Message-ID: <20260408175936.543977896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74443f57f62df..8595f7e7fc34c 100644
--- a/drivers/gpu/drm/i915/display/intel_gmbus.c
+++ b/drivers/gpu/drm/i915/display/intel_gmbus.c
@@ -470,8 +470,10 @@ gmbus_xfer_read_chunk(struct drm_i915_private *i915,
 
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



