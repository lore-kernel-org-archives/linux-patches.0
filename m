Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A9C1C4A28;
	Tue, 15 Oct 2024 13:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998338; cv=none; b=jnomiERbUboxxhN4KWZCw08FUuaCN2v76v0OwUBGSQ5LWhslgjnbP1RJ3Tjrw9Py45ifczgLLzOd5ATm9lqFPtkKk/07qgI1VJa3huGTTHmkfEaiLjQ+dTHsQyR/jUgn4/2M5u1mSbhMsH1WISoMA7WMBn6mZQsuJmv1C6Zh2Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998338; c=relaxed/simple;
	bh=1XWBwjfOb5jDeuclA43mEwjKhFFjh3NwLDAG+8NJK8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4HeiWFLeJ2bMiiEpIiXSJ5BIeQDE95tznl9wMFXzR2edBzBObnxOY6wyQsIICKQsQMbaa0qL7NPSjEwqeTd9lla8pf/USEaIdPc4ebu1UgnXesYGss96WmqX3j8JIvD4Bdpv9rOiQfr2ZZbhgjPjfdKPUfMeK4t2QY74tJnFwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY3Mnzgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY3Mnzgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC019C4CEC6;
	Tue, 15 Oct 2024 13:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998338;
	bh=1XWBwjfOb5jDeuclA43mEwjKhFFjh3NwLDAG+8NJK8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zY3MnzgbmzwDO/jqS5dNRmnGTK7DDShPU0OPL5rQsLSh9c7NxbLj4HIiG0gCtCiIH
	 qYT6o8IyjBORL/caPGeZ2hlGJZ8aVd7/ZsJs3D2nwe7r5zcGhi95xWXdvTvuZVPvYK
	 cLaUqxipEU53zMWRDk40yrg6ClnUjwrzcCb5mxno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinke Han <jinkehan@didiglobal.com>,
	Tao Chen <chen.dylane@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 449/518] bpf: Check percpu map value size first
Date: Tue, 15 Oct 2024 14:45:53 +0200
Message-ID: <20241015123934.334182897@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5102338129d5f..3d92e42c3895a 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -74,6 +74,9 @@ int array_map_alloc_check(union bpf_attr *attr)
 		 * access the elements.
 		 */
 		return -E2BIG;
+	/* percpu map value size is bound by PCPU_MIN_UNIT_SIZE */
+	if (percpu && round_up(attr->value_size, 8) > PCPU_MIN_UNIT_SIZE)
+		return -E2BIG;
 
 	return 0;
 }
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 72bc5f5752543..4c7cab79d90e5 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -404,6 +404,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
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



