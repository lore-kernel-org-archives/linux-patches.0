Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824652494FE;
	Wed, 25 Feb 2026 01:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983547; cv=none; b=GLwNKL7uQURRaBAmZ84Rqm1prXqUfDsmtKEnpSEVSmW6zW31+Ou1PuUvYR9U0gCVaTtXiabAklL36nIRtVNuIaQmDaGUhSDsWrs97KDwOX8hqndLZB68t/0LUXx0/a1CpF0zQELze2NsREeThqT93SZ9y9kIHC/zUX61euAMKTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983547; c=relaxed/simple;
	bh=IuiaV2YtW4Fobt3BxeG/yTLkf7vwRyxWsLLqM7pUB8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfgccPpkjmmwg+jKKVgx2YBMIugPHz6pogn1ip2pcP/ifbK4MWSIyTltB9BDnQMO9JRIp5a/hZeu+8L9oLFXXEl17/r9BdjqK3e5IzGZ6grmMgbozVRzhKP2YnpA6jBUmmUt5yuPBtHIPwCFqnW1fH4L6viZXAC1wrQmD3iwV+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTmd6Fth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTmd6Fth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3997EC116D0;
	Wed, 25 Feb 2026 01:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983547;
	bh=IuiaV2YtW4Fobt3BxeG/yTLkf7vwRyxWsLLqM7pUB8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTmd6FthQLA0duTMyVQEBkds4kWep06OR6w3PmbAsgKuGihpV8GSglfCRxrlJZoRx
	 bbCKfPCzWruvZvbfy9vYa77GMQv0LY8YLYPi2CzNxiVymwjSlmlUjTjy1xKbHLIf0l
	 nLLT62u8IpIm9dLaNZom2NrQ3cj1gXMxuV9RFjKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 649/781] bpf: Add a map/btf from a fd array more consistently
Date: Tue, 24 Feb 2026 17:22:38 -0800
Message-ID: <20260225012415.713167793@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit b0b1a8583d8e797114e613139e3e3318a1704690 ]

The add_fd_from_fd_array() function takes a file descriptor as a
parameter and tries to add either map or btf to the corresponding
list of used objects. As was reported by Dan Carpenter, since the
commit c81e4322acf0 ("bpf: Fix a potential use-after-free of BTF
object"), the fdget() is called twice on the file descriptor, and
thus userspace, potentially, can replace the file pointed to by the
file descriptor in between the two calls. On practice, this shouldn't
break anything on the kernel side, but for consistency fix the code
such that only one fdget() is executed.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/aY689z7gHNv8rgVO@stanley.mountain/
Fixes: ccd2d799ed44 ("bpf: Fix a potential use-after-free of BTF object")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260213212949.759321-1-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a16aca34f5834..fe01edfcc34c6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24658,9 +24658,11 @@ static int add_fd_from_fd_array(struct bpf_verifier_env *env, int fd)
 		return 0;
 	}
 
-	btf = btf_get_by_fd(fd);
-	if (!IS_ERR(btf))
+	btf = __btf_get_by_fd(f);
+	if (!IS_ERR(btf)) {
+		btf_get(btf);
 		return __add_used_btf(env, btf);
+	}
 
 	verbose(env, "fd %d is not pointing to valid bpf_map or btf\n", fd);
 	return PTR_ERR(map);
-- 
2.51.0



