Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CB220EB;
	Mon, 14 Oct 2024 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916761; cv=none; b=u8MiAaBfiOPG3BhV+LuQwyrxn6fzd5taCeDIGzcU0SWy24aI3ezM4GkgeKzlPSh2d7YuMkiJIyUAVjjwPJuCG6X29pQ0dgMg70qqEI/TL/Nmrod6To/gRNGsXq3MLztgiy4fBbfzmFFFmX+h0o3l9mv+uTY/Q5Srd0eM8SgAPZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916761; c=relaxed/simple;
	bh=b0SSWBybF3GCExOsHkSklEtOaAsHAe13ZyrMlFZb6bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCpHcIaKiLhP4ALtDpIvC/E/3lYKW7HFCCyb9O+8fIiqahVKIGWEZYBGMGc60qytmegB50Q5NLwGqhmOejR0Dj5pzAhhRRBxSV0ee+s89sYXo6IhoBD6EJdo/Baszk7/l0T4wEhrVFaBPnYRsYyVLXF92VOjyxB+5LPT4tTpgrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qELWplMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qELWplMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55118C4CEC3;
	Mon, 14 Oct 2024 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916760;
	bh=b0SSWBybF3GCExOsHkSklEtOaAsHAe13ZyrMlFZb6bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qELWplMpVwGXDKPkbzVDTJWXYjCRZJDIo1YcZjeiCC8FtFWXWrMW+fd7U+S7qd8RY
	 98WBfirqGcJOFdtm+Ya1uRL9cNw6i9pNuWaOxxoEb6L/NtK2CqZr89wlg8m7ry8GYk
	 nBkvs12NejJK9CsuRHGovXR6lrl54i8r7H4TNa3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinke Han <jinkehan@didiglobal.com>,
	Tao Chen <chen.dylane@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/213] bpf: Check percpu map value size first
Date: Mon, 14 Oct 2024 16:19:23 +0200
Message-ID: <20241014141045.216115925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c9843dde69081..1811efcfbd6e3 100644
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
index 85cd17ca38290..7c64ad4f3732b 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -458,6 +458,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
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



