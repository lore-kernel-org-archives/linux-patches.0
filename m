Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FBE37F31A;
	Thu, 20 Aug 2026 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238694; cv=none; b=hAFuTuj3965eEBPuCXeI6WmV0eS3pRrgkiUh1/k4q2FlQCOySqyrdK68BjGCFXU82X33RN9NEwcHoLIB/G9Rc13WovqKvFq6l7VWdCckQoNbQUY6/kKtft/lykr9Ep8yVpHK+mliK2ARd62nAa4oqx39D9NnWrQQHQWou1avKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238694; c=relaxed/simple;
	bh=h7I7ZhpoK0lQMIFGtysbLlLsc9UaKmZR2UNdVxrfBYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFspHdFI8JNHlehLEFQNBLx7xyiS+BTZELkS1oTOl65+1EXocaLfpTysrc7/TPJpY+XVM7/p5Qe7W1KpIR5PAXw8kerPX3aKetdUYRmuKRpoM9feiDeDCj13JG72g7AbyYBYJxtUcGPIYotAWWgtBIYSbFyC3sGpIU6vNxZWoJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNg+UuVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNg+UuVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11571F000E9;
	Thu, 20 Aug 2026 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238691;
	bh=3mV8G0hIm1cpFdJme6ipS/avXGFCnY9PP0dcHtL53jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNg+UuVKkRZrZ9+LxPSc4U0QukD7ewI0xUY4HkTMeuTmnihSl6imjYJM283U72Asy
	 DSqOz3/uvACK05rOtwXhs0w/a1Jmn7K7ixG6HRh23UL1Tw+L19LhHKm/ZPTfaXDlB2
	 gDYl3r4gwHYKQSGJz4fxf2mFsAzxQvr/u1GPLKH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 225/228] drm/log: Fix out-of-bounds read on empty message length
Date: Thu, 20 Aug 2026 16:56:07 +0200
Message-ID: <20260820145251.919166158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 60baa179ed1333535f6e2da4133511db55278ee4 ]

drm_log_draw_kmsg_record() accesses s[len - 1] to strip the trailing
newline, but len is unsigned int. If len is 0, the subtraction wraps
to UINT_MAX, causing an out-of-bounds read.

Add an early return when len is 0.

Fixes: 25e2c2a3eff5 ("drm/log: Color the timestamp, to improve readability")
Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patch.msgid.link/20260729084520.688087-1-oushixiong1025@163.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/clients/drm_log.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/clients/drm_log.c b/drivers/gpu/drm/clients/drm_log.c
index a3259b8f23333..f23a92f826c92 100644
--- a/drivers/gpu/drm/clients/drm_log.c
+++ b/drivers/gpu/drm/clients/drm_log.c
@@ -160,6 +160,9 @@ static void drm_log_draw_kmsg_record(struct drm_log_scanout *scanout,
 {
 	u32 prefix_len = 0;
 
+	if (!len)
+		return;
+
 	if (len > TS_PREFIX_LEN && s[0] == '[' && s[6] == '.' && s[TS_PREFIX_LEN] == ']')
 		prefix_len = TS_PREFIX_LEN + 1;
 
-- 
2.53.0



