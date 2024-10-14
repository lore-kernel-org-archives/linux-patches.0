Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098E31547F3;
	Mon, 14 Oct 2024 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915852; cv=none; b=dXiga3ZHz3xmOVwXvxQ7h8i2yuAy8vuEWM98VQhT2x7OITXvrq4Ic+CXCumC+NNSLGngQ3PXMeXJpisbFHwMyJ23GWp0VdBiF8eVlCLdOkoJX9NDGBfmIiIXNfqexBWhZJ9Y1yREGQHFA8SQVN8us8tJe2ukUs4J/QLBxxecW6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915852; c=relaxed/simple;
	bh=S89xMwi3hP1Nod/Bz9V7j2wvttpsXI23FVM3hPCZDsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aroLNiXfAVGFlfCqAwCBGReL/7zJIC9u+mbIhLAKQbw4byJvGUmEGzUAWWEA5L1YJq4VX7Xuvh0DYoiSaWrHm3SyRmd3cSm0MMxNYALnzpSO/+BckOpkiHXYQcoFHACeaWg9xq08aeJZ3rzIRf2xElclRhaxIY+/CnA7xvY/g+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDCx7fdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDCx7fdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D5EC4CEC7;
	Mon, 14 Oct 2024 14:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915851;
	bh=S89xMwi3hP1Nod/Bz9V7j2wvttpsXI23FVM3hPCZDsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDCx7fdWzVNEjkNQkl7clEfws5enxvGIF8Un8mlbNXr7f84EQ0IH9TjArQZCKVSE9
	 BbtnAqzcF7EMcDk95W7mBEkGiT03W9aM/eJ+n4JdPVWpp6fdSE4I507gSmYb1SSAl0
	 4rVJ6VZwQhwDG9uiydtkoIiS+FHaHs8sicXbjiVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinke Han <jinkehan@didiglobal.com>,
	Tao Chen <chen.dylane@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 018/214] bpf: Check percpu map value size first
Date: Mon, 14 Oct 2024 16:18:01 +0200
Message-ID: <20241014141045.703244032@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index feabc01938525..a5c6f8aa49015 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -73,6 +73,9 @@ int array_map_alloc_check(union bpf_attr *attr)
 	/* avoid overflow on round_up(map->value_size) */
 	if (attr->value_size > INT_MAX)
 		return -E2BIG;
+	/* percpu map value size is bound by PCPU_MIN_UNIT_SIZE */
+	if (percpu && round_up(attr->value_size, 8) > PCPU_MIN_UNIT_SIZE)
+		return -E2BIG;
 
 	return 0;
 }
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 06115f8728e89..bcb74ac880cb5 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -462,6 +462,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
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



