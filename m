Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5962E1F668E;
	Wed,  6 Nov 2024 13:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898636; cv=none; b=OL5Y7LxPJpCbmGK3D7aP7LlwjM2ylwsQBZw96EF3rtNuUz0Fp8RnUvyWkursLlTonVVyjCMErruFN6UUAtDB16Abd8mx8ZdmSCQRnMQ5aVB6ppb6zyneKYe3G6l25XRFDYJbhhSlbVpxVJTWEXg4AFNQfatjFQp2EhfQADnexDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898636; c=relaxed/simple;
	bh=TtaYoFdB52ErsYi4nBWWAjDRCgEIhOmPKGUcOvCbhNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6M4FXqKhb43dYetLfCOkKec2B5377bX9UicgrR7Q+Fz4e5n9OgQe8q/jvO5VQpoTuFYyHWEKaxIJJyZuxH6mkd8yjKyMAvXh4YfX+MSGlmScksps8kmmfB1LlcizNFWs12uRPFB0V0UHamlJHXnTU9Xvo5Z+HF+WYXqBgqS1cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ku06WTdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ku06WTdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D080BC4CECD;
	Wed,  6 Nov 2024 13:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898636;
	bh=TtaYoFdB52ErsYi4nBWWAjDRCgEIhOmPKGUcOvCbhNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ku06WTdX9bvOm4B/oMt5el6IUnczTZfh76M0Bz/JduACM/zZTEPWB7QF82yjncCr3
	 61sWuPPbyYvSLhuE3XTaU8RsfQEoQBoaV7JgpmTjGD04poCoMHWfwkaAcSXvi7iHzC
	 p4JNOzXVufxOT0DHzcVd2MOCdcnPNCLORDFOnvFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinke Han <jinkehan@didiglobal.com>,
	Tao Chen <chen.dylane@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 303/462] bpf: Check percpu map value size first
Date: Wed,  6 Nov 2024 13:03:16 +0100
Message-ID: <20241106120339.012315202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@gmail.com>

[ Upstream commit 1d244784be6b01162b732a5a7d637dfc024c3203 ]

Percpu map is often used, but the map value size limit often ignored,
like issue: https://github.com/iovisor/bcc/issues/2519. Actually,
percpu map value size is bound by PCPU_MIN_UNIT_SIZE, so we
can check the value size whether it exceeds PCPU_MIN_UNIT_SIZE first,
like percpu map of local_storage. Maybe the error message seems clearer
compared with "cannot allocate memory".

Signed-off-by: Jinke Han <jinkehan@didiglobal.com>
Signed-off-by: Tao Chen <chen.dylane@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240910144111.1464912-2-chen.dylane@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c | 3 +++
 kernel/bpf/hashtab.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 81ed9b79f4019..af90c4498e80e 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -64,6 +64,9 @@ int array_map_alloc_check(union bpf_attr *attr)
 		 * access the elements.
 		 */
 		return -E2BIG;
+	/* percpu map value size is bound by PCPU_MIN_UNIT_SIZE */
+	if (percpu && round_up(attr->value_size, 8) > PCPU_MIN_UNIT_SIZE)
+		return -E2BIG;
 
 	return 0;
 }
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 34c4f709b1ede..0d14a2a11463a 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -288,6 +288,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 		 * kmalloc-able later in htab_map_update_elem()
 		 */
 		return -E2BIG;
+	/* percpu map value size is bound by PCPU_MIN_UNIT_SIZE */
+	if (percpu && round_up(attr->value_size, 8) > PCPU_MIN_UNIT_SIZE)
+		return -E2BIG;
 
 	return 0;
 }
-- 
2.43.0



