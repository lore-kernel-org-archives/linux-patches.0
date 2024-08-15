Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742201AC8BB;
	Thu, 15 Aug 2024 14:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731391; cv=none; b=YLnFxusrqgPSg4YUounNH5XFyuFGiss4qBu1Ykr48w4RrvTB/z3B3/glb8enIlr3GG/XkyEjNZICmS7Rb6K50EAb+SQJvKRFE4D1P0806yoMSiaDE+ofG6Bx0NTvobqCP7TLu5KX4+W/AyPljg1HzG2E25+yT6UN1F5wqEaDfyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731391; c=relaxed/simple;
	bh=CPqHFATPY3MLKG7J+fwQD8Z2aHXkT+rNkWkdfiL8m0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fit7nrce1marDkuJKPtCUZ2dL9IhMLfiCno4yKbZbYZgAgfQ2FTt/yFZ7x3LyQ0wWldSO2twmcyauG9/NuOzFAKAmezmRvD4rgQoNO/A8I+NK0dIAtY3sVEX2hZnbqU8ujYayIVnHxLIXu3Xau7/qqAFom0M1GnWiHjXvlG8nB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OS6579PZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OS6579PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F062CC4AF0C;
	Thu, 15 Aug 2024 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731391;
	bh=CPqHFATPY3MLKG7J+fwQD8Z2aHXkT+rNkWkdfiL8m0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OS6579PZiVXnDRBHYhSEkNCUYT6UdnsN5E76I7udUZ+dHdvUM6EUe2U5mPDLPffgL
	 LIQ/C6h/x2b9LP5GPQ2RpHikQmqYw5xjnXiJrvBXUqbS1BLXRW2wpa1t6I/Lm3RVFg
	 6RyDx3PbljPTg/5K1MdnicE6e+OwOGB7b9qFzGo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Lk Sii <lk_sii@163.com>
Subject: [PATCH 5.4 114/259] kobject_uevent: Fix OOB access within zap_modalias_env()
Date: Thu, 15 Aug 2024 15:24:07 +0200
Message-ID: <20240815131907.202503337@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit dd6e9894b451e7c85cceb8e9dc5432679a70e7dc upstream.

zap_modalias_env() wrongly calculates size of memory block to move, so
will cause OOB memory access issue if variable MODALIAS is not the last
one within its @env parameter, fixed by correcting size to memmove.

Fixes: 9b3fa47d4a76 ("kobject: fix suppressing modalias in uevents delivered over netlink")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Lk Sii <lk_sii@163.com>
Link: https://lore.kernel.org/r/1717074877-11352-1-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kobject_uevent.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -432,8 +432,23 @@ static void zap_modalias_env(struct kobj
 		len = strlen(env->envp[i]) + 1;
 
 		if (i != env->envp_idx - 1) {
+			/* @env->envp[] contains pointers to @env->buf[]
+			 * with @env->buflen chars, and we are removing
+			 * variable MODALIAS here pointed by @env->envp[i]
+			 * with length @len as shown below:
+			 *
+			 * 0               @env->buf[]      @env->buflen
+			 * ---------------------------------------------
+			 * ^             ^              ^              ^
+			 * |             |->   @len   <-| target block |
+			 * @env->envp[0] @env->envp[i]  @env->envp[i + 1]
+			 *
+			 * so the "target block" indicated above is moved
+			 * backward by @len, and its right size is
+			 * @env->buflen - (@env->envp[i + 1] - @env->envp[0]).
+			 */
 			memmove(env->envp[i], env->envp[i + 1],
-				env->buflen - len);
+				env->buflen - (env->envp[i + 1] - env->envp[0]));
 
 			for (j = i; j < env->envp_idx - 1; j++)
 				env->envp[j] = env->envp[j + 1] - len;


