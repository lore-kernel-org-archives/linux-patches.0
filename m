Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E391B3DD507;
	Tue, 31 Mar 2026 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974439; cv=none; b=n2ofVxFEXWeo4p73naZgKxAPEVFD5YwyonpK3qe80hPz2ZFFS1loskRQfoFpp4q3CO14S9rHrlKz/FNYiMilaDAj1pFRZnYdX64O7C35NALPHy41OjU4Ynqh0k44l7RQb2IB8rk0FD1Nr4J7rJwkTLjy2xhvL5JBb06Pq/xEmLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974439; c=relaxed/simple;
	bh=7AJQghWNnWJDLtpotECSiHq000wNjL9mikXL6CROTP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N56jwHYvuqZcuEcN/qB2REN2+ZUAaWRXt/mmXeZ9lITNvmjBOyGbqVg3vbys1SFHYHW+ceDBJNyQ+qliVzuFMHhjJ8//roOf8uj/nc66dpRojldDVoUyUvQ4mdLiXXSIYoyPYjiUDnKnxbslQH6DjVf8ru5QDJ5tX7NjjkkfKu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IDvL2TH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IDvL2TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CC7C19423;
	Tue, 31 Mar 2026 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974438;
	bh=7AJQghWNnWJDLtpotECSiHq000wNjL9mikXL6CROTP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IDvL2THlxYer25w5waiL4nfVAyojh3msfhZkdz0Pn0Cja4OJExZI1fZvbHu1gRcn
	 neUKBKnqxRTgPn49iAq/H+mD3rT/P1jkrcC0YHlLoiEXpjejvwe2rp77tjmPLmYzQa
	 L85HmUaS1yaeUsPo9IJOdzkougc8X9XiKZaWfZNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/175] drm/i915/gmbus: fix spurious timeout on 512-byte burst reads
Date: Tue, 31 Mar 2026 18:21:10 +0200
Message-ID: <20260331161732.931341680@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index e95ddb580ef6c..a01e655c24ff3 100644
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



