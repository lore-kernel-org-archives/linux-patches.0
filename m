Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B89139D0B;
	Mon, 14 Oct 2024 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919712; cv=none; b=YVwWgqMf6za/PXgZVSUL2+Ud6xxr/Df16ZR7f4XZntYEme63xRreqqU40aZfrKoDZ9dJEruZxgK8UwKLizMoj/Te5XvkBp1y5sXf11KsqH9LN53UqMRByG90MMaXHzQ3Cn32LNcdZ/Q97KUwzvPo9bz6UrHJSBtGctt5p1e/3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919712; c=relaxed/simple;
	bh=HnQWgTpI88+m+JLikmCy+Cma07ll0wM8VR/ZmTRW1UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm/jmo5H+EqBkPAtvNmzHQ4WmxRevIwoRz/+zZF4VFw0YQBJm2+b9+kBPpQ/1diOgB8fV99BobZD3I698aBPVO3ZxUtFkgr3mFDzAQRjS4VUDpvsyy3Y8+VMeIlCNH8F7/0zO5uk8oQSO9RC/cWqjQlUaBefYnXoFMJgGcwXZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuN5SWh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuN5SWh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46727C4CEC3;
	Mon, 14 Oct 2024 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919712;
	bh=HnQWgTpI88+m+JLikmCy+Cma07ll0wM8VR/ZmTRW1UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuN5SWh41CIFICLXyHHNzXRQ86Yyj22Q+CR8xZrskDXxNnIPbhkd2poRdmezJoV1I
	 AlFIIhTEGCvsseZomDYSVHOElhz1YuX6IxAGALzpYmR3oCxxyySkUbok4LntCOv4NG
	 e6Xu97QzR2LbIrtd01yETDhYKBm42gWsxb/6BiqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinke Han <jinkehan@didiglobal.com>,
	Tao Chen <chen.dylane@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 686/798] bpf: Check percpu map value size first
Date: Mon, 14 Oct 2024 16:20:40 +0200
Message-ID: <20241014141245.020462589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c04e69f34e4d5..50b9bf57a4e3e 100644
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
index 0c74cc9012d5c..dae9ed02a75be 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -455,6 +455,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
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



