Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD81265CAF;
	Tue,  8 Apr 2025 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111323; cv=none; b=MKLyFcBDEZ1Tm3pCQsVsJZnSTaTv33LyLVmw7Aq63otRQY8Qx0DR1MbJlv6lSnMSbawLBwXxJzHcZPUeqDPIK/90oGz6BBTskFoqiyfXDcKUIw2TFnobMY1Nvsl0ixOqsL3Rk/59MkqE/UwY61/sneEcaCbHe8Tvyv/4GDm537c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111323; c=relaxed/simple;
	bh=BQAvGfx5yzTG/a/gbshQhGksIzdV5VvGNPLWYGrcBJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3RCQRSyk0Tg7RG/5wwAYvGGuAEJacBda8RLqh4lOHs/+4NAAybpMWVz+5WP3iZTAl70RLpHLkKE7jhUMrEfctFBJzub2wjkds+FoccJNIwrUiIRrcj5OjxiWLGhAPYUbaCqb5i21RBBTLUF9KXUMweCXTpCMeVfvN1iXXQ5FGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvWckOGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvWckOGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8022C4CEE5;
	Tue,  8 Apr 2025 11:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111323;
	bh=BQAvGfx5yzTG/a/gbshQhGksIzdV5VvGNPLWYGrcBJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvWckOGDEIIaD+xj/gJaXo9FBVGusnW6CjFYsxE2kQZYqApSLnFldXDeVqfnGGKAl
	 p8OMJCID7lh9gW6YcItnpn+9+wTr3UNWJRW3xr8CFSsCB7Lj31c90dF/Am2Untj9r2
	 J48FidqmiMk1GxWgIvsjps31q14gbrK2JbZ378mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 391/731] selftests/bpf: Fix freplace_link segfault in tailcalls prog test
Date: Tue,  8 Apr 2025 12:44:48 +0200
Message-ID: <20250408104923.370686259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit a63a631c9b5cb25a1c17dd2cb18c63df91e978b1 ]

There are two bpf_link__destroy(freplace_link) calls in
test_tailcall_bpf2bpf_freplace(). After the first bpf_link__destroy()
is called, if the following bpf_map_{update,delete}_elem() throws an
exception, it will jump to the "out" label and call bpf_link__destroy()
again, causing double free and eventually leading to a segfault.

Fix it by directly resetting freplace_link to NULL after the first
bpf_link__destroy() call.

Fixes: 021611d33e78 ("selftests/bpf: Add test to verify tailcall and freplace restrictions")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20250122022838.1079157-1-wutengda@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tailcalls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
index 544144620ca61..66a900327f912 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -1600,6 +1600,7 @@ static void test_tailcall_bpf2bpf_freplace(void)
 		goto out;
 
 	err = bpf_link__destroy(freplace_link);
+	freplace_link = NULL;
 	if (!ASSERT_OK(err, "destroy link"))
 		goto out;
 
-- 
2.39.5



